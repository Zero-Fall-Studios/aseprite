local spr = app.activeSprite

function rgbToHex(r,g,b)
  local rgb = (r * 0x10000) + (g * 0x100) + b
  return string.format("%x", rgb)
end

local function exportData()
  local palette = spr.palettes[1]
	io.write("{\n")
		io.write("  \"palette\": [\n")
		for i = 1,#palette-1 do			
			local color = palette:getColor(i)
      io.write("    {\n")
      io.write("      \"alpha\": \"" .. color.alpha .. "\",\n")
      io.write("      \"red\": \"" .. color.red .. "\",\n")
      io.write("      \"green\": \"" .. color.green .. "\",\n")
      io.write("      \"blue\": \"" .. color.blue .. "\",\n")
      io.write("      \"hue\": \"" .. color.hue .. "\",\n")
      io.write("      \"saturation\": \"" .. color.saturation .. "\",\n")
      io.write("      \"value\": \"" .. color.value .. "\",\n")
      io.write("      \"lightness\": \"" .. color.lightness .. "\",\n")
      io.write("      \"index\": \"" .. color.index .. "\",\n")
      io.write("      \"gray\": \"" .. color.gray .. "\",\n")
      io.write("      \"hex\": \"#" .. rgbToHex(color.red, color.green, color.blue) .. "\"\n")
      if i == #palette-1 then
        io.write("    }\n")
      else
        io.write("    },\n")
      end
		end
		io.write("  ]\n")
	io.write("}\n")
end

local dlg = Dialog()
dlg:file{ id="exportFile",
          label="File",
          title="Export Index",
          open=false,
          save=true,
          filetypes={"json"}}

dlg:button{ id="ok", text="OK" }
dlg:button{ id="cancel", text="Cancel" }
dlg:show()
local data = dlg.data
if data.ok then
	local f = io.open(data.exportFile, "w")
	io.output(f)
	exportData()
	io.close(f)
end
