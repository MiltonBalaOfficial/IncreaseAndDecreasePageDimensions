-- Declare global variables
local shapes_dict, sep, sourcePath
local widthInitial, heightInitial, workingLayer
local toggleMenuCmPercent, toggleMenuFillEmpty


-- Function to initialize the UI
function initUi()
    sep = package.config:sub(1, 1) -- Determine OS-specific path separator
    sourcePath = debug.getinfo(1).source:match("@?(.*" .. sep .. ")")

    updateSettings() -- Load data from page_adjust_config.lua when the function is called

    -- Define actions for toolbar and menu
    local actions = {
        {menu = "Increase Right", callback = "increaseSizeRight", accelerator = "<Alt>2", toolbarId = "increaseSizeRight", iconName = "IncreaseDimRight"},
        {menu = "Decrease Right", callback = "decreaseSizeRight", accelerator = "<Alt>3", toolbarId = "decreaseSizeRight", iconName = "DecreaseDimRight"},
        {menu = "Increase Bottom", callback = "increaseSizeDown", accelerator = "<Alt>4", toolbarId = "increaseSizeDown", iconName = "IncreaseDimBottom"},
        {menu = "Decrease Bottom", callback = "decreaseSizeDown", accelerator = "<Alt>5", toolbarId = "decreaseSizeDown", iconName = "DecreaseDimDown"},
        {menu = "Increase Right All", callback = "increaseSizeRightAll", toolbarId = "increaseSizeRightAll", iconName = "IncreaseDimRightAll"},
        {menu = "Decrease Right All", callback = "decreaseSizeRightAll", toolbarId = "decreaseSizeRightAll", iconName = "DecreaseDimRightAll"},
        {menu = "Increase Bottom All", callback = "increaseSizeDownAll", toolbarId = "increaseSizeDownAll", iconName = "IncreaseDimBottomAll"},
        {menu = "Decrease Bottom All", callback = "decreaseSizeDownAll", toolbarId = "decreaseSizeDownAll", iconName = "DecreaseDimDownAll"},
        {menu = "Toggle 'Adjustment Type' [%-based/cm-based]", callback = "toggleDocumentBasedAdjustment", toolbarId = "toggleDocumentBasedAdjustment", iconName = "TogglePercentage_cm"},
        {menu = "Toggle 'Fill Empty Space' [ON/OFF]", callback = "toggleWantFillEmptySpace", toolbarId = "fillEmptySpace", iconName = "ToggleFillEmpty"}
    }

    -- Register UI actions
    for _, action in ipairs(actions) do
        app.registerUi(action) -- Resister all the actions one by one
    end
end


-- Function to load page_adjust_config.lua file for data
function loadConfig()
    local configFilePath = sourcePath .. "page_adjust_config.lua"
    return dofile(configFilePath)
end


-- Function to update settings from the page_adjust_config.lua file
function updateSettings()
    local config = loadConfig()
    adjustmentStep = config.adjustmentStep
    useCentimeters = config.useCentimeters
    cmToPointFactor = config.cmToPointFactor
    documentBasedAdjustment = config.documentBasedAdjustment
    documentBasedAdjustmentFactorIncrease = config.documentBasedAdjustmentFactorIncrease
    documentBasedAdjustmentFactorDecrease = config.documentBasedAdjustmentFactorDecrease
    wantFillEmptySpace = config.wantFillEmptySpace
end


-- Function to calculate step size
local function getStepSize(forAllPages, dimension, factorIncrease, factorDecrease)
    local docStructure = app.getDocumentStructure()
    local pages = forAllPages and docStructure["pages"] or {docStructure["pages"][docStructure["currentPage"]]}

    for _, page in ipairs(pages) do
        local dimValue = page[dimension]
        if useCentimeters then
            return adjustmentStep * cmToPointFactor
        elseif documentBasedAdjustment then
            return dimValue * (factorIncrease or factorDecrease)
        else
            return adjustmentStep
        end
    end
end


--The function to get the initial layer information
function workingLayerInfo()
    -- Get the initial page structure and the current page
    local docStructureInitial = app.getDocumentStructure()
    local pageInitial = docStructureInitial["pages"][docStructureInitial["currentPage"]]
    
    -- Set the working layer to the current layer of the page
    workingLayer = pageInitial["currentLayer"]
    
    -- Store initial dimensions
    widthInitial = pageInitial["pageWidth"]
    heightInitial = pageInitial["pageHeight"]
end
    

