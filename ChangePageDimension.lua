local shapes_dict, sep, sourcePath

-- Register all Toolbar actions and initialize all UI stuff
function initUi()
    -- Getting the source folder Path (The plugin folder-path)
    sep = package.config:sub(1, 1) -- path separator depends on OS
    sourcePath = debug.getinfo(1).source:match("@?(.*" .. sep .. ")")

    toggleMenuNameBothAdjustment() -- for getting the menu name based upon the toggle state
    
    local actions = {{
        menu = "Increase Right",
        callback = "increaseSizeRight",
        accelerator = "<Alt>2",
        toolbarId = "increaseSizeRight",
        iconName = "IncreaseDimRight"
    }, {
        menu = "Decrease Right",
        callback = "decreaseSizeRight",
        accelerator = "<Alt>3",
        toolbarId = "decreaseSizeRight",
        iconName = "DecreaseDimRight"
    }, {
        menu = "Increase Bottom",
        callback = "increaseSizeDown",
        accelerator = "<Alt>4",
        toolbarId = "increaseSizeDown",
        iconName = "IncreaseDimBottom"
    }, {
        menu = "Decrease Bottom",
        callback = "decreaseSizeDown",
        accelerator = "<Alt>5",
        toolbarId = "decreaseSizeDown",
        iconName = "DecreaseDimDown"
    }, {
        menu = "Increase Right All",
        callback = "increaseSizeRightAll",
        toolbarId = "increaseSizeRightAll",
        iconName = "IncreaseDimRightAll"
    }, {
        menu = "Decrease Right All",
        callback = "decreaseSizeRightAll",
        toolbarId = "decreaseSizeRightAll",
        iconName = "DecreaseDimRightAll"
    }, {
        menu = "Increase Bottom All",
        callback = "increaseSizeDownAll",
        toolbarId = "increaseSizeDownAll",
        iconName = "IncreaseDimBottomAll"
    }, {
        menu = "Decrease Bottom All",
        callback = "decreaseSizeDownAll",
        toolbarId = "decreaseSizeDownAll",
        iconName = "DecreaseDimDownAll"
    }}

    for _, action in ipairs(actions) do
        app.registerUi(action)
    end
    app.registerUi({ -- For toggling Document Based Adjustment
        menu = toggleMenuCmPercent,--"Toggle Document Based Adjustment",
        callback = "toggleDocumentBasedAdjustment",
        toolbarId = "toggleDocumentBasedAdjustment",
        iconName = "TogglePercentage_cm"
    })
    app.registerUi({ -- For toggling Document Based Adjustment
        menu = toggleMenuFillEmpty,
        callback = "toggleWantFillEmptySpace",
        toolbarId = "fillEmptySpace",
        iconName = "ToggleFillEmpty"
    })
end

-- Load the configuration from a separate file
local config = require("page_adjust_config")

-- Access the configuration variables using the `config` table
local adjustmentStep = config.adjustmentStep
local useCentimeters = config.useCentimeters
local cmToPointFactor = config.cmToPointFactor
local documentBasedAdjustment = config.documentBasedAdjustment
local documentBasedAdjustmentFactorIncrease = config.documentBasedAdjustmentFactorIncrease
local documentBasedAdjustmentFactorDecrease = config.documentBasedAdjustmentFactorDecrease
local wantFillEmptySpace = config.wantFillEmptySpace

-- Function to get the step size for increasing the width
local function getStepSizeIncreaseWidth(forAllPages)
    local docStructure = app.getDocumentStructure()

    -- Determine which pages to process
    local pages
    if forAllPages then
        pages = docStructure["pages"] -- All pages
    else
        pages = {docStructure["pages"][docStructure["currentPage"]]} -- Current page only
    end

    for _, page in ipairs(pages) do
        local width = page["pageWidth"]

        if useCentimeters then
            -- Return the step size in cm if useCentimeters is true
            return adjustmentStep * cmToPointFactor
        elseif documentBasedAdjustment then
            -- If documentBasedAdjustment is true, return the the step size as % of page dimension
            return width * documentBasedAdjustmentFactorIncrease
        else
            -- Otherwise, return the default step size
            return adjustmentStep
        end
    end
