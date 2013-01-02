#!/bin/sh

# cut terrain.png into 16x16 size chunks
# if your texture.png has a higher resolution change it!
convert -crop 16x16 terrain.png temp.tcrop.png

# rename those chunks that represent actual blocks
mv temp.tcrop.png.0  mcimport_grass.png
mv temp.tcrop.png.1  mcimport_stone.png
mv temp.tcrop.png.2  mcimport_dirt.png
mv temp.tcrop.png.3  mcimport_grass_side.png
mv temp.tcrop.png.4  mcimport_wood.png
mv temp.tcrop.png.5  mcimport_double_stair.png
mv temp.tcrop.png.6  mcimport_stair_top.png
mv temp.tcrop.png.7  mcimport_brick.png
mv temp.tcrop.png.8  mcimport_tnt_side.png
mv temp.tcrop.png.9  mcimport_tnt_top.png
mv temp.tcrop.png.10 mcimport_tnt_bottom.png
mv temp.tcrop.png.11 mcimport_web.png
mv temp.tcrop.png.12 mcimport_flower_rose.png
mv temp.tcrop.png.13 mcimport_flower_yellow.png
mv temp.tcrop.png.14 mcimport_water.png
mv temp.tcrop.png.15 mcimport_sapling.png
mv temp.tcrop.png.16 mcimport_cobble.png
mv temp.tcrop.png.17 mcimport_bedrock.png
mv temp.tcrop.png.18 mcimport_sand.png
mv temp.tcrop.png.19 mcimport_gravel.png
mv temp.tcrop.png.20 mcimport_tree.png
mv temp.tcrop.png.21 mcimport_tree_top.png
mv temp.tcrop.png.22 mcimport_leaves.png
mv temp.tcrop.png.23 mcimport_metal_top.png
mv temp.tcrop.png.24 mcimport_gold_top.png

mv temp.tcrop.png.28 mcimport_mushroom_red.png
mv temp.tcrop.png.29 mcimport_mushroom_brown.png

mv temp.tcrop.png.30 mcimport_lava.png
mv temp.tcrop.png.31 mcimport_grass_top2.png
mv temp.tcrop.png.32 mcimport_gold_ore.png
mv temp.tcrop.png.33 mcimport_iron_ore.png
mv temp.tcrop.png.34 mcimport_coal_ore.png
mv temp.tcrop.png.35 mcimport_bookshelf.png
mv temp.tcrop.png.36 mcimport_mossy_cobble.png
mv temp.tcrop.png.37 mcimport_obsidian.png

mv temp.tcrop.png.39 mcimport_metal_side.png
mv temp.tcrop.png.40 mcimport_gold_side.png

mv temp.tcrop.png.48 mcimport_sponge.png
mv temp.tcrop.png.49 mcimport_glass.png

mv temp.tcrop.png.55 mcimport_metal_bottom.png
mv temp.tcrop.png.56 mcimport_gold_bottom.png

mv temp.tcrop.png.64 mcimport_wool_red.png
mv temp.tcrop.png.65 mcimport_wool_orange.png
mv temp.tcrop.png.66 mcimport_wool_yellow.png
mv temp.tcrop.png.67 mcimport_wool_lime.png
mv temp.tcrop.png.68 mcimport_wool_green.png
mv temp.tcrop.png.69 mcimport_wool_aqua.png
mv temp.tcrop.png.70 mcimport_wool_cyan.png
mv temp.tcrop.png.71 mcimport_wool_blue.png
mv temp.tcrop.png.72 mcimport_wool_purple.png
mv temp.tcrop.png.73 mcimport_wool_indigo.png
mv temp.tcrop.png.74 mcimport_wool_violet.png
mv temp.tcrop.png.75 mcimport_wool_magenta.png
mv temp.tcrop.png.76 mcimport_wool_pink.png
mv temp.tcrop.png.77 mcimport_wool_black.png
mv temp.tcrop.png.78 mcimport_wool_grey.png
mv temp.tcrop.png.79 mcimport_wool_white.png


# all other temporary chunks are no longer needed 
rm -rf temp.tcrop.png.*
