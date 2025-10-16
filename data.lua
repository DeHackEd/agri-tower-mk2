
-- Goal: this line, but in a new machine
--data.raw['agricultural-tower']['agricultural-tower'].growth_grid_tile_size = 2

-- Update the regular tower before we copy it
data.raw['agricultural-tower']['agricultural-tower'].fast_replaceable_group = 'agricultural-tower-3x3'
data.raw['agricultural-tower']['agricultural-tower'].next_upgrade = 'agricultural-tower-mk2'


local new_tower = table.deepcopy(data.raw['agricultural-tower']['agricultural-tower'])

-- The main goal!
new_tower.growth_grid_tile_size = 2
-- The "radius" is how many tiles in each direction from the tower itself
-- it can plant. With a smaller tile size, increase this to cover more
-- physical area to make up for it. However this does result in a +1 total
-- to the overall radius (21x21 coverage becomes 23x23)
new_tower.radius = 4

-- Upgrade planneer compatibility
new_tower.next_upgrade = nil

-- Plant consistently, row by row, rather than random tiles
new_tower.randomize_planting_tile = false


-- Paperwork for the new entity.. new name, new look
new_tower.name = 'agricultural-tower-mk2'
new_tower.minable = {mining_time = 0.3, result = "agricultural-tower-mk2"}
util.recursive_tint(new_tower, {1, 0.5, 0, 1})

-- The visualization squares are their own sprites with their own sizes.
-- We must override them or the squares overlap and look weird.
new_tower.radius_visualisation_picture = {
	filename = '__agri-tower-mk2__/graphics/tower-shrunk-square.png',
	priority = "extra-high-no-scale",
	width = 16,
	height = 16,
	scale = 0.25
}

local new_item = table.deepcopy(data.raw['item']['agricultural-tower'])
new_item.name = 'agricultural-tower-mk2'
new_item.place_result = 'agricultural-tower-mk2';
new_item.icons = {{ icon = new_item.icon, tint = {1, 0.5, 0, 1}}}
new_item.icon = nil
new_item.stack_size = 10

data:extend({

	-- Tech/reserach
	{
		type = 'technology',
		name = 'agricultural-tower-mk2',

		icon = "__space-age__/graphics/technology/agriculture.png",
		icon_size = 256,

		effects = { {
			type = "unlock-recipe",
			recipe = "agricultural-tower-mk2"
		} },

		prerequisites = {"agriculture", 'cryogenic-science-pack'},

		unit = {
			count = 1500,
			ingredients = {
				{"automation-science-pack",   1},
				{"logistic-science-pack",     1},
				{"chemical-science-pack",     1},
				{"production-science-pack",   1},
				{"utility-science-pack",      1},
				{"space-science-pack",        1},
				{"agricultural-science-pack", 1},
				{"cryogenic-science-pack",    1}
			},
			time = 60
		}

	},

	-- Crafting recipe
	{
		type = "recipe",
		name = "agricultural-tower-mk2",
		energy_required = 15,
		ingredients =
		{
			{type = "item", name = "agricultural-tower", amount = 3},
			{type = "item", name = "processing-unit", amount = 5}
		},
		results = {{type="item", name="agricultural-tower-mk2", amount=1}},
		enabled = false
	},

	-- Item produced
	new_item,

	-- Entity itself
	new_tower

})
