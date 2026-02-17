data:extend({
	{
		type = "bool-setting",
		name = "larger-machines-enlarge-centrifuge",
		setting_type = "startup",
		default_value = false,
	},
})

if mods["space-age"] then
	data:extend({
		{
			type = "bool-setting",
			name = "larger-machines-enlarge-foundry",
			setting_type = "startup",
			default_value = true,
		},
		{
			type = "bool-setting",
			name = "larger-machines-enlarge-electromagnetic-plant",
			setting_type = "startup",
			default_value = true,
		},
		{
			type = "bool-setting",
			name = "larger-machines-enlarge-cryogenic-plant",
			setting_type = "startup",
			default_value = true,
		},
		{
			type = "bool-setting",
			name = "larger-machines-enlarge-biochamber",
			setting_type = "startup",
			default_value = false,
		},
	})
end

if mods["Krastorio2-spaced-out"] or mods["Krastorio2"] then
	data:extend({
		{
			type = "bool-setting",
			name = "larger-machines-enlarge-kr-advanced-furnace",
			setting_type = "startup",
			default_value = true,
		},
	})
end

if mods["maraxsis"] then
	data:extend({
		{
			type = "bool-setting",
			name = "larger-machines-maraxsis-compat",
			setting_type = "startup",
			default_value = true,
		},
	})
end
