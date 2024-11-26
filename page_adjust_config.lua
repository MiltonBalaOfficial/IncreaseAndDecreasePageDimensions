-- page_adjust_config.lua
local config = {}

-- Step size for page adjustments
config.adjustmentStep = 71 -- Default in points (pt), if you set `useCentimeters` to `true` then it will be 71 cm.
config.useCentimeters = false -- If you want to put the value in cm then Set it `true` to switch to cm-based adjustments.
config.cmToPointFactor = 28.3465 -- 1 cm = 28.3465 pt
config.documentBasedAdjustment = true -- If you want "Current document-based" adjustments then set it `true`. (Currently it is set to increase by 100% and decrease by 50%)
config.documentBasedAdjustmentFactorIncrease = 1 -- For 100% increase
config.documentBasedAdjustmentFactorDecrease = 0.5 -- For 50% decrease (It mimics undoAction)
config.wantFillEmptySpace = false
return config
