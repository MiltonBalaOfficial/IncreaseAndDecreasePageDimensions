-- Helper function to adjust page size
    function adjustPageSize(amountWidth, amountHeight, forAllPages)
        local docStructure = app.getDocumentStructure()
      
        -- Determine pages to process
        local pages = forAllPages and docStructure["pages"] or {docStructure["pages"][docStructure["currentPage"]]}
      
        for p, page in ipairs(pages) do
          local width = page["pageWidth"]
          local height = page["pageHeight"]
          if forAllPages then app.setCurrentPage(p) end -- Set page if processing all pages
          app.setPageSize(width + amountWidth, height + amountHeight)
        end
      end
      
      -- Individual action functions
      function increaseSizeRight() adjustPageSize(71, 0, false) end
      function decreaseSizeRight() adjustPageSize(-71, 0, false) end
      function increaseSizeDown() adjustPageSize(0, 71, false) end
      function decreaseSizeDown() adjustPageSize(0, -71, false) end
      
      -- All-pages action functions
      function increaseSizeRightAll() adjustPageSize(71, 0, true) end
      function decreaseSizeRightAll() adjustPageSize(-71, 0, true) end
      function increaseSizeDownAll() adjustPageSize(0, 71, true) end
      function decreaseSizeDownAll() adjustPageSize(0, -71, true) end
      
      -- Register all Toolbar actions and initialize all UI stuff
      function initUi()
        local actions = {
          {menu="Increase Right", callback="increaseSizeRight", accelerator="<Alt>2", toolbarId="increaseSizeRight", iconName="IncreaseDimRight"},
          {menu="Decrease Right", callback="decreaseSizeRight", accelerator="<Alt>3", toolbarId="decreaseSizeRight", iconName="DecreaseDimRight"},
          {menu="Increase Bottom", callback="increaseSizeDown", accelerator="<Alt>4", toolbarId="increaseSizeDown", iconName="IncreaseDimBottom"},
          {menu="Decrease Bottom", callback="decreaseSizeDown", accelerator="<Alt>5", toolbarId="decreaseSizeDown", iconName="DecreaseDimDown"},
          {menu="Increase Right All", callback="increaseSizeRightAll", toolbarId="increaseSizeRightAll", iconName="IncreaseDimRightAll"},
          {menu="Decrease Right All", callback="decreaseSizeRightAll", toolbarId="decreaseSizeRightAll", iconName="DecreaseDimRightAll"},
          {menu="Increase Bottom All", callback="increaseSizeDownAll", toolbarId="increaseSizeDownAll", iconName="IncreaseDimBottomAll"},
          {menu="Decrease Bottom All", callback="decreaseSizeDownAll", toolbarId="decreaseSizeDownAll", iconName="DecreaseDimDownAll"}
        }
      
        for _, action in ipairs(actions) do
          app.registerUi(action)
        end
      end
      