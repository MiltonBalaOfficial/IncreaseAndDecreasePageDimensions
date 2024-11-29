# IncreaseAndDecreasePageDimensions

Extend your page! Now you can increase/decrease the page dimensions for a single page or for all the pages. It also works for the documents having pdf background.

## Installation Steps

1. **Place the folder** (`The Plugin folder`) in:
   - `C:\Users\<user>\AppData\Local\xournalpp\plugins\` on Windows 
     *Note: The `AppData` folder may be hidden.*
   - `~/.config/xournalpp/plugins` on Linux or MacOS

1. **Place the icons** (`provided icons(if any)`) in:
   - `C:\Users\<user>\AppData\Local\share\icons\hicolor\scalable\actions` on Windows,
   - `~/.local/share/icons/hicolor/scalable/actions/` on Linux or MacOS

2. **In the Xournal++ app**:
  Open menu `View > Toolbars > Customize`(stable version) `Edit > Toolbars > Customize`(Nightly version). You will find the copied icons in the `Plugins` section. Place them at a suitable location in the toolbar. (make sure the version of your Xournalapp support Plugin icons)

3. **Use the plugin** as needed


## Direction of Use

1. Easy to use, just click on the `icons` or `menus` in `plugin menu`.
2. Some shortcuts are available as `Alt + 2,3,4,5`. You may change or add for the other menus if you want.
3. If you want to toggle between `%-based value` and `cm based value` for increasing the dimensions, just click on the `Toggle 'Adjustment Type' [%-based/cm-based]` menu or icon.
4. For the documents having pdf background, if the dimensions are increased then empty space is created. You can fill the space with a color as the pdf background color. To do so  - 
  
    (i) First, click on `Toggle 'Fill Empty Space' [ON/OFF]` menu or icon to toggle between `Set 'Fill Empty Space' Off` and `Set 'Fill Empty Space' On`, a message will be shown.
    
    (ii) Next, change the `pen` tool color as your desired color. (The plugin will pick the `pen` color to fill the empty space) Use a `color picker` app to pick the color value from the pdf background for fine match.

    (iii) Then, increase the width or height as you want by clicking the icons for increasing or decreasing.

    (iV) The `filled-box` is always inserted on the `layer 1` and if then activate the layer you were working. If there is only one layer then a new layer is created, you should write on this layer, not the `layer 1`. You can delete the filled_box from the `layer 1`.


## Share Your Ideas!
Don't forget to give your feedback and share your ideas!

## If you want to code yourself

Currently Increase/decrease value is in points, you can change it to cm. To do so, open `page_adjust_config.lua` follow the instruction there, its done! Enjoy!

There is an extra file `IncreaseProportionally (you may try something new)` for getting space in all direction (will not work with the PDFs), you can give a try.


## Your support matters a lot
### If anyone wants to support
[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/miltonbala)