end
-- Function to get the step size for decreasing the width
local function getStepSizeDecreaseWidth(forAllPages)
    local docStructure = app.getDocumentStructure()

    -- Determine which pages to process
    local pages
    if forAllPages then
        pages = docStructure["pages"] -- All pages
    else
        pages = {docStructure["pages"][docStructure["currentPage"]]} -- Current page only
    end

    for _, page in ipairs(pages) do
        local width = page["pageWidth"]

        if useCentimeters then
            -- Return the step size in cm if useCentimeters is true
            return adjustmentStep * cmToPointFactor
        elseif documentBasedAdjustment then
            -- If documentBasedAdjustment is true, return the the step size as % of page dimension
            return width * documentBasedAdjustmentFactorDecrease
        else
            -- Otherwise, return the default step size
            return adjustmentStep
        end
    end
end
-- Function to get the step size for increasing the width
local function getStepSizeIncreaseHeight(forAllPages)
    local docStructure = app.getDocumentStructure()

    -- Determine which pages to process
    local pages
    if forAllPages then
        pages = docStructure["pages"] -- All pages
    else
        pages = {docStructure["pages"][docStructure["currentPage"]]} -- Current page only
    end

    for _, page in ipairs(pages) do
        local height = page["pageHeight"]

        if useCentimeters then
            -- Return the step size in cm if useCentimeters is true
            return adjustmentStep * cmToPointFactor
        elseif documentBasedAdjustment then
            -- If documentBasedAdjustment is true, return the the step size as % of page dimension
            return height * documentBasedAdjustmentFactorIncrease
        else
            -- Otherwise, return the default step size
            return adjustmentStep
        end
    end
end
-- Function to get the step size for decreasing the width
local function getStepSizeDecreaseHeight(forAllPages)
    local docStructure = app.getDocumentStructure()

    -- Determine which pages to process
    local pages
    if forAllPages then
        pages = docStructure["pages"] -- All pages
    else
        pages = {docStructure["pages"][docStructure["currentPage"]]} -- Current page only
    end

    for _, page in ipairs(pages) do
        local height = page["pageHeight"]

        if useCentimeters then
            -- Return the step size in cm if useCentimeters is true
            return adjustmentStep * cmToPointFactor
        elseif documentBasedAdjustment then
            -- If documentBasedAdjustment is true, return the the step size as % of page dimension
            return height * documentBasedAdjustmentFactorDecrease
        else
            -- Otherwise, return the default step size
            return adjustmentStep
        end
    end
end

-- Helper function to adjust the size of pages in the document
-- @param amountWidth: Change in page width
-- @param amountHeight: Change in page height
-- @param forAllPages: If true, apply the change to all pages; otherwise, only the current page

function adjustPageSize(amountWidth, amountHeight, forAllPages, wantFill)
    local docStructure = app.getDocumentStructure()

    -- Determine which pages to process
    local pages
    if forAllPages then
        pages = docStructure["pages"] -- All pages
    else
        pages = {docStructure["pages"][docStructure["currentPage"]]} -- Current page only
    end

    for p, page in ipairs(pages) do
        local width = page["pageWidth"]
        local height = page["pageHeight"]
        if forAllPages then
            app.setCurrentPage(p)
        end -- Set page if processing all pages
        if wantFill then
            workingLayerInfo()
            app.setPageSize(width + amountWidth, height + amountHeight)
            fillEmptySpace()
            else
            app.setPageSize(width + amountWidth, height + amountHeight)
            end 
    end
end


-- Individual action functions
function increaseSizeRight()
    adjustPageSize(getStepSizeIncreaseWidth(), 0, false, wantFillEmptySpace)
end
function decreaseSizeRight()
    adjustPageSize(-getStepSizeDecreaseWidth(), 0, false, wantFillEmptySpace)
end
function increaseSizeDown()
    adjustPageSize(0, getStepSizeIncreaseHeight(), false, wantFillEmptySpace)
end
function decreaseSizeDown()
    adjustPageSize(0, -getStepSizeDecreaseHeight(), false, wantFillEmptySpace)
end

