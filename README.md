
==================================
Import maps from Minecraft Classic
==================================

WARNING: Importing maps (even relatively small ones like 256xc256x256 blocks) has drawbacks:
- it takes a long time (several minutes; depends on machine)
- client might not get updated without reconnect
- you need a *lot* of free space (more than it looks like...turn coordinates on with f5 and
  check); without a flat map your buildings might end up in the next hill!
  Best thing is to get a flat map.
- make sure the chunks the map is to be copied on do exist - otherwise it might take even
  longer if the map has to be generated first
- mcimport makes some assumptions about the map which might not be true for *your* own maps:
  * offset in the file is 486 (that is where the block data startes); it might be diffrent
    for other classic servers
  * map is 2^nx2^nx2^n
  * the lower half of the map (up to 2^(n-1) in height) is filled with dirt
  * there is one layer of grass on the dirt
  * on top of the grass there is only air (well, except for the buildings)
  Maps with other dimensions cannot be detected automaticly. You have to change worldedit/mc2mt.lua
  for such a map. The assumptions about half-dirt-half-air-maps help reduce the amount of blocks
  that have to be inserted to a more reasonable number. 
  [OUTDATED] Beneath the grass-level dirt blocks are NOT imported (only other block types); 
  above the grass-level air is NOT imported (thus if you do have a forgotten mountain lying around 
  there on your minetest world your buildings will end up embedded in it).
  CURRENTLY dirt (not that with grass on!) and air are completely ignored while copying.

  
  

Mcimport uses its own blocks for imported buildings instead of the default ones
(e.g. mcimport:stone instead of default:stone).  This has several reasons:

- sand and gravel do not fall (thus your buildings out of sand blocks are safe)
- leaves do not decay
- flowers/mushrooms need nothing special (they just look like flowers)
- grass stays green even though it is not lighted
- grass is not the default one so flowers and mobs won't spawn unexpectedly
- the above effects do not have to be turned off globally - they can still be used for default blocks
- no need for a bunch of other mods (which may still be helpful for other reasons)
- the blocks can be replaced with other ones later on with the worldedit-mod
- textures from texturepacks can be used
- handling of light (blocks emit light)
- water does not flow

Imported blocks emit light like a torch. This may seem strange but is necessary for large
buildings. You couldn't place as much torches as a huge epic building might need! Minecraft
classic doesn't have lighting - Minetest does. If you are not happy with the "torch"-blocks
and want to put torches manually (e.g. for smaller buildings) you can turn it off by setting
LIGHT_BUILDING_BLOCK = 0  in mcimport/init.lua

Water is a special case and used in Minecraft classic for things like door replacement
(like a plasma), kitchen sinks, showers, fountains, elevators (shwim up), swimming pools, 
decoration - and sometimes even for water. If that would be turned into a default:water_source 
the map might get flooded from the next "elevator". Instead, mcimport uses its own 
mcimport:stationary_water (same with lava). It is not a fluid so it does not allow swimming.

If you are not happy with any of the blocks/nodes you can either change the nodes directly in
mcimport/nodes.lua or change the name the classic blocks are replaced with in mcimport/mc2mt.lua
(look for block_transform and e.g. change mcimport:stationary_water to default:water_source if
you are sure your map contains no water with air around/beneath it)


How it works
------------

level*.dat files contain compressed data. Mcimport doesn't decompress it. You have to gunzip your
file manually. On unix this would be
   mv -i level_12345.dat level_12345.dat.gz
   gunzip level_12345.dat.gz
   mkdir worlds/NameOfYourWorld/schems/ 
   mv -i level_12345.dat worlds/NameOfYourWorld/schems/
That is the same directory as that one used by worldedit.

To import your file load and run your world and
1. type in the chat: /mcimport level 64x64x64 10:0:0
   That will import your unzipped Minecraft classic map 
   worlds/NameOfYourWorld/schems/level.dat (which has the dimensions 64x64x64) to the
   coordinates 10,0,0 (second one: height) in your Minetest world.
2. Have patience!
3. If your building doesn't show up reconnect your client.
4. Check if something like "Changed 113254 blocks." appears in bin/debug.text
   The actual number tells you how many blocks have been inserted (excluding non-imported blocks
   like dirt beneath grass-level and air above grass-level)
5. Go and look for the content of your map. Make sure you have fly and fast privilege so you
   can reach them. Turn sight to far.

Liscence
--------

    Copyright (C) 2012/2013 Sokomine

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

