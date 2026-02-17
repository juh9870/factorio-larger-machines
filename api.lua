local math2d = require("__core__/lualib/math2d")

local already_patched = {}

---@param pos data.MapPosition | nil
---@param original_size uint8
---@param new_size uint8
---@return data.MapPosition | nil
local function patch_conn_pos(pos, original_size, new_size)
	if pos == nil then
		return
	end

	--- @type data.MapPosition.struct
	pos = math2d.position.ensure_xy(pos)
	local expected_extent = original_size / 2
	local ratio = new_size / original_size

	if math.abs(pos.x) > math.abs(pos.y) then
		local dx = (pos.x < 0 and -1 or 1) * expected_extent - pos.x
		pos.x = (pos.x + dx) * ratio - dx
		pos.y = pos.y * ratio
	else
		local dy = (pos.y < 0 and -1 or 1) * expected_extent - pos.y
		pos.y = (pos.y + dy) * ratio - dy
		pos.x = pos.x * ratio
	end
	return pos
end

---@param bb data.BoundingBox | nil
---@param original_size uint8
---@param new_size uint8
---@return data.BoundingBox | nil
local function patch_bb(bb, original_size, new_size)
	if bb == nil then
		return nil
	end

	if bb.left_top == nil then
		bb = {
			left_top = bb[1],
			right_bottom = bb[2],
		}
	end

	--- @type data.BoundingBox.struct
	bb = math2d.bounding_box.ensure_xy(bb)
	local expected_extent = original_size / 2
	local ratio = new_size / original_size

	local dltx = -expected_extent - bb.left_top.x
	local dlty = -expected_extent - bb.left_top.y
	local drbx = expected_extent - math.abs(bb.right_bottom.x)
	local drby = expected_extent - math.abs(bb.right_bottom.y)

	bb.left_top.x = (bb.left_top.x + dltx) * ratio - dltx
	bb.left_top.y = (bb.left_top.y + dlty) * ratio - dlty
	bb.right_bottom.x = (bb.right_bottom.x + drbx) * ratio - drbx
	bb.right_bottom.y = (bb.right_bottom.y + drby) * ratio - drby

	return bb
end

---@param vec data.Vector | nil
---@param ratio number
---@return data.Vector | nil
local function patch_vector(vec, ratio)
	if vec == nil then
		return nil
	end

	vec = math2d.position.ensure_xy(vec)
	vec.x = vec.x * ratio
	vec.y = vec.y * ratio
	return vec
end

---@param anim data.Animation | data.Animation4Way | nil
---@param ratio number
local function patch_animation(anim, ratio)
	if anim == nil then
		return
	end
	if already_patched[anim] then
		return
	end
	already_patched[anim] = true
	if anim.north ~= nil then
		patch_animation(anim.north, ratio)
		patch_animation(anim.north_east, ratio)
		patch_animation(anim.east, ratio)
		patch_animation(anim.south_east, ratio)
		patch_animation(anim.south, ratio)
		patch_animation(anim.south_west, ratio)
		patch_animation(anim.west, ratio)
		patch_animation(anim.north_west, ratio)
		return
	end
	if anim.layers then
		for _, layer in pairs(anim.layers) do
			patch_animation(layer, ratio)
		end
		return
	end

	anim.scale = (anim.scale or 1) * ratio
	if anim.shift then
		if anim.shift.x then
			anim.shift.x = anim.shift.x * ratio
			anim.shift.y = anim.shift.y * ratio
		else
			anim.shift[1] = anim.shift[1] * ratio
			anim.shift[2] = anim.shift[2] * ratio
		end
	end
end

---@param sprite data.Sprite | data.Sprite4Way | data.SpriteVariations | nil
---@param ratio number
---@param extra_shift? Directional<XYOpt>
local function patch_sprite(sprite, ratio, extra_shift)
	if sprite == nil then
		return
	end
	if already_patched[sprite] then
		return
	end
	already_patched[sprite] = true
	if sprite[1] then
		for _, s in pairs(sprite) do
			patch_sprite(s, ratio, extra_shift)
		end
		return
	end
	if sprite.north ~= nil then
		patch_sprite(sprite.north, ratio, (type(extra_shift) == "table" and extra_shift.north or extra_shift))
		patch_sprite(sprite.east, ratio, (type(extra_shift) == "table" and extra_shift.east or extra_shift))
		patch_sprite(sprite.south, ratio, (type(extra_shift) == "table" and extra_shift.south or extra_shift))
		patch_sprite(sprite.west, ratio, (type(extra_shift) == "table" and extra_shift.west or extra_shift))
		return
	end

	if sprite.sheet then
		patch_sprite(sprite.sheet, ratio, extra_shift)
		return
	end

	if sprite.layers then
		for _, layer in pairs(sprite.layers) do
			patch_sprite(layer, ratio, extra_shift)
		end
		return
	end

	sprite.scale = (sprite.scale or 1) * ratio

	local bonus = (type(extra_shift) == "table" and extra_shift.north or extra_shift or {}) --[[@as XYOpt]]
	local bonus_x = (bonus.x or 0)
	local bonus_y = (bonus.y or 0)
	if sprite.shift then
		sprite.shift = math2d.position.ensure_xy(sprite.shift)
		sprite.shift.x = sprite.shift.x * ratio + bonus_x
		sprite.shift.y = sprite.shift.y * ratio + bonus_y
	elseif bonus_x ~= 0 or bonus_y ~= 0 then
		sprite.shift = { x = bonus_x, y = bonus_y }
	end
end