--Insert filled box and handle layers
function fillEmptySpace()
    local docStructureFinal = app.getDocumentStructure()
    local pageFinal = docStructureFinal["pages"][docStructureFinal["currentPage"]]
    
    -- Get final page dimensions after adjustment
    local widthFinal = pageFinal["pageWidth"]
    local heightFinal = pageFinal["pageHeight"]
    
    -- Get the active pen color for the filled strokes
    local activeColor = app.getToolInfo("pen")["color"]
    
    -- Initialize the filled box strokes
    local filledBoxRight = nil
    local filledBoxBottom = nil
    
    -- Check if the width has increased and prepare a stroke for the right side
    if widthFinal > widthInitial then -- If it is not checked then a line appears for the other dimension
        filledBoxRight = {
            x = {widthInitial, widthFinal, widthFinal, widthInitial, widthInitial},
            y = {0, 0, heightFinal, heightFinal, 0},
            width = 2,
            fill = 255,
            tool = "pen",
            color = activeColor,
        }
    end

    -- Check if the height has increased and prepare a stroke for the bottom side
    if heightFinal > heightInitial then -- If it is not checked then a line appears for the other dimension
        filledBoxBottom = {
            x = {0, widthFinal, widthFinal, 0, 0},
            y = {heightInitial, heightInitial, heightFinal, heightFinal, heightInitial},
            width = 2,
            fill = 255,
            tool = "pen",
            color = activeColor,
        }
    end

    -- Get the current layers count
    local layerCount = #pageFinal["layers"]
    
    -- Set the current layer to layer 1 for inserting the fill box
    app.setCurrentLayer(1, false)

    -- Insert the filled box strokes into layer 1
    if filledBoxRight and filledBoxBottom then
        app.addStrokes { strokes = { filledBoxRight, filledBoxBottom }, allowUndoRedoAction = "grouped" }
    elseif filledBoxBottom then
        app.addStrokes { strokes = { filledBoxBottom }, allowUndoRedoAction = "grouped" }
    elseif filledBoxRight then
        app.addStrokes { strokes = { filledBoxRight }, allowUndoRedoAction = "grouped" }
    end
    
    -- Create a new layer if only one layer exists
    if layerCount == 1 then
        -- Create a new layer and switch to it
        app.uiAction({action = "ACTION_NEW_LAYER" })
        app.setCurrentLayer(2, false)
    else
        -- Switch back to the previous working layer if there are multiple layers
        app.setCurrentLayer(workingLayer, false)
    end

    -- Refresh the page to apply the changes
    app.refreshPage()
end


-- Function to set new page size and fill if wanted (this is the main function)
function adjustPageSize(amountWidth, amountHeight, forAllPages, wantFill, isIncrease)
    local docStructure = app.getDocumentStructure()
    local pages = forAllPages and docStructure["pages"] or {docStructure["pages"][docStructure["currentPage"]]}
    
    for p, page in ipairs(pages) do
        local width, height = page["pageWidth"], page["pageHeight"]

        if forAllPages then 
            app.setCurrentPage(p) 
        end

        if wantFill then  -- if fill is wanted then layer information is extracted before filling the empty space
            workingLayerInfo() 
        end

        app.setPageSize(width + amountWidth, height + amountHeight) 

        if wantFill and isIncrease then 
            fillEmptySpace() 
        end
    end
end


-- Functions for individual page adjustments
function increaseSizeRight() 
    adjustPageSize(getStepSize(false, "pageWidth", documentBasedAdjustmentFactorIncrease), 0, false, wantFillEmptySpace, true) 
end
function decreaseSizeRight() 
    adjustPageSize(-getStepSize(false, "pageWidth", nil, documentBasedAdjustmentFactorDecrease), 0, false, wantFillEmptySpace, false) 
end
function increaseSizeDown() 
    adjustPageSize(0, getStepSize(false, "pageHeight", documentBasedAdjustmentFactorIncrease), false, wantFillEmptySpace, true) 
end
function decreaseSizeDown() 
    adjustPageSize(0, -getStepSize(false, "pageHeight", nil, documentBasedAdjustmentFactorDecrease), false, wantFillEmptySpace, false) 
end

-- Functions for all pages adjustments
function increaseSizeRightAll() 
    adjustPageSize(getStepSize(true, "pageWidth", documentBasedAdjustmentFactorIncrease), 0, true, wantFillEmptySpace, true) 
end
function decreaseSizeRightAll() 
    adjustPageSize(-getStepSize(true, "pageWidth", nil, documentBasedAdjustmentFactorDecrease), 0, true, wantFillEmptySpace, false) 
end
function increaseSizeDownAll() 
    adjustPageSize(0, getStepSize(true, "pageHeight", documentBasedAdjustmentFactorIncrease), true, wantFillEmptySpace, true) 
end
function decreaseSizeDownAll() 
    adjustPageSize(0, -getStepSize(true, "pageHeight", nil, documentBasedAdjustmentFactorDecrease), true, wantFillEmptySpace, false) 
end


-- Function to handle toggles (Checks the config file for boolean value, based on the value it writes opposite value and at last call the function to load the file again)
local function toggleSetting(settingName, onMessage, offMessage)
    local configFilePath = sourcePath .. "page_adjust_config.lua"
    local lines = {}

    for line in io.lines(configFilePath) do
        table.insert(lines, line)
    end

    for i, line in ipairs(lines) do
        if line:match(settingName .. "%s*=%s*(%a+)") then
            local currentValue = line:match(settingName .. "%s*=%s*(%a+)")
            local newValue = (currentValue == "true") and "false" or "true"
            lines[i] = line:gsub(currentValue, newValue)
            -- Toggle complete message
            app.msgbox(newValue == "true" and onMessage or offMessage, {[1] = "OK"})--This works on older version of Xournalapp
            --app.openDialog(newValue == "true" and onMessage or offMessage, {[1] = "OK"}) -- This is for newer versions of xournalapp
            break
        end
    end

    local file = io.open(configFilePath, "w")
    file:write(table.concat(lines, "\n") .. "\n")
    file:close()
    updateSettings()-- Load data from page_adjust_config.lua again after Toggle is completed, so that plugin can get new values
end


-- Toggling functions
function toggleDocumentBasedAdjustment()
    toggleSetting("config.documentBasedAdjustment", "Adjustment Type is now set to [%-based]", "Adjustment Type is now set to [cm-based]")
end

function toggleWantFillEmptySpace()
    toggleSetting("config.wantFillEmptySpace", "'Fill Empty Space' is now set [on]", "'Fill Empty Space' is now set [off]")
end
    

--I am not a professional developer, so the code might not be fully optimized. I genuinely welcome any suggestions for improvement.