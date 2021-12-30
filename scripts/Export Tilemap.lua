local spr = app.activeSprite
if not spr then return print "No active sprite" end

local fs = app.fs
local output_folder = fs.fileTitle(spr.filename)

local function export_tileset(tileset, name, padding, numWidth, startIdx)
  local grid = tileset.grid
  local size = grid.tileSize
  if #tileset > 0 then
    local spec = spr.spec
    spec.width = (size.width * numWidth) + (padding * numWidth ) + padding
    spec.height = (((size.height + (padding * 2) - padding) * #tileset) / numWidth) + padding
    local image = Image(spec)
    image:clear()
    local curW = 0
    local curH = 0
    for i = startIdx,#tileset-1 do
      local tile = tileset:getTile(i)
      image:drawImage(tile, padding + ((curW * size.width) + (curW*padding)), padding + ((curH * size.height) + (curH * padding)))
      curW = curW + 1
      if curW == numWidth then
        curW = 0
        curH = curH + 1
      end
    end

    local imageFn = fs.joinPath(output_folder, name .. ".png")
    image:saveAs(imageFn)
    app.open(imageFn)
  end
end

local dlg = Dialog("Export Tilemap")

local function startExport()
  local data = dlg.data
  local n = 0

  for _,layer in ipairs(spr.layers) do
    if layer.isTilemap then
      n = n + 1
      if data["tileset" .. n] then
        export_tileset(layer.tileset, layer.name, data.padding, data.numWidth, data.startIdx)
      end
    end
  end

  dlg:close()
end

local function addTilemaps()
  local n = 0
  for _,layer in ipairs(spr.layers) do
    if layer.isTilemap then
      n = n + 1
      dlg:check{ id="tileset" .. n, text=layer.name, selected=true}
    end
  end
end

dlg:number{ id="padding", label="Padding:", text="16" }
dlg:number{ id="numWidth", label="Num Width:", text="8"}
dlg:number{ id="startIdx", label="Start Idx:", text="1"}

addTilemaps()

dlg:button{ text="&Cancel", onclick=function() dlg:close() end }
dlg:button{ text="&Start", onclick=function() startExport() end }

dlg:show{ wait=false }
