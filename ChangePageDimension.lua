-- Register all Toolbar actions and initialize all UI stuff
function initUi()
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
end

-- Step size for page adjustments
local adjustmentStep = 71 -- Default in points (pt), if you set `useCentimeters` to `true` then it will be 71 cm.
local useCentimeters = false -- If you want to put the value in cm then Set it `true` to switch to cm-based adjustments.
local cmToPointFactor = 28.3465 -- 1 cm = 28.3465 pt
local documentBasedAdjustment = false -- If you want "Current document-based" adjustments then set it `true`. (Currently it is set to increase by 100% and decrease by 50%)
local documentBasedAdjustmentFactorIncrease = 1 -- For 100% increase
local documentBasedAdjustmentFactorDecrease = 0.5 -- For 50% decrease (It mimics undoAction)

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

function adjustPageSize(amountWidth, amountHeight, forAllPages)
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

        app.setPageSize(width + amountWidth, height + amountHeight)

    end
end

-- Individual action functions
function increaseSizeRight()
    adjustPageSize(getStepSizeIncreaseWidth(), 0, false)
end
function decreaseSizeRight()
    adjustPageSize(-getStepSizeDecreaseWidth(), 0, false)
end
function increaseSizeDown()
    adjustPageSize(0, getStepSizeIncreaseHeight(), false)
end
function decreaseSizeDown()
    adjustPageSize(0, -getStepSizeDecreaseHeight(), false)
end

-- All-pages action functions
function increaseSizeRightAll()
    adjustPageSize(getStepSizeIncreaseWidth(), 0, true)
end
function decreaseSizeRightAll()
    adjustPageSize(-getStepSizeDecreaseWidth(), 0, true)
end
function increaseSizeDownAll()
    adjustPageSize(0, getStepSizeIncreaseHeight(), true)
end
function decreaseSizeDownAll()
    adjustPageSize(0, -getStepSizeDecreaseHeight(), true)
end

