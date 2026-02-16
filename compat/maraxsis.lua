if not mods["maraxsis"] or not settings.startup["larger-machines-maraxsis-compat"].value then
	return
end

local gate_vulcanus = settings.startup["larger-machines-enlarge-foundry"].value
local gate_fulgora = settings.startup["larger-machines-enlarge-electromagnetic-plant"].value

local ducts_tech = data.raw["technology"]["ducts"]

if ducts_tech == nil then
	log("ducts technology is not present, skipping maraxsis compat")
	return
end

local remove_recipes_from_tech = {
	["duct-small"] = true,
	["duct-t-junction"] = true,
	["duct-curve"] = true,
	["duct-cross"] = true,
	["duct-underground"] = true,
	["non-return-duct"] = true,
	["duct-intake"] = true,
	["duct-exhaust"] = true,
}

if ducts_tech.effects ~= nil then
	for i = #ducts_tech.effects, 1, -1 do
		local eff = ducts_tech.effects[i]
		if eff.type == "unlock-recipe" and remove_recipes_from_tech[eff.recipe] then
			table.remove(ducts_tech.effects, i)
		end
	end
end

local early_piping_tech = table.deepcopy(ducts_tech)
early_piping_tech.name = "large-machines-early-ducts"
early_piping_tech.research_trigger = nil
early_piping_tech.unit = {
	ingredients = {
		{ "automation-science-pack", 1 },
		{ "logistic-science-pack", 1 },
		{ "chemical-science-pack", 1 },
	},
	time = 30,
	count = 250,
}
early_piping_tech.effects = {}
early_piping_tech.prerequisites = { "concrete", "chemical-science-pack" }

data:extend({ early_piping_tech })

if gate_vulcanus then
	table.insert(data.raw["technology"]["planet-discovery-vulcanus"].prerequisites, early_piping_tech.name)
end
if gate_fulgora then
	table.insert(data.raw["technology"]["planet-discovery-fulgora"].prerequisites, early_piping_tech.name)
end

---@param name string
---@param mult number
---@param extras? data.IngredientPrototype[]
local function patch_recipe(name, mult, extras)
	local recipe = data.raw["recipe"][name]
	recipe.ingredients = extras or {}
	table.insert(recipe.ingredients, { type = "item", name = "steel-plate", amount = 4 * mult })
	table.insert(recipe.ingredients, { type = "item", name = "concrete", amount = 4 * mult })
	table.insert(early_piping_tech.effects, { type = "unlock-recipe", recipe = recipe.name })
end

patch_recipe("duct-small", 1)
patch_recipe("duct-t-junction", 2)
patch_recipe("duct-curve", 2)
patch_recipe("duct-cross", 2)
patch_recipe("duct-underground", 15)

patch_recipe("non-return-duct", 2, { { type = "item", name = "iron-gear-wheel", amount = 8 } })
patch_recipe("duct-intake", 3, { { type = "item", name = "pump", amount = 1 } })
patch_recipe("duct-exhaust", 3, { { type = "item", name = "pump", amount = 1 } })
