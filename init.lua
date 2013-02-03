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


minetest.register_privilege("mcimport", "Can import Minecraft Classic savefiles")

mcimport = {}


-- node definitions (inactive blocks that represent those of MC classic)
dofile(minetest.get_modpath("mcimport").."/nodes.lua");
-- the actual import/conversion happens here
dofile(minetest.get_modpath("mcimport").."/mc2mt.lua");


minetest.register_chatcommand("mcimport", {
	params = "<file> <dimensions> <position>",
	description = "Import Minecraft classic map from <file> \"(world folder)/schems/<file>.dat\" "..
                      "(you have to uncompress the level manually before) "..
                      "with the dimensions <dimnnsions> to the given position/coordinates <position>. Example: "..
                      "/mcimport my_map 256x256x512 100:15:35  will read the file (world folder)/schems/my_map.dat as a Minecraft "..
                      "classic map of the size 256x256x512 and import it to your current Minetest world at coordinates x=100, y=15 (height!) "..
                      "and z=35. Make sure the area you import to is loaded!",
	privs = {mcimport=true},
	func = function(name, param)

                local params_expected = "<file> <dimension_x>x<dimension_y>x<dimension_z> <target_pos_x>:<target_pos_y>:<target_pos_z>";
		if( param == "" or param==nil) then
		   minetest.chat_send_player(name, "Missing parameters: "..params_expected );
                   return;
		end

		local pos = {x=0; y=0; z=0};
		local dim = {x=0; y=0; z=0};
		local fname;
		for fn, dim_x, dim_y, dim_z, pos_x, pos_y, pos_z in param:gmatch("([^%s]+)%s+(%d+)x(%d+)x(%d+)%s+([+-]?%d+)\:([+-]?%d+)\:([+-]?%d+)") do

                   if( fn ~= nil and dim_x ~= nil and dim_y ~= nil and dim_z ~= nil and pos_x ~= nil and pos_y ~= nil and pos_z ~= nil ) then
 		      -- target position
		      pos.x = tonumber( pos_x );
		      pos.y = tonumber( pos_y );
		      pos.z = tonumber( pos_z );
		      -- map dimensions
		      dim.x = tonumber( dim_x );
		      dim.y = tonumber( dim_y );
		      dim.z = tonumber( dim_z );
		      -- ...and the file
		      fname = fn;
		   end

		end

		if( dim.x == 0 ) then
		   minetest.chat_send_player(name, "Missing/wrong parameters. Got: "..param.." Expected: "..params_expected );
		   return;
		end

		if( dim.x<1 or dim.y<1 or dim.z<1) then
		   minetest.chat_send_player(name, "Impossible map dimensions." );
		   return;
		end

		if(    pos.x> 30000 or pos.y> 30000 or pos.z> 30000 
                    or pos.x<-30000 or pos.y<-30000 or pos.z<-30000) then
		   minetest.chat_send_player(name, "The target position is too far out. No coordinate shall exceed +/-30000." );
		   return;
                end

		if( ((dim.x%16) ~= 0) or ((dim.y%16) ~= 0) or ((dim.z%16) ~= 0)) then
		   minetest.chat_send_player(name, "Warning: Your map dimensions seem unlikely. Usually they are multiples of 16 (e.g. 64, 128, 256, ...)." );
		end
		

                 
		local filename_mc; 

		filename_mc = minetest.get_worldpath().."/schems/"..fname.. ".dat";
		file, err = io.open(filename_mc, "rb");

		if err ~= nil then 
		   minetest.chat_send_player(name, "Could not open file \""..filename_mc.."\".");
		   return;
                end

		local value = file:read("*a");
		file:close();

                minetest.chat_send_player( name, "Map file \""..tostring( fname )..
			"\" with dimensions "..tostring( dim.x ).." x "..tostring( dim.y ).." x "..tostring( dim.z )..
                        " will be imported to position "..tostring( pos.x ).." : "..tostring( pos.y ).." : "..tostring( pos.z )..".");


		local count;
                count = 0;
                count = mcimport.deserialize_mc(pos, value, dim, name );

		minetest.chat_send_player(name, "MCimport finised. Status: "..count .. " nodes imported.");
	end,
})