-- All-pages action functions
function increaseSizeRightAll()
        adjustPageSize(getStepSizeIncreaseWidth(true), 0, true, wantFillEmptySpace)
end
function decreaseSizeRightAll()
    adjustPageSize(-getStepSizeDecreaseWidth(true), 0, true, wantFillEmptySpace)
end
function increaseSizeDownAll()
    adjustPageSize(0, getStepSizeIncreaseHeight(true), true, wantFillEmptySpace)
end
function decreaseSizeDownAll()
    adjustPageSize(0, -getStepSizeDecreaseHeight(true), true, wantFillEmptySpace)
end

-- Declare global variables
widthInitial = nil
heightInitial = nil
workingLayer = nil

function workingLayerInfo()
    local docStructureInitial = app.getDocumentStructure()
    local pageInitial = docStructureInitial["pages"][docStructureInitial["currentPage"]] -- Get the initial page
    workingLayer = pageInitial["currentLayer"] --Get the working layer, after inserting the filled box, have to make the layer current again

    -- Get page dimensions before increasing
    widthInitial = pageInitial["pageWidth"]
    heightInitial = pageInitial["pageHeight"]
end

-- Callback for inserting filled stroke over the empty space
function fillEmptySpace()
    local docStructureFinal = app.getDocumentStructure()
    local pageFinal = docStructureFinal["pages"][docStructureFinal["currentPage"]] -- Get the final page
    -- Get page dimensions after increasing
    local widthFinal = pageFinal["pageWidth"]
    local heightFinal = pageFinal["pageHeight"]
    
    local activeColor = app.getToolInfo("pen")["color"] --Take the color for the filled box from pen color
    
    local filledBoxRight = nill
if widthFinal > widthInitial then
    filledBoxRight = { -- fill the empty space rightwards
    x = {widthInitial, widthFinal, widthFinal, widthInitial, widthInitial},
    y = {0, 0, heightFinal, heightFinal, 0},
    width = 2, -- if you see any gap between two successive increase then increase the value
    fill = 255,
    tool = "pen",
    color = activeColor,
}
end

    local filledBoxBottom = nill
if heightFinal > heightInitial then
    filledBoxBottom = { -- fill the empty space rightwards
    x = {0, widthFinal, widthFinal, 0, 0},
    y = {heightInitial, heightInitial, heightFinal, heightFinal, heightInitial},
    width = 2, -- if you see any gap between two successive increase then increase the value
    fill = 255,
    tool = "pen",
    color = activeColor,
    }
end

    app.setCurrentLayer(1, false) --make the 1st layer as current layer to ensure the filled box remain on 1st layer always

    -- adding the stroke for filled box
    if filledBoxRight and filledBoxBottom then
        app.addStrokes { strokes = { filledBoxRight, filledBoxBottom, allowUndoRedoAction = "grouped" }}
    elseif filledBoxBottom then
        app.addStrokes { strokes = { filledBoxBottom, allowUndoRedoAction = "grouped" }}
    elseif filledBoxRight then
        app.addStrokes { strokes = { filledBoxRight, allowUndoRedoAction = "grouped" }}
    end

    app.refreshPage()

    if workingLayer == 1 then -- If only one layer is present then create a layer and then set the new layer as current layer
        app.uiAction({action = "ACTION_NEW_LAYER" })
        app.setCurrentLayer(2, false)
    else
        app.setCurrentLayer(workingLayer, false) --If more than one layer is present then the previously working layer become current layer again
    end

end


toggleMenuCmPercent = nill 
toggleMenuFillEmpty = nill
-- Function to toggle the boolean value of documentBasedAdjustment in the config file
function toggleDocumentBasedAdjustment()
    local configFilePath = sourcePath .. "page_adjust_config.lua" -- Path to the config file
    local lines = {}

    -- Read the config file
    local file, err = io.open(configFilePath, "r")

    -- Read all lines of the file into the lines table
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()

    -- Iterate through the lines to find and toggle the documentBasedAdjustment value
    local updated = false
    for i, line in ipairs(lines) do
        if line:match("config.documentBasedAdjustment%s*=%s*(%a+)") then
            -- Toggle the boolean value
            local currentValue = line:match("config.documentBasedAdjustment%s*=%s*(%a+)")
            --app.openDialog(currentValue, {[1] = "OK"})
            local newValue = (currentValue == "true") and "false" or "true"
            lines[i] = line:gsub(currentValue, newValue)
            updated = true
            if newValue == "true" then
                toggleMessage = "Adjustment Type is now set to  [%-based]. Please restart the app"
            else
                toggleMessage = "Adjustment Type is now set to [cm-based]. Please restart the app"
            end
            break
        end
    end

    -- Write the updated content back to the file
    file, err = io.open(configFilePath, "w")
    file:write(table.concat(lines, "\n") .. "\n")
    file:close()