---@param gs data.CraftingMachineGraphicsSet | nil
---@param ratio number
local function patch_graphics_set(gs, ratio)
	-- log("Machine graphics:\n" .. serpent.block(gs))
	if gs == nil then
		return
	end

	patch_animation(gs.animation, ratio)
	patch_animation(gs.idle_animation, ratio)

	if gs.working_visualisations ~= nil then
		for _, vw in pairs(gs.working_visualisations) do
			patch_animation(vw.animation, ratio)
			patch_animation(vw.north_animation, ratio)
			patch_animation(vw.east_animation, ratio)
			patch_animation(vw.south_animation, ratio)
			patch_animation(vw.west_animation, ratio)
		end
	end

	patch_sprite(gs.frozen_patch, ratio)
	if gs.water_reflection ~= nil and gs.water_reflection.pictures ~= nil then
		patch_sprite(gs.water_reflection.pictures, ratio)
	end
end

---@param conn data.CircuitConnectorDefinition | (data.CircuitConnectorDefinition[]) | nil
---@param ratio number
local function patch_circuit_connector(conn, ratio)
	if conn == nil then
		return
	end
	if already_patched[conn] then
		return
	end
	already_patched[conn] = true

	if conn[1] then
		for _, c in pairs(conn) do
			patch_circuit_connector(c, ratio)
		end
		return
	end

	patch_sprite(conn.sprites.led_red, ratio)
	patch_sprite(conn.sprites.led_green, ratio)
	patch_sprite(conn.sprites.led_blue, ratio)
	patch_sprite(conn.sprites.led_light, ratio)
	patch_sprite(conn.sprites.connector_main, ratio)
	patch_sprite(conn.sprites.connector_shadow, ratio)
	patch_sprite(conn.sprites.wire_pins, ratio)
	patch_sprite(conn.sprites.wire_pins_shadow, ratio)
	patch_sprite(conn.sprites.led_blue_off, ratio)
	conn.sprites.blue_led_light_offset = patch_vector(conn.sprites.blue_led_light_offset, ratio)
	conn.sprites.red_green_led_light_offset = patch_vector(conn.sprites.red_green_led_light_offset, ratio)

	conn.points.wire.red = patch_vector(conn.points.wire.red, ratio)
	conn.points.wire.green = patch_vector(conn.points.wire.green, ratio)
	conn.points.wire.copper = patch_vector(conn.points.wire.copper, ratio)
	conn.points.shadow.red = patch_vector(conn.points.shadow.red, ratio)
	conn.points.shadow.green = patch_vector(conn.points.shadow.green, ratio)
	conn.points.shadow.copper = patch_vector(conn.points.shadow.copper, ratio)
end

---@class LargerMachines.API
local api = {}

---@type Directional<XYOpt>
api.DOUBLE_SIZE_PIPE_COVER_SHIFTS = {
	north = { x = 0 / 32, y = -17 / 32 },
	east = { x = 15 / 32, y = 1.5 / 32 },
	south = { x = -1 / 32, y = 14 / 32 },
	west = { x = -15 / 32, y = 2 / 32 },
}

---@param props LargerMachines.ResizeProps
api.apply_to_machine = function(props)
	local machine = data.raw["assembling-machine"][props.machine]
		or data.raw["furnace"][props.machine]
		or data.raw["rocket-silo"][props.machine]
		or data.raw["lab"][props.machine]

	if machine == nil then
		error(
			"Machine `"
				.. props.machine
				.. "` is not found. Only machines of `assembling-machine`, `furnace`, and `rocket-silo` types are currently supported"
		)
	end

	local ratio = props.size / props.old_size
	machine.collision_box = patch_bb(machine.collision_box, props.old_size, props.size)
	machine.selection_box = patch_bb(machine.selection_box, props.old_size, props.size)
	machine.sticker_box = patch_bb(machine.sticker_box, props.old_size, props.size)
	machine.hit_visualization_box = patch_bb(machine.hit_visualization_box, props.old_size, props.size)

	patch_circuit_connector(machine.circuit_connector, ratio)
	patch_circuit_connector(machine.circuit_connector_flipped, ratio)

	patch_graphics_set(machine.graphics_set, ratio)
	patch_graphics_set(machine.graphics_set_flipped, ratio)

	-- Lab prototype
	---@diagnostic disable-next-line: undefined-field
	patch_animation(machine.on_animation, ratio)
	---@diagnostic disable-next-line: undefined-field
	patch_animation(machine.off_animation, ratio)

	if props.speed_mult ~= nil then
		machine.crafting_speed = machine.crafting_speed * props.speed_mult
	end

	if machine.fluid_boxes ~= nil then
		-- log("Machine fluid_boxes:\n" .. serpent.block(machine.fluid_boxes))
		for _, box in pairs(machine.fluid_boxes) do
			patch_sprite(box.pipe_covers, ratio, props.pipe_cover_shift)
			patch_sprite(box.pipe_covers_frozen, ratio, props.pipe_cover_shift)
			patch_sprite(box.pipe_picture, ratio, props.pipe_picture_shift)
			patch_sprite(box.pipe_picture_frozen, ratio, props.pipe_picture_shift)
			patch_sprite(box.mirrored_pipe_picture, ratio, props.pipe_picture_shift)
			patch_sprite(box.mirrored_pipe_picture_frozen, ratio, props.pipe_picture_shift)
			for _, conn in pairs(box.pipe_connections) do
				if props.pipe_connection_category_replacement ~= nil then
					conn.connection_category = props.pipe_connection_category_replacement
				end
				conn.position = patch_conn_pos(conn.position, props.old_size, props.size)
				if conn.positions ~= nil then
					for k, pos in pairs(conn.positions) do
						conn.positions[k] = patch_conn_pos(pos, props.old_size, props.size)
					end
				end
			end
		end
	end
end

return api
