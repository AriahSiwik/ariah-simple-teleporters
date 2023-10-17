# execute AS each ender pearl item (of stack size 1) that's floating in the world;
# AT self;
# IF the block beneath is a netherite block;
# UNLESS there is an armor stand with the tag "ariahtp.teleporter" close by
# RUN ariahtp:new
execute as @e[type=minecraft:item,nbt={Item:{id:"minecraft:ender_pearl",Count:1b}},tag=!global.ignore] at @s if block ~ ~-1 ~ minecraft:netherite_block unless entity @e[type=minecraft:armor_stand,distance=..2,tag=ariahtp.teleporter] run function ariahtp:new

# execute AS each enchanted book item with NBT tag "CustomModelData:7570001" (the custom item, "linking pearl") (of stack size 1) that's floating in the world;
# AT self;
# IF the block beneath is a netherite block;
# UNLESS there is an armor stand with the tag "ariahtp.teleporter" close by;
# RUN ariahtp:link
execute as @e[type=minecraft:item,nbt={Item:{id:"minecraft:enchanted_book",Count:1b,tag:{CustomModelData:7570001}}}] at @s if block ~ ~-1 ~ minecraft:netherite_block unless entity @e[type=minecraft:armor_stand,distance=..2,tag=ariahtp.teleporter] run function ariahtp:link

# execute AS each player with an enchanted book with NBT tag "CustomModelData:7570001" (the custom item, "linking pearl") that has been put through a grindstone;
# RUN clear the enchanted book with NBT tag "CustomModelData:7570001" (the custom item, "linking pearl") that has been put through a grindstone
execute as @a[nbt={Inventory:[{id:"minecraft:enchanted_book",Count:1b,tag:{CustomModelData:7570001,RepairCost:1}}]}] run clear @s minecraft:enchanted_book{CustomModelData:7570001,RepairCost:1}

# execute AS each enchanted book item with NBT tag "CustomModelData:7570001" (the custom item, "linking pearl") that has been put through a grindstone that's floating in the world;
# RUN kill self
execute as @e[type=minecraft:item,nbt={Item:{id:"minecraft:enchanted_book",Count:1b,tag:{CustomModelData:7570001,RepairCost:1}}}] run kill @s

# execute AS each thing with the tag "ariahtp.teleporter" (our armor stands);
# AT self;
# UNLESS the block beneath is a netherite block;
# RUN ariahtp:delete
execute as @e[tag=ariahtp.teleporter] at @s unless block ~ ~-1 ~ netherite_block run function ariahtp:delete

# execute AS each thrown ender pearl entity;
# AT self;
# IF there is an armor stand with the tag "ariahtp.linked" close by;
# RUN ariahtp:teleport
execute as @e[type=minecraft:ender_pearl,tag=!global.ignore] at @s if entity @e[type=minecraft:armor_stand,tag=ariahtp.linked,distance=..2] run function ariahtp:teleport

# execute AS each thing with the tag "ariahtp.linked" (our *linked* armor stands);
# AT self;
# RUN create particles to show the teleporter is linked
execute as @e[tag=ariahtp.linked] at @s run particle portal ~ ~ ~ 0 0 0 1 1

# execute AS each thing with the tag "ariahtp.teleporter" but NOT the tag "ariahtp.linked" (our *unlinked* armor stands);
# AT self;
# RUN create particles to show the teleporter is unlinked, but ready to link
execute as @e[tag=ariahtp.teleporter,tag=!ariahtp.linked] at @s run particle minecraft:ambient_entity_effect ~ ~ ~ 0 0 0 0 1