# execute ALIGN on the corner between four blocks;
# POSITIONED half a block in two directions, centering on the block;
# RUN summon an armor stand with the tags "ariahtp.teleporter" and "ariahtp.new", and with the NBT tags "Marker:1b" and "Invisible:1b";
execute align xyz positioned ~0.5 ~ ~0.5 run summon minecraft:armor_stand ~ ~ ~ {Tags:["ariahtp.teleporter","ariahtp.new","global.forceload","global.ignore.kill","global.ignore.pos","global.ignore.gui"],Marker:1b,Invisible:1b}

# summon an enchanted book item with the tag "ariahtp.linker", and the NBT tags responsible for it to be our custom item "Linking Pearl"
summon minecraft:item ~ ~ ~ {Tags:["ariahtp.linker"],Item:{id:"minecraft:enchanted_book",Count:1b,tag:{smithed:{ignore:{functionality:1b,crafting:1b}}, ctc:{id:"linking_pearl",from:"ariahtp"},CustomModelData:7570001,RepairCost:999999999,StoredEnchantments:[{lvl: 1s, id:"minecraft:binding_curse"}],HideFlags:32,display:{Name:'{"text":"Teleporter Linker","color":"#dddddd","italic":false}',Lore:['{"text":"Drop on a Netherite Block to link teleporter.","color":"#888888","italic":false}']}}}}

# modify the data of the newly created item so that it stores the UUID of the teleporter it links to
data modify entity @e[tag=ariahtp.linker,limit=1] Item.tag.CanDestroy set from entity @e[tag=ariahtp.new,limit=1] UUID

# execute AS each thing with the tag "ariahtp.new" (our newly created armor stand);
# AT self;
# RUN ariahtp:forceload
execute as @e[tag=ariahtp.new] at @s run function ariahtp:forceload

# remove the tag "ariahtp.new" from our newly created armor stand
tag @e[tag=ariahtp.new] remove ariahtp.new

# play a sound to show that the teleporter has been created
playsound minecraft:item.flintandsteel.use block @a[distance=..8]

# kill self (the ender pearl item that was used to create the portal)
kill @s