-- Toggle complete message
    app.msgbox(toggleMessage, {[1] = "Yes", [2] = "No"})--This works on older version of Xournalapp
    --app.openDialog(toggleMessage, {[1] = "OK"}) -- This is for newer versions of xournalapp
end

-- Function to toggle the boolean value of wantFillEmptySpace in the config file
function toggleWantFillEmptySpace()
    local configFilePath = sourcePath .. "page_adjust_config.lua" -- Path to the config file
    local lines = {}

    -- Read the config file
    local file, err = io.open(configFilePath, "r")

    -- Read all lines of the file into the lines table
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()

    -- Iterate through the lines to find and toggle the wantFillEmptySpace value
    local updated = false
    for i, line in ipairs(lines) do
        if line:match("config.wantFillEmptySpace%s*=%s*(%a+)") then
            -- Toggle the boolean value
            local currentValue = line:match("config.wantFillEmptySpace%s*=%s*(%a+)")
            local newValue = (currentValue == "true") and "false" or "true"
            lines[i] = line:gsub(currentValue, newValue)
            updated = true
            if newValue == "true" then
                toggleMessage = "'Fill Empty Space' is now set [on]. Please restart the app"
            else
                toggleMessage = "'Fill Empty Space' is now set [Off]. Please restart the app"
            end
            break
        end
    end

    -- Write the updated content back to the file
    file, err = io.open(configFilePath, "w")
    file:write(table.concat(lines, "\n") .. "\n")
    file:close()

-- Toggle complete message
    app.msgbox(toggleMessage, {[1] = "Yes", [2] = "No"}) --This works on older version of Xournalapp
    --app.openDialog(toggleMessage, {[1] = "OK"}) -- This is for newer versions of xournalapp
end


-- toggles the menu name for the two types of adjustments
toggleMenuCmPercent = nill 
toggleMenuFillEmpty = nill
function toggleMenuNameBothAdjustment()
    local configFilePath = sourcePath .. "page_adjust_config.lua" -- Path to the config file
    local lines = {}

    -- Read the config file
    local file, err = io.open(configFilePath, "r")

    -- Read all lines of the file into the lines table
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()

    -- Iterate through the lines to find and toggle the documentBasedAdjustment value
    for i, line in ipairs(lines) do
        if line:match("config.documentBasedAdjustment%s*=%s*(%a+)") then
            -- Toggle the boolean value
            local currentValueDocumentBasedAdjustment = line:match("config.documentBasedAdjustment%s*=%s*(%a+)")
            -- For changing the menu based upon toggle state
            if currentValueDocumentBasedAdjustment =="true" then
                toggleMenuCmPercent = "Set 'Adjustment Type' to cm-based"
            else
                toggleMenuCmPercent = "Set 'Adjustment Type' to %-based"
            end
        end
    end
    for i, line in ipairs(lines) do
        if line:match("config.wantFillEmptySpace%s*=%s*(%a+)") then
            -- Toggle the boolean value
            local currentValueWantFillEmptySpace = line:match("config.wantFillEmptySpace%s*=%s*(%a+)")
            -- For changing the menu based upon toggle state
            if currentValueWantFillEmptySpace =="true" then
                toggleMenuFillEmpty = "Set 'Fill Empty Space' Off"
            else
                toggleMenuFillEmpty = "Set 'Fill Empty Space' On"
            end
        end
    end
end

--This is a "Just Ready for service" code, not refined, code duplication can be removed, having not enough time.
--If anyone refine it, please share the code!

