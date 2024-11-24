-- Register all Toolbar actions and initialize all UI stuff
function initUi()
  app.registerUi({menu="Increase Right", callback="increaseSizeRight", accelerator="<Alt>2", toolbarId="increaseSizeRight", iconName="IncreaseDimRight"});
  app.registerUi({menu="Decrease Right", callback="decreaseSizeRight", accelerator="<Alt>3", toolbarId="decreaseSizeRight", iconName="DecreaseDimRight"});
  app.registerUi({menu="Increase Bottom", callback="increaseSizeDown", accelerator="<Alt>4", toolbarId="increaseSizeDown", iconName="IncreaseDimBottom"});
  app.registerUi({menu="Decrease Bottom", callback="decreaseSizeDown", accelerator="<Alt>5", toolbarId="decreaseSizeDown", iconName="DecreaseDimDown"});
  app.registerUi({menu="Increase Right All", callback="increaseSizeRightAll", toolbarId="increaseSizeRightAll", iconName="IncreaseDimRightAll"});
  app.registerUi({menu="Decrease Right All", callback="decreaseSizeRightAll", toolbarId="decreaseSizeRightAll", iconName="DecreaseDimRightAll"});
  app.registerUi({menu="Increase Bottom All", callback="increaseSizeDownAll", toolbarId="increaseSizeDownAll", iconName="IncreaseDimBottomAll"});
  app.registerUi({menu="Decrease Bottom All", callback="decreaseSizeDownAll", toolbarId="decreaseSizeDownAll", iconName="DecreaseDimDownAll"});
end

-- Increase page width for the current page
function increaseSizeRight()
  local docStructure = app.getDocumentStructure()
  local page = docStructure["currentPage"]
  local width = docStructure["pages"][page]["pageWidth"]
  local height = docStructure["pages"][page]["pageHeight"]

  app.setPageSize(width + 71, height) -- 2.5cm ~ 71pt
end

-- Decrease page width for the current page
function decreaseSizeRight()
  local docStructure = app.getDocumentStructure()
  local page = docStructure["currentPage"]
  local width = docStructure["pages"][page]["pageWidth"]
  local height = docStructure["pages"][page]["pageHeight"]

  app.setPageSize(width - 71, height) -- 2.5cm ~ 71pt
end

-- Increase page height for the current page
function increaseSizeDown()
  local docStructure = app.getDocumentStructure()
  local page = docStructure["currentPage"]
  local width = docStructure["pages"][page]["pageWidth"]
  local height = docStructure["pages"][page]["pageHeight"]

  app.setPageSize(width, height + 71) -- 2.5cm ~ 71pt
end

-- Decrease page height for the current page
function decreaseSizeDown()
  local docStructure = app.getDocumentStructure()
  local page = docStructure["currentPage"]
  local width = docStructure["pages"][page]["pageWidth"]
  local height = docStructure["pages"][page]["pageHeight"]

  app.setPageSize(width, height - 71) -- 2.5cm ~ 71pt
end

-- Increase page width for all pages
function increaseSizeRightAll()
  local docStructure = app.getDocumentStructure()
  for p=1, #docStructure["pages"] do
    local width = docStructure["pages"][p]["pageWidth"]
    local height = docStructure["pages"][p]["pageHeight"]
    app.setCurrentPage(p)
    app.setPageSize(width + 71, height) -- 2.5cm ~ 71pt
  end
end

-- Decrease page width for all pages
function decreaseSizeRightAll()
  local docStructure = app.getDocumentStructure()
  for p=1, #docStructure["pages"] do
    local width = docStructure["pages"][p]["pageWidth"]
    local height = docStructure["pages"][p]["pageHeight"]
    app.setCurrentPage(p)
    app.setPageSize(width - 71, height) -- 2.5cm ~ 71pt
  end
end

-- Increase page height for all pages
function increaseSizeDownAll()
  local docStructure = app.getDocumentStructure()
  for p=1, #docStructure["pages"] do
    local width = docStructure["pages"][p]["pageWidth"]
    local height = docStructure["pages"][p]["pageHeight"]
    app.setCurrentPage(p)
    app.setPageSize(width, height + 71) -- 2.5cm ~ 71pt
  end
end

-- Decrease page height for all pages
function decreaseSizeDownAll()
  local docStructure = app.getDocumentStructure()
  for p=1, #docStructure["pages"] do
    local width = docStructure["pages"][p]["pageWidth"]
    local height = docStructure["pages"][p]["pageHeight"]
    app.setCurrentPage(p)
    app.setPageSize(width, height - 71) -- 2.5cm ~ 71pt
  end
end
