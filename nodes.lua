--[[
 Minetest 0.4 mod: default
 See README.txt for further information.

    Import maps from Minecraft Classic
    Copyright (C) 2013 Sokomine

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]


WATER_ALPHA = 160
WATER_VISC = 1
LAVA_VISC = 7
LIGHT_MAX = 14
-- Yes, this blocks emit light. Otherwise huge buildings would be really dark!
LIGHT_BUILDING_BLOCK = 0; --LIGHT_MAX-3

-- Definitions made by this mod that other mods can use too
default = {}

-- 
-- Nodes for "stairs" (slabs are used for quite a lot of things)
--


minetest.register_node("mcimport:double_stairs", {
	description = "Double stairs for buildings",
	tiles = { "mcimport_stair_top.png", "mcimport_stair_top.png", "mcimport_double_stair.png" },
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
        drop = 'mcimport:stairs 2',
})

-- TODO!
--local node_mc_stairs = {};
---- this is why it depends on stairs
--for k,v in pairs( minetest.registered_nodes[  "stairs:slab_stone" ]) do
--   node_mc_stairs[k] = v;
--end

---- now we have to modify the slab so that it has a fitting name and emits light
--node_mc_stairs.description  = "Stairs etc. for building";
--node_mc_stairs.tiles        = { "mcimport_stair_top.png", "mcimport_stair_top.png", "mcimport_double_stair.png" };
--node_mc_stairs.light_source = LIGHT_BUILDING_BLOCK;
---- register the new node
--minetest.register_node( "mcimport:stairs", node_mc_stairs );

-- TODO: is there no better way than cut&paste? :-(
minetest.register_node("mcimport:stairs", {
                description = "Stairs etc. for building",
                drawtype = "nodebox",
                tiles     = { "mcimport_stair_top.png", "mcimport_stair_top.png", "mcimport_double_stair.png" };
                paramtype = "light",
                is_ground_content = true,
                groups = {cracky=3},
                light_source = LIGHT_BUILDING_BLOCK;
                node_box = {
                        type = "fixed",
                        fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
                },
                selection_box = {
                        type = "fixed",
                        fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
                },
                on_place = function(itemstack, placer, pointed_thing)
                        if pointed_thing.type ~= "node" then
                                return itemstack
                        end

                        -- If it's being placed on an another similar one, replace it with
                        -- a full block
                        local slabpos = nil
                        local slabnode = nil
                        local p0 = pointed_thing.under
                        local p1 = pointed_thing.above
                        local n0 = minetest.env:get_node(p0)
                        local n1 = minetest.env:get_node(p1)
                        if n0.name == "mcimport:stairs" then
                                slabpos = p0
                                slabnode = n0
                        elseif n1.name == "mcimport:stairs" then
                                slabpos = p1
                                slabnode = n1
                        end
                        if slabpos then
                                -- Remove the slab at slabpos
                                minetest.env:remove_node(slabpos)
                                -- Make a fake stack of a single item and try to place it
                                local fakestack = ItemStack("mcimport:double_stairs")
                                pointed_thing.above = slabpos
                                fakestack = minetest.item_place(fakestack, placer, pointed_thing)
                                -- If the item was taken from the fake stack, decrement original
                                if not fakestack or fakestack:is_empty() then
                                        itemstack:take_item(1)
                                -- Else put old node back
                                else
                                        minetest.env:set_node(slabpos, slabnode)
                                end
                                return itemstack
                        end

                        -- Otherwise place regularly
                        return minetest.item_place(itemstack, placer, pointed_thing)
                end,
        })




--
-- Nodes for all the diffrent colors of wool
--

-- just like wool:color - except that this is no wool
local wool_colors = {"red", "orange","yellow","lime",
              "green","aqua","cyan","blue",
              "purple","indigo","magenta","pink","violet",
              "black","grey","white"};
local i;

for i, color in ipairs( wool_colors ) do

    minetest.register_node("mcimport:wool_"..color, {
        description = color.." wool for buildings",
	tiles = {"mcimport_wool_"..color..".png"},
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
    })

end

--
-- Node definitions
--



-- from water
--        drawtype = "flowingliquid",
--        liquidtype = "flowing",
--        liquid_alternative_flowing = "default:water_flowing",
--        liquid_alternative_source = "default:water_source",
--        liquid_viscosity = WATER_VISC,

-- from telegate:plasma
--        liquidtype = "flowing",
--        liquid_alternative_flowing = "default:water_flowing",

-- water and lava which do not flow
-- TODO: fancy effect...you can see throuh the floor and walls from the water-side
minetest.register_node("mcimport:stationary_water", {
        description = "Stationary water for building",
        inventory_image = minetest.inventorycube( "mcimport_water.png" ),
        --drawtype = "flowingliquid",
        tiles ={"mcimport_water.png"},
        special_tiles = {
                {name="mcimport_water.png", backface_culling=false},
                {name="mcimport_water.png", backface_culling=true},
        },
        alpha = WATER_ALPHA,
--        drawtype = "flowingliquid",
        paramtype = "light",
        walkable = false,
        pointable = false,
        diggable = false,
        buildable_to = true,
--        climbable = true,
--        post_effect_color = {a=64, r=100, g=100, b=200},
        post_effect_color = {a=80, r=50, g=200, b=50},
        groups = {},
--        light_source = LIGHT_BUILDING_BLOCK,
})


--minetest.register_node("mcimport:water_stationary", {
--        description = "Flowing Water",
--        inventory_image = minetest.inventorycube( "mcimport_water.png"),
--        drawtype = "liquid",
--        tiles = { "mcimport_water.png" },
--        special_tiles = {
--                {name="mcimport_water.png", backface_culling=false},
--                {name= "mcimport_water.png", backface_culling=true},
--        },
--        alpha = WATER_ALPHA,
--        paramtype = "light",
--        walkable = false,
--        pointable = false,
--        diggable = false,
--        buildable_to = true,
--        liquidtype = "stationary", -- or "source"?
--        liquid_alternative_flowing = "default:water_flowing",
--        liquid_alternative_source = "default:water_source",
--        liquid_viscosity = WATER_VISC,
--        post_effect_color = {a=64, r=100, g=100, b=200},
--        groups = {water=3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1},
--})

-- this lava does no domage and does not flow (just for decorative use)
minetest.register_node("mcimport:stationary_lava", {
        description = "Stationary lava for building",
        inventory_image = minetest.inventorycube( "mcimport_lava.png" ),
        --drawtype = "flowingliquid",
        tile_images = { "mcimport_lava.png"},
        alpha = 80,
        paramtype = "light",
        walkable = false,
        pointable = false,
        diggable = false,
        buildable_to = true,
        climbable = true,
        post_effect_color = {a=80, r=50, g=200, b=50},
        special_tiles = {
                {image="mcimport_lava.png", backface_culling=false},
                {image="mcimport_lava.png", backface_culling=true},
        },
        groups = {},
--        light_source = LIGHT_BUILDING_BLOCK,
})




-- creates nodes for each minecraft classic block and takes care that
-- sand/gravel do not fall, flowers/leves do not decay, grass stays green etc.

-- just like default:stone
minetest.register_node("mcimport:stone", {
	description = "Stone for buildings",
	tiles = { "mcimport_stone.png" },
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})


-- like default:dirt_with_grass - except that it doesn't turn into dirt (mostly just renamed)
minetest.register_node("mcimport:dirt_with_grass", {
	description = "Dirt with Grass that stays green for buildings",
	tiles = { "mcimport_grass.png", "mcimport_dirt.png", "mcimport_dirt.png^mcimport_grass_side.png"},
	is_ground_content = true,
	groups = {crumbly=3},
--	sounds = default.node_sound_dirt_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

--just like default:dirt
minetest.register_node("mcimport:dirt", {
	description = "Dirt for buildings",
	tiles = { "mcimport_dirt.png" },
	is_ground_content = true,
	groups = {crumbly=3},
--	sounds = default.node_sound_dirt_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})


-- has a diffrent picture than normal cobble
minetest.register_node("mcimport:cobble", {
	description = "Cobblestone for buildings",
	tiles = { "mcimport_cobble.png" },
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})


-- like default:wood
minetest.register_node("mcimport:wood", {
	description = "Wooden Planks for buildings",
	tiles = { "mcimport_wood.png" },
	is_ground_content = true,
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
--	sounds = default.node_sound_wood_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})


-- like default:sapling but doesn't grow
minetest.register_node("mcimport:sapling", {
        description = "Sapling for buildings",
        drawtype = "plantlike",
        visual_scale = 1.0,
        tiles = { "mcimport_sapling.png" },
        inventory_image = "mcimport_sapling.png",
        wield_image = "mcimport_sapling.png",
        paramtype = "light",
        walkable = false,
        groups = {snappy=2,flammable=2},
--        sounds = default.node_sound_defaults(),
})



-- only looks like it but behaves like stone
minetest.register_node("mcimport:bedrock", {
	description = "Bedrock for buildings",
	tiles = { "mcimport_bedrock.png" },
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
})




-- like default:sand but does not fall down
minetest.register_node("mcimport:sand", {
	description = "Sandstone for buildings",
	tiles = { "mcimport_sand.png" },
	is_ground_content = true,
	groups = {crumbly=3},
--	sounds = default.node_sound_sand_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- like default:gravel but does not fall down
minetest.register_node("mcimport:gravel", {
	description = "Gravel for buildings",
	tiles = { "mcimport_gravel.png"},
	is_ground_content = true,
	groups = {crumbly=2},
--	sounds = default.node_sound_dirt_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})


-- no, this can't be mined!
minetest.register_node("mcimport:gold_ore", {
	description = "Gold ore for buildings",
	tiles = { "mcimport_gold_ore.png"},
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- like default:iron_ore but can't be mined
minetest.register_node("mcimport:iron_ore", {
	description = "Iron ore for buildings",
	tiles = { "mcimport_iron_ore.png"},
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- like default:coal_ore but can't be mined
minetest.register_node("mcimport:coal_ore", {
	description = "Coal ore for buildings",
	tiles = { "mcimport_coal_ore.png"},
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- like default:tree
minetest.register_node("mcimport:tree", {
	description = "Tree for buildings",
        tiles = { "mcimport_tree_top.png", "mcimport_tree_top.png", "mcimport_tree.png" },
	is_ground_content = true,
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
--	sounds = default.node_sound_wood_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- like default:leaves but do not decay
minetest.register_node("mcimport:leaves", {
	description = "Leaves for buildings that do not decay",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = { "mcimport_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, flammable=2},
--	sounds = default.node_sound_leaves_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- the sponge is purely for decoration
minetest.register_node("mcimport:sponge", {
	description = "Sponge for buildings",
	tiles = { "mcimport_sponge.png" },
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- like default:glass
minetest.register_node("mcimport:glass", {
	description = "Glass for buildings",
	drawtype = "glasslike",
	tiles = { "mcimport_glass.png" },
	inventory_image = minetest.inventorycube( "mcimport_glass.png"),
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
--	sounds = default.node_sound_glass_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})


-- like flowers:dandelion_yellow but no flower
minetest.register_node("mcimport:flower_yellow", {
                description = "Yellow flower for building",
                drawtype = "plantlike",
                tiles = { "mcimport_flower_yellow.png" },
                inventory_image = "mcimport_flower_yellow.png",
                wield_image = "mcimport_flower_yellow.png",
                sunlight_propagates = true,
                paramtype = "light",
                walkable = false,
                groups = { snappy = 3,flammable=2 },
--                sounds = default.node_sound_leaves_defaults()
})

-- like flowers:rose but no flower
minetest.register_node("mcimport:flower_red", {
                description = "Red rose for building",
                drawtype = "plantlike",
                tiles = { "mcimport_flower_rose.png" },
                inventory_image = "mcimport_flower_rose.png",
                wield_image = "mcimport_flower_rose.png",
                sunlight_propagates = true,
                paramtype = "light",
                walkable = false,
                groups = { snappy = 3,flammable=2 },
--                sounds = default.node_sound_leaves_defaults()
})

minetest.register_node("mcimport:brown_mushroom", {
        description = "Brown mushroom for buildings",
        tile_images = { "mcimport_mushroom_brown.png"},
        inventory_image = "mcimport_mushroom_brown.png",
        drawtype = "plantlike",
        sunlight_propagates = true,
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3,flammable=2 },
--        sounds = default.node_sound_leaves_defaults(),
})


minetest.register_node("mcimport:red_mushroom", {
        description = "Red mushroom for buildings",
        tile_images = { "mcimport_mushroom_red.png"},
        inventory_image = "mcimport_mushroom_red.png",
        drawtype = "plantlike",
        sunlight_propagates = true,
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3,flammable=2 },
--        sounds = default.node_sound_leaves_defaults(),
})

-- gold
minetest.register_node("mcimport:gold", {
	description = "Gold Block for buildings",
	tiles = { "mcimport_gold_top.png", "mcimport_gold_bottom.png", "mcimport_gold_side.png" },
	is_ground_content = true,
	groups = {cracky=3},
--        sounds = default.node_sound_leaves_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})


-- like default:steelblock
minetest.register_node("mcimport:steelblock", {
        description = "Metal Block for buildings",
	tiles = { "mcimport_metal_top.png", "mcimport_metal_bottom.png", "mcimport_metal_side.png" },
        is_ground_content = true,
        groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2},
--        sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- just like default:brick
minetest.register_node("mcimport:brick", {
	description = "Brick Block for buildings",
	tiles = { "mcimport_brick.png"},
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- tnt - not intendet for explosion
minetest.register_node("mcimport:tnt", {
	description = "TNT for buildings",
	tiles = { "mcimport_tnt_top.png", "mcimport_tnt_bottom.png", "mcimport_tnt_side.png" },
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- like default:bookshelf
minetest.register_node("mcimport:bookshelf", {
	description = "Bookshelf for buildings",
	tiles = {"mcimport_wood.png", "mcimport_wood.png", "mcimport_bookshelf.png"},
	is_ground_content = true,
	groups = {snappy=2,choppy=3,oddly_breakable_by_hand=2,flammable=3},
--	sounds = default.node_sound_wood_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- like default:mossycobble
minetest.register_node("mcimport:mossycobble", {
	description = "Mossy Cobblestone for buildings",
	tiles = {"mcimport_mossy_cobble.png"},
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

-- obsidian (like obsidian:obsidian_block)
minetest.register_node("mcimport:obsidian", {
	description = "Obsidian for buildings",
	tiles = {"mcimport_obsidian.png"},
	is_ground_content = true,
	groups = {cracky=3},
--	sounds = default.node_sound_stone_defaults(),
        light_source = LIGHT_BUILDING_BLOCK,
})

