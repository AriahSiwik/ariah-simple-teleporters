# tag self (the thrown ender pearl) "ariahtp.pearl"
tag @s add ariahtp.pearl

# create four dummy scoreboard objectives for each component of a UUID
scoreboard objectives add ariahtp.uuid0 dummy
scoreboard objectives add ariahtp.uuid1 dummy
scoreboard objectives add ariahtp.uuid2 dummy
scoreboard objectives add ariahtp.uuid3 dummy

# execute AS each player;
# STORE in the newly created scoreboard objectives;
# RUN get the UUID of said player
execute as @a store result score @s ariahtp.uuid0 run data get entity @s UUID[0]
execute as @a store result score @s ariahtp.uuid1 run data get entity @s UUID[1]
execute as @a store result score @s ariahtp.uuid2 run data get entity @s UUID[2]
execute as @a store result score @s ariahtp.uuid3 run data get entity @s UUID[3]

# execute STORE in the scoreboard objectives;
# RUN get the UUID of the thrower of the pearl
execute store result score @s ariahtp.uuid0 run data get entity @s Owner[0]
execute store result score @s ariahtp.uuid1 run data get entity @s Owner[1]
execute store result score @s ariahtp.uuid2 run data get entity @s Owner[2]
execute store result score @s ariahtp.uuid3 run data get entity @s Owner[3]

# execute AS each player;
# IF said player has the same UUID as the thrower of the pearl;
# RUN tag that player "ariahtp.player"
execute as @a if score @s ariahtp.uuid0 = @e[tag=ariahtp.pearl,limit=1] ariahtp.uuid0 if score @s ariahtp.uuid1 = @e[tag=ariahtp.pearl,limit=1] ariahtp.uuid1 if score @s ariahtp.uuid2 = @e[tag=ariahtp.pearl,limit=1] ariahtp.uuid2 if score @s ariahtp.uuid3 = @e[tag=ariahtp.pearl,limit=1] ariahtp.uuid3 run tag @s add ariahtp.player

# reset the scoreboard objective for another use
scoreboard players reset @e ariahtp.uuid0
scoreboard players reset @e ariahtp.uuid1
scoreboard players reset @e ariahtp.uuid2
scoreboard players reset @e ariahtp.uuid3

# tag the teleporter that the player is coming from "ariahtp.from"
tag @e[tag=ariahtp.linked,limit=1,sort=nearest] add ariahtp.from

# execute AS each linked teleporter that isn't the one the player is coming from;
# STORE in the scoreboard objective;
# RUN get the UUID of said teleporter
execute as @e[tag=ariahtp.linked,tag=!ariahtp.from] store result score @s ariahtp.uuid0 run data get entity @s UUID[0]
execute as @e[tag=ariahtp.linked,tag=!ariahtp.from] store result score @s ariahtp.uuid1 run data get entity @s UUID[1]
execute as @e[tag=ariahtp.linked,tag=!ariahtp.from] store result score @s ariahtp.uuid2 run data get entity @s UUID[2]
execute as @e[tag=ariahtp.linked,tag=!ariahtp.from] store result score @s ariahtp.uuid3 run data get entity @s UUID[3]

# execute AS the teleporter we're coming from;
# STORE in the scoreboard objective;
# RUN get the UUID of the target teleporter
execute as @e[tag=ariahtp.from] store result score @s ariahtp.uuid0 run data get entity @s ArmorItems[0].tag.CanDestroy[0]
execute as @e[tag=ariahtp.from] store result score @s ariahtp.uuid1 run data get entity @s ArmorItems[0].tag.CanDestroy[1]
execute as @e[tag=ariahtp.from] store result score @s ariahtp.uuid2 run data get entity @s ArmorItems[0].tag.CanDestroy[2]
execute as @e[tag=ariahtp.from] store result score @s ariahtp.uuid3 run data get entity @s ArmorItems[0].tag.CanDestroy[3]

# execute AS each linked teleporter that isn't the one the player is coming from;
# IF their UUID matches the one we're looking for;
# RUN tag that teleporter "ariahtp.dest"
execute as @e[tag=ariahtp.linked,tag=!ariahtp.from] if score @s ariahtp.uuid0 = @e[tag=ariahtp.from,limit=1] ariahtp.uuid0 if score @s ariahtp.uuid1 = @e[tag=ariahtp.from,limit=1] ariahtp.uuid1 if score @s ariahtp.uuid2 = @e[tag=ariahtp.from,limit=1] ariahtp.uuid2 if score @s ariahtp.uuid3 = @e[tag=ariahtp.from,limit=1] ariahtp.uuid3 run tag @s add ariahtp.dest

# execute AT the player that is teleporting;
# RUN play a teleport sound (at the player's initial position)
execute at @a[tag=ariahtp.player] run playsound minecraft:entity.enderman.teleport player @a[tag=!ariahtp.player,distance=..8]

# execute AS the destination teleporter;
# RUN set the destination teleporter's rotation to the player's rotation
execute as @e[tag=ariahtp.dest] run data modify entity @s Rotation set from entity @a[tag=ariahtp.player,limit=1] Rotation

# teleport the player to the destination
tp @a[tag=ariahtp.player] @e[tag=ariahtp.dest,limit=1]

# execute AT the player;
# RUN play a teleport sound (at the player's destination)
execute at @a[tag=ariahtp.player] run playsound minecraft:entity.enderman.teleport player @a[distance=..8]

# delete the scoreboard objectives we made earlier
scoreboard objectives remove ariahtp.uuid0
scoreboard objectives remove ariahtp.uuid1
scoreboard objectives remove ariahtp.uuid2
scoreboard objectives remove ariahtp.uuid3

# untag the teleporting player "ariahtp.player"
tag @e[tag=ariahtp.player] remove ariahtp.player

# untag the "from" teleporter "ariahtp.from"
tag @e[tag=ariahtp.from] remove ariahtp.from

# untag the "destination" teleporter "ariahtp.dest"
tag @e[tag=ariahtp.dest] remove ariahtp.dest

# kill self (the ender pearl being thrown)
kill @s