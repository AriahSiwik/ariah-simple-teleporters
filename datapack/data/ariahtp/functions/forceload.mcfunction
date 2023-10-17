# add a dummy scoreboard objective called "ariahtp.forceload_check"
scoreboard objectives add ariahtp.forceload_check dummy

# store if the current chunk is forceloaded in the new objective
execute store result score CHECK ariahtp.forceload_check run forceload query ~ ~

# if the current chunk is NOT forceloaded, then forceload it
execute if score CHECK ariahtp.forceload_check matches 0 run forceload add ~ ~

# delete the scoreboard objective
scoreboard objectives remove ariahtp.forceload_check