local spr = app.activeSprite
if not spr then return app.alert "No active sprite" end

local function contains(array, item)
  for _,value in ipairs(array) do
    if value == item then
      return true
    end
  end
  return false
end

local layers = {}
local cels = {}
for _,cel in ipairs(app.range.cels) do
  if cel.layer.isEditable and
     cel.layer.isVisible then
    if not contains(layers, cel.layer) then
      table.insert(layers, cel.layer)
    end
    table.insert(cels, cel)
  end
end



local function run(dlg)
  print("minOpacity = " .. dlg.data.minOpacity)
  print("maxOpacity = " .. dlg.data.maxOpacity)
end

local function cancel(dlg)
  dlg:close()
end

local dlg = Dialog("Cel Opacity Wave")
dlg:separator{ text="This will change all selected cells opacity according to a sine wave" }
  :slider{id="minOpacity",label="Min Opacity",min=0,max=255,value=255}
  :slider{id="maxOpacity",label="Max Opacity",min=0,max=255,value=255}
  :button{ id="ok", text="OK", focus=true }
  :button{ text="Cancel" }
dlg:show()

local data = dlg.data
if data.ok then
  app.transaction(
    function()
      -- print("minOpacity = " .. data.minOpacity)
      -- print("maxOpacity = " .. data.maxOpacity)
      for i, cel in ipairs(cels) do
        a = data.minOpacity
        b = data.maxOpacity
        opacity = a + (b - a) / 2 + math.sin(i) * (b - a) / 2
        cel.opacity = opacity
      end
    end)
end