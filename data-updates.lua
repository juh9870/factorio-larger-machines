local api = require("__larger-machines__/api") --[[@as LargerMachines.API]]

for _, data in pairs(data.raw["mod-data"]) do
	if data.data_type == "larger-machines-definition" then
		api.apply_to_machine(data.data)
	end
end