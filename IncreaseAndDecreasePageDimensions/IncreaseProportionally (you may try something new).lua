-- Register UI actions
function initUi()
  app.registerUi({["menu"] = "Increase page size proportionally", ["callback"] = "resizePageIncrease", ["accelerator"] = "<Alt>R"})
  app.registerUi({["menu"] = "Decrease page size proportionally", ["callback"] = "resizePageDecrease", ["accelerator"] = "<Alt>Shift+R"})
end

-- Resize factor (20%)
local RESIZE_FACTOR = 0.2

-- Function to resize page proportionally (Increase)
function resizePageIncrease()
  resizePage(true) -- Pass true for increasing size
end

-- Function to resize page proportionally (Decrease)
function resizePageDecrease()
  resizePage(false) -- Pass false for decreasing size
end

-- Shared function to handle resize logic
function resizePage(isIncrease)
  local docStructure = app.getDocumentStructure()
  local page = docStructure["currentPage"]
  local width, height = docStructure["pages"][page]["pageWidth"], docStructure["pages"][page]["pageHeight"]
  
  -- Calculate resize amount (20%)
  local resizeAmountWidth, resizeAmountHeight = width * RESIZE_FACTOR, height * RESIZE_FACTOR

  -- Apply the new size based on the operation (increase or decrease)
  app.setPageSize(width + (isIncrease and resizeAmountWidth or -resizeAmountWidth), height + (isIncrease and resizeAmountHeight or -resizeAmountHeight))

  -- Select all content on the page
  app.uiAction({action = "ACTION_SELECT_ALL"})

  -- Cut the selected content
  app.uiAction({action = "ACTION_CUT"})

  -- Paste the content (this will be placed at the center, adjusting to the resized page)
  app.uiAction({action = "ACTION_PASTE"})

  -- Get the current active tool's information
  local activeToolInfo = app.getToolInfo("active")
  local toolName = activeToolInfo["type"]:upper()  -- Convert tool name to uppercase
  local toolSize = activeToolInfo["size"].value  -- The size of the tool (e.g., pen thickness)
  local toolColor = activeToolInfo["color"]  -- The color of the tool
  local toolThickness = activeToolInfo["thickness"]  -- The thickness of the tool

  -- Switch to highlighter to clear selection
  app.uiAction({action = "ACTION_TOOL_HIGHLIGHTER"})

  -- Switch back to the original tool with the saved properties (e.g., pen)
  app.uiAction({action = "ACTION_TOOL_" .. toolName})  -- Use uppercase tool name here
  --app.setToolInfo("active", {
  --  ["type"] = toolName,
  --  ["size"] = {name = "thickness", value = toolSize},
  --  ["color"] = toolColor,
  --  ["thickness"] = toolThickness
  --})
end
