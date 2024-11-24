-- Register all Toolbar actions and intialize all UI stuff
function initUi()
  app.registerUi({["menu"] = "Increase page size by 2.5 cm to the Right", ["callback"] = "increaseSizeRight", ["accelerator"] = "<Alt>2"});
  app.registerUi({["menu"] = "Decrease page size by 2.5 cm from the right", ["callback"] = "decreaseSizeRight", ["accelerator"] = "<Alt>3"});
  app.registerUi({["menu"] = "Increase page size by 2.5 cm to the bottom", ["callback"] = "increaseSizeDown", ["accelerator"] = "<Alt>4"});
  app.registerUi({["menu"] = "Decrease page size by 2.5 cm from the bottom", ["callback"] = "decreaseSizeDown", ["accelerator"] = "<Alt>5"});
end

function increaseSizeRight()
  local docStructure = app.getDocumentStructure()
  local numPages = #docStructure["pages"]
  local page = docStructure["currentPage"]
  local width = docStructure["pages"][page]["pageWidth"]
  local height = docStructure["pages"][page]["pageHeight"]

  app.setPageSize(width + 71, height)-- 2.5cm ~ 71pt
end

function decreaseSizeRight()
  local docStructure = app.getDocumentStructure()
  local numPages = #docStructure["pages"]
  local page = docStructure["currentPage"]
  local width = docStructure["pages"][page]["pageWidth"]
  local height = docStructure["pages"][page]["pageHeight"]

  app.setPageSize(width - 71, height)-- 2.5cm ~ 71pt
end

function increaseSizeDown()
  local docStructure = app.getDocumentStructure()
  local numPages = #docStructure["pages"]
  local page = docStructure["currentPage"]
  local width = docStructure["pages"][page]["pageWidth"]
  local height = docStructure["pages"][page]["pageHeight"]
  
  app.setPageSize(width, height + 71)-- 2.5cm ~ 71pt
end

function decreaseSizeDown()
  local docStructure = app.getDocumentStructure()
  local numPages = #docStructure["pages"]
  local page = docStructure["currentPage"]
  local width = docStructure["pages"][page]["pageWidth"]
  local height = docStructure["pages"][page]["pageHeight"]
    
  app.setPageSize(width, height - 71)-- 2.5cm ~ 71pt
end