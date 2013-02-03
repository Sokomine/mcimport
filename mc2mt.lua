
--[[
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


-- TODO: use real water if the water-node is sourrounded by anything but air (what is on top doesn't matter)

-- reads a level.dat file from minecraft classic and imports it
-- based on worldedit:deserialize
-- returns the number of nodes changed
mcimport.deserialize_mc = function(originpos, value, dim, name)

   local max_x = 0; -- can be set to override automatic detection
   local max_y;
   local max_z;

   local grass_level = 0; -- z-value/heigth at which the grass is
     
   local offset = 486; -- position where the block data starts in file
 
   local block_transform = {
          [0] = "air",  -- field 0 doesn't exist in LUA? anyway - air has to be handled differently (and ignored most of the time)
          [1] = "mcimport:stone", 
          [2] = "mcimport:dirt_with_grass",
          [3] = "mcimport:dirt",
          [4] = "mcimport:cobble",
          [5] = "mcimport:wood",
          [6] = "mcimport:sapling", 
          [7] = "mcimport:bedrock",
          [8] = "mcimport:stationary_water", -- water that does not flow
          [9] = "mcimport:stationary_water", -- stationary water
         [10] = "mcimport:stationary_lava", -- lava that does not flow
         [11] = "mcimport:stationary_lava", -- stationary lava
         [12] = "mcimport:sand", 
         [13] = "mcimport:gravel",
         [14] = "mcimport:gold_ore",
         [15] = "mcimport:iron_ore",
         [16] = "mcimport:coal_ore",
         [17] = "mcimport:tree",
         [18] = "mcimport:leaves",
         [19] = "mcimport:sponge", 
         [20] = "mcimport:glass",

         [21] = "mcimport:wool_red",
         [22] = "mcimport:wool_orange",
         [23] = "mcimport:wool_yellow",
         [24] = "mcimport:wool_lime",
         [25] = "mcimport:wool_green",
         [26] = "mcimport:wool_aqua", 
         [27] = "mcimport:wool_cyan",
         [28] = "mcimport:wool_blue",
         [29] = "mcimport:wool_purple",
         [30] = "mcimport:wool_indigo",
         [31] = "mcimport:wool_violet",
         [32] = "mcimport:wool_magenta",
         [33] = "mcimport:wool_pink",
         [34] = "mcimport:wool_black",
         [35] = "mcimport:wool_grey",
         [36] = "mcimport:wool_white",

         [37] = "mcimport:flower_yellow",
         [38] = "mcimport:flower_red",
         [39] = "mcimport:brown_mushroom", 
         [40] = "mcimport:red_mushroom", 
         [41] = "mcimport:gold",
         [42] = "mcimport:steelblock",
         [43] = "mcimport:double_stairs",
         [44] = "mcimport:stairs",
         [45] = "mcimport:brick",
         [46] = "mcimport:tnt",
         [47] = "mcimport:bookshelf",
         [48] = "mcimport:mossycobble",
         [49] = "mcimport:obsidian", 
   }
  

   -- for node changes
   local pos = {x=0, y=0, z=0}
   local node = {name="", param1=0, param2=0}
   local env = minetest.env; 

   local anz_transformed = 0;
   local i, x, y, z;
   local neuer_block;

   -- the dimensions of the map have to be supplied by the user
   max_x = dim.x;
   max_y = dim.y;
   max_z = dim.z;
   anz_blocks = max_x * max_y * max_z;
   grass_level  = max_x / 2;

   print( "Reading information about "..
          tostring( offset+anz_blocks+2 ).." blocks.");

   if( max_x<1 or max_y<1 or max_z<1 ) then
     print "Impossible map size.";
     return;
   end

   if( offset+anz_blocks+2 > string.len( value )) then
      print( "Wrong map size. Found less blocks than expected.");
      return;
   end

   if( offset+anz_blocks+2 < string.len( value )) then
      print( "Wrong map size. Found more blocks than expected.");
      return;
   end

   print( "Importing them might take a while.");

   x = 0;
   y = 0;
   z = 0;


   -- check the tailing bytes (which are supposed to have the value 112)
   for i = (offset+anz_blocks), (offset+anz_blocks+2) do

      nr = string.byte( value, i, i );

      if (not(nr==112)) then
          print( "Warning: Byte at the end does not have expected value 70 (hex)");
      end
   end


   -- move originpos as needed to avoid recalculation for each block
   originpos.x = originpos.x + max_x;       -- somehow it got mirrored
   originpos.y = originpos.y - grass_level; -- grass ought to be on the same level as the sourrounding grass; half sink the level into the floor

--         -- dirt beneath the "water"-level is of no interest - but air is
--         if(    (y < grass_level and (nr ~= 3)) 
---         -- on the water/floor level grass is of no interest
--             or (y ==grass_level and (nr ~= 2))
--         -- above that air is of no interest
--             or (y > grass_level and (nr ~= 0))) then


--             if( i-offset ~= ( z*(max_x*max_y)+ (max_x * y) + x )) then



   sub_length = 16;
  
   air_etc = 0;

   local player;
   local target_coords;

   for start_z = 0, math.floor(max_z/sub_length)-1 do
      for start_y = 0, math.floor(max_y/sub_length)-1 do
         for start_x = 0, math.floor(max_x/sub_length)-1 do

            i = offset+( (max_x * max_y) * (start_z*sub_length) + (max_x * (start_y*sub_length)) + (start_x*sub_length) ) ;
            --print("Starting at "..tostring( i-offset ).." for offset "..tostring( start_x ).." "..tostring( start_y ).." "..tostring( start_z ));
 
            -- move the player who issued the command around in order to make sure that that part of the world has been generated
            player = minetest.env:get_player_by_name( name );
            if( player ~= nil ) then
               target_coords = { x = (originpos.x - start_x + (sub_length/2)), y = (originpos.y+ start_z - (sub_length/2)), z = (originpos.z+ start_y - (sub_length/2))};
               player:moveto(target_coords, false);
            end
         
            for z = (start_z*sub_length),(((start_z+1)*sub_length)-1) do
               for y = (start_y*sub_length),(((start_y+1)*sub_length)-1) do
                  for x = (start_x*sub_length),(((start_x+1)*sub_length)-1) do

                     nr = string.byte( value, i, i );
                     --if( nr ~= 0 ) then -- if( not( nr==3 ) and not( nr==0 )) then -- ignore air and dirt
                     if( (nr ~= 3) and (nr ~= 0) ) then -- ignore air and dirt completely
                        neuer_block = block_transform[ nr ];

                        -- print( i, (i-offset), nr, x, y, z, neuer_block );

                        -- actually place the block
                        pos.x = originpos.x - x; -- somehow got mirrord; max_x has been added previously
                        pos.y = originpos.y + z; -- otherwise it ends up sideways; grass_level has already been substracted
                        pos.z = originpos.z + y;
                        node.name   = neuer_block;
                        node.param1 = param1;
                        node.param2 = param2;

                        if( pos ~= nil and node ~= nil and neuer_block ~= nil) then
                           --print( "Placed "..tostring( neuer_block ).." at "..tostring( pos.x )..":"..tostring( pos.y )..":"..tostring( pos.z ));
                           env:add_node(pos, node);
                        else
                           print( "Error: Could not place "..tostring( neuer_block ).." [Code:"..tostring( nr ).."] at "..
                                                 tostring( pos.x )..":"..tostring( pos.y )..":"..tostring( pos.z ));
                        end

                        anz_transformed = anz_transformed + 1;
                     else
                        air_etc         = air_etc + 1;
                     end
                     i = i+1; -- next block
                  end
                  i = i + max_x - sub_length; -- next row; skip blocks inbetween
               end

               i = i + ( (max_y - sub_length ) * max_x );

            end
         end
      end
   end

   print( "Changed "..tostring( anz_transformed ).." blocks. Ignored "..tostring( air_etc ).." blocks of air and dirt beneath grass_level.");
   return anz_transformed;

end




------ just for testing/debugging
--        local filename = "level.dat";
--	local file, err = io.open(filename, "rb");
--	if err ~= nil then
--		print "File not found.";
--		return;
--	end
--	local value = file:read("*a");
--	file:close();

--        local originpos = { x=0, y=0, z=0 };
----        local dimension = { x=256, y=256, z=256 };
--        local dimension = { x=16, y=16, z=16 };
--        mcimport.deserialize_mc( originpos, value, dimension );

