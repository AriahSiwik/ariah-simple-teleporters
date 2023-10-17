# execute ALIGN on the corner between four blocks;
# POSITIONED half a block in two directions, centering on the block;
# RUN summon an armor stand with the tags "ariahtp.teleporter", "ariahtp.new", and "ariahtp.linked" and with the NBT tags "Marker:1b" and "Invisible:1b";
execute align xyz positioned ~0.5 ~ ~0.5 run summon minecraft:armor_stand ~ ~ ~ {Tags:["ariahtp.teleporter","ariahtp.new","ariahtp.linked","global.forceload","global.ignore.kill","global.ignore.pos","global.ignore.gui"],Marker:1b,Invisible:1b}

# modify the data of the newly created armor stand to be wearing the linking pearl
data modify entity @e[tag=ariahtp.new,limit=1] ArmorItems[0] set from entity @s Item

# add four dummy scoreboard objectives, one for each of the components of a UUID
scoreboard objectives add ariahtp.uuid0 dummy
scoreboard objectives add ariahtp.uuid1 dummy
scoreboard objectives add ariahtp.uuid2 dummy
scoreboard objectives add ariahtp.uuid3 dummy

# execute AS our new armor stand;
# STORE in each of the above scoreboard objectives;
# RUN get the UUID of the armor stand the linking pearl links to
execute as @e[tag=ariahtp.new] store result score @s ariahtp.uuid0 run data get entity @s ArmorItems[0].tag.CanDestroy[0]
execute as @e[tag=ariahtp.new] store result score @s ariahtp.uuid1 run data get entity @s ArmorItems[0].tag.CanDestroy[1]
execute as @e[tag=ariahtp.new] store result score @s ariahtp.uuid2 run data get entity @s ArmorItems[0].tag.CanDestroy[2]
execute as @e[tag=ariahtp.new] store result score @s ariahtp.uuid3 run data get entity @s ArmorItems[0].tag.CanDestroy[3]

# execute AS each unlinked teleporter;
# STORE in each of the above scoreboard objectives;
# RUN get the UUID of that armor stand
execute as @e[tag=ariahtp.teleporter,tag=!ariahtp.linked] store result score @s ariahtp.uuid0 run data get entity @s UUID[0]
execute as @e[tag=ariahtp.teleporter,tag=!ariahtp.linked] store result score @s ariahtp.uuid1 run data get entity @s UUID[1]
execute as @e[tag=ariahtp.teleporter,tag=!ariahtp.linked] store result score @s ariahtp.uuid2 run data get entity @s UUID[2]
execute as @e[tag=ariahtp.teleporter,tag=!ariahtp.linked] store result score @s ariahtp.uuid3 run data get entity @s UUID[3]

# execute AS each unlinked teleporter;
# IF it's UUID is the one we're looking for;
# RUN give it the tag "ariahtp.to_link"
execute as @e[tag=ariahtp.teleporter,tag=!ariahtp.linked] if score @s ariahtp.uuid0 = @e[tag=ariahtp.new,limit=1] ariahtp.uuid0 if score @s ariahtp.uuid1 = @e[tag=ariahtp.new,limit=1] ariahtp.uuid1 if score @s ariahtp.uuid2 = @e[tag=ariahtp.new,limit=1] ariahtp.uuid2 if score @s ariahtp.uuid3 = @e[tag=ariahtp.new,limit=1] ariahtp.uuid3 run tag @s add ariahtp.to_link

# make the unlinked teleporter we've found (with the tag "ariahtp.to_link") wear a copy of the linking pearl
data modify entity @e[tag=ariahtp.to_link,limit=1] ArmorItems[0] set from entity @s Item

# change the linking pearl's stored UUID to the UUID of the other teleporter
data modify entity @e[tag=ariahtp.to_link,limit=1] ArmorItems[0].tag.CanDestroy set from entity @e[tag=ariahtp.new,limit=1] UUID

# execute UNLESS we've found an unlinked teleporter with the correct UUID;
# run kill the new teleporter (because there is no teleporter to link to)
execute unless entity @e[tag=ariahtp.to_link] run kill @e[tag=ariahtp.new]

# tag the discovered teleporter "ariahtp.linked"
tag @e[tag=ariahtp.to_link] add ariahtp.linked

# untag the discovered telpeorter "ariahtp.to_link"
tag @e[tag=ariahtp.to_link] remove ariahtp.to_link

# delete the created scoreboard objectives
scoreboard objectives remove ariahtp.uuid0
scoreboard objectives remove ariahtp.uuid1
scoreboard objectives remove ariahtp.uuid2
scoreboard objectives remove ariahtp.uuid3

# play a sound showing that a teleporter has been created
playsound minecraft:item.flintandsteel.use block @a[distance=..8]

# execute AS the new teleporter;
# AT self;
# run ariahtp:forceload
execute as @e[tag=ariahtp.new] at @s run function ariahtp:forceload

# execute IF there is still a new teleporter (the teleporter has been successfully linked)
# run play a sound showing that the teleporter has been linked
execute if entity @e[tag=ariahtp.new] run playsound minecraft:block.beacon.activate block @a[distance=..8]

# untag the new teleporter "ariahtp.new"
tag @e[tag=ariahtp.new] remove ariahtp.new

# kill self (the linking pearl that was thrown to create the teleporter)
kill @s
