---Mod data of the Larger Machines mod
---@class (exact) LargerMachines.ModData:data.Prototype
---@field type 'mod-data'
---@field data_type 'larger-machines-definition'
---@field data LargerMachines.ResizeProps

---@class LargerMachines.ResizeProps
---ID of the machine entity
---@field machine string
---Original size of the machine
---@field old_size uint8
---New size of the machine
---@field size uint8
---Speed multiplier of the machine
---@field speed_mult? number
---New pipe connection categories to apply for resized machines
---@field pipe_connection_category_replacement? (string|(string[]))
---Shifts for the pipe pictures
---@field pipe_picture_shift? Directional<XYOpt>
---Shifts for the pipe covers
---@field pipe_cover_shift? Directional<XYOpt>

---@alias Directional<T> ({north: T, east: T, south: T, west: T} | T)

---@class XYOpt
---@field x? number
---@field y? number

local api = require("api") --[[@as LargerMachines.API]]

if mods["space-age"] then
	if settings.startup["larger-machines-enlarge-foundry"].value then
		---@type LargerMachines.ModData
		local foundry_data = {
			type = "mod-data",
			data_type = "larger-machines-definition",
			name = "larger-machines-foundry",
			data = {
				machine = "foundry",
				old_size = 5,
				size = 10,
				pipe_connection_category_replacement = "ducts",
				pipe_cover_shift = api.DOUBLE_SIZE_PIPE_COVER_SHIFTS,
			},
		}

		data:extend({
			foundry_data --[[@as data.ModData]],
		})
	end

	if settings.startup["larger-machines-enlarge-cryogenic-plant"].value then
		---@type LargerMachines.ModData
		local cryogenic_plant_data = {
			type = "mod-data",
			data_type = "larger-machines-definition",
			name = "larger-machines-cryogenic-plant",
			data = {
				machine = "cryogenic-plant",
				old_size = 5,
				size = 10,
				pipe_connection_category_replacement = "ducts",
				pipe_picture_shift = {
					north = { x = 0 / 32, y = -18 / 32 },
					east = { x = 16 / 32, y = 1.5 / 32 },
					south = { x = 0 / 32, y = 14 / 32 },
					west = { x = -16 / 32, y = 1.5 / 32 },
				},
				pipe_cover_shift = api.DOUBLE_SIZE_PIPE_COVER_SHIFTS,
			},
		}
		data:extend({
			cryogenic_plant_data --[[@as data.ModData]],
		})
	end

	if settings.startup["larger-machines-enlarge-biochamber"].value then
		---@type LargerMachines.ModData
		local cryogenic_plant_data = {
			type = "mod-data",
			data_type = "larger-machines-definition",
			name = "larger-machines-biochamber",
			data = {
				machine = "biochamber",
				old_size = 3,
				size = 6,
				pipe_connection_category_replacement = "ducts",
				pipe_picture_shift = {
					north = { x = -0.5 / 32, y = -13 / 32 },
					east = { x = 16 / 32, y = 2 / 32 },
					south = { x = -0.5 / 32, y = 13 / 32 },
					west = { x = -16 / 32, y = 2 / 32 },
				},
				pipe_cover_shift = api.DOUBLE_SIZE_PIPE_COVER_SHIFTS,
			},
		}
		data:extend({
			cryogenic_plant_data --[[@as data.ModData]],
		})
	end

	if settings.startup["larger-machines-enlarge-electromagnetic-plant"].value then
		---@type LargerMachines.ModData
		local electromagnetic_plant_data = {
			type = "mod-data",
			data_type = "larger-machines-definition",
			name = "larger-machines-electromagnetic-plant",
			data = {
				machine = "electromagnetic-plant",
				old_size = 4,
				size = 8,
				pipe_connection_category_replacement = "ducts",
				pipe_picture_shift = {
					north = { x = -0.5 / 32, y = -12 / 32 },
					east = { x = 16 / 32, y = 1.5 / 32 },
					south = { x = -1 / 32, y = 11 / 32 },
					west = { x = -15 / 32, y = 2 / 32 },
				},
				pipe_cover_shift = api.DOUBLE_SIZE_PIPE_COVER_SHIFTS,
			},
		}
		data:extend({
			electromagnetic_plant_data --[[@as data.ModData]],
		})
	end
end

if mods["Krastorio2-spaced-out"] or mods["Krastorio2"] then
	if settings.startup["larger-machines-enlarge-kr-advanced-furnace"].value then
		---@type LargerMachines.ModData
		local kr_advanced_furnace_data = {
			type = "mod-data",
			data_type = "larger-machines-definition",
			name = "larger-machines-kr-advanced-furnace",
			data = {
				machine = "kr-advanced-furnace",
				old_size = 7,
				size = 14,
				pipe_connection_category_replacement = "ducts",
				pipe_picture_shift = {
					north = { x = -0.5 / 32, y = -14 / 32 },
					east = { x = 16 / 32, y = 1.5 / 32 },
					south = { x = -1 / 32, y = 11 / 32 },
					west = { x = -16 / 32, y = 2 / 32 },
				},
				pipe_cover_shift = api.DOUBLE_SIZE_PIPE_COVER_SHIFTS,
			},
		}
		data:extend({
			kr_advanced_furnace_data --[[@as data.ModData]],
		})
	end
end
