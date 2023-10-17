# tag self (the teleporter whose netherite block has been destroyed) "ariahtp.delete"
tag @s add ariahtp.delete

# execute IF self is linked (has the tag "ariahtp.linked");
# RUN create four dummy scoreboard objectives for each component of a UUID
execute if entity @s[tag=ariahtp.linked] run scoreboard objectives add ariahtp.uuid0 dummy
execute if entity @s[tag=ariahtp.linked] run scoreboard objectives add ariahtp.uuid1 dummy
execute if entity @s[tag=ariahtp.linked] run scoreboard objectives add ariahtp.uuid2 dummy
execute if entity @s[tag=ariahtp.linked] run scoreboard objectives add ariahtp.uuid3 dummy

# execute IF self is linked;
# STORE in the newly created scoreboard objectives;
# RUN get the UUID stored in their worn linking pearl (the UUID of the OTHER teleporter)
execute if entity @s[tag=ariahtp.linked] store result score @s ariahtp.uuid0 run data get entity @s ArmorItems[0].tag.CanDestroy[0]
execute if entity @s[tag=ariahtp.linked] store result score @s ariahtp.uuid1 run data get entity @s ArmorItems[0].tag.CanDestroy[1]
execute if entity @s[tag=ariahtp.linked] store result score @s ariahtp.uuid2 run data get entity @s ArmorItems[0].tag.CanDestroy[2]
execute if entity @s[tag=ariahtp.linked] store result score @s ariahtp.uuid3 run data get entity @s ArmorItems[0].tag.CanDestroy[3]

# execute IF self is linked;
# AS each teleporter that isn't self;
# STORE in the newly created scoreboard objectives;
# RUN get the UUID of said teleporter
execute if entity @s[tag=ariahtp.linked] as @e[tag=ariahtp.linked,tag=!ariahtp.delete] store result score @s ariahtp.uuid0 run data get entity @s UUID[0]
execute if entity @s[tag=ariahtp.linked] as @e[tag=ariahtp.linked,tag=!ariahtp.delete] store result score @s ariahtp.uuid1 run data get entity @s UUID[1]
execute if entity @s[tag=ariahtp.linked] as @e[tag=ariahtp.linked,tag=!ariahtp.delete] store result score @s ariahtp.uuid2 run data get entity @s UUID[2]
execute if entity @s[tag=ariahtp.linked] as @e[tag=ariahtp.linked,tag=!ariahtp.delete] store result score @s ariahtp.uuid3 run data get entity @s UUID[3]

# execute IF self is linked;
# AS each teleporter that isn't self;
# IF their UUID is the linked UUID to the teleporter we're destroying;
# RUN tag the teleporter "ariahtp.delete" (queue it for deletion too)
execute if entity @s[tag=ariahtp.linked] as @e[tag=ariahtp.linked,tag=!ariahtp.delete] if score @s ariahtp.uuid0 = @e[tag=ariahtp.delete,limit=1] ariahtp.uuid0 if score @s ariahtp.uuid1 = @e[tag=ariahtp.delete,limit=1] ariahtp.uuid1 if score @s ariahtp.uuid2 = @e[tag=ariahtp.delete,limit=1] ariahtp.uuid2 if score @s ariahtp.uuid3 = @e[tag=ariahtp.delete,limit=1] ariahtp.uuid3 run tag @s add ariahtp.delete

# execute IF self is linked;
# RUN delete the created scoreboard objectives
execute if entity @s[tag=ariahtp.linked] run scoreboard objectives remove ariahtp.uuid0
execute if entity @s[tag=ariahtp.linked] run scoreboard objectives remove ariahtp.uuid1
execute if entity @s[tag=ariahtp.linked] run scoreboard objectives remove ariahtp.uuid2
execute if entity @s[tag=ariahtp.linked] run scoreboard objectives remove ariahtp.uuid3

# execute AT both teleporters queued for deletion;
# RUN play a sound showing that the teleporters are being deactivated
execute at @e[tag=ariahtp.delete] run playsound minecraft:block.beacon.deactivate block @a[distance=..8]

# execute AS both teleporters queued for deletion, check for any other forceloader before removing forceload
execute as @e[tag=ariahtp.delete] run tag @s remove global.forceload

scoreboard objectives add ariahtp.math dummy
scoreboard players set #16 ariahtp.math 16

execute as @e[tag=ariahtp.delete] store result score @s ariahtp.math run data get entity @s Pos[0]
execute as @e[tag=ariahtp.delete] run scoreboard players operation @s ariahtp.math /= #16 ariahtp.math
execute as @e[tag=ariahtp.delete] store result entity @s Pos[0] double 16 run scoreboard players get @s ariahtp.math

execute as @e[tag=ariahtp.delete] store result score @s ariahtp.math run data get entity @s Pos[2]
execute as @e[tag=ariahtp.delete] run scoreboard players operation @s ariahtp.math /= #16 ariahtp.math
execute as @e[tag=ariahtp.delete] store result entity @s Pos[2] double 16 run scoreboard players get @s ariahtp.math

execute as @e[tag=ariahtp.delete] run data modify entity @s Pos[1] set value -64.0d

execute at @e[tag=ariahtp.delete] unless entity @e[tag=global.forceload,dx=15,dy=319,dz=15] run forceload remove ~ ~

scoreboard objectives remove ariahtp.math

# kill both teleporters queued for deletion
kill @e[tag=ariahtp.delete]