local ignoreThese = { --yo noobs, figure out what the names of blocks you don't want are called and add them to this array
    "minecraft:stone", 
    "minecraft:cobblestone", 
    "minecraft:gravel", 
    "minecraft:sand", 
    "rustic:slate",
    "chisel:basalt",
    "chisel:basalt2",
    "minecraft:dirt",
}
--why the fuck are arrays called tables
 
local function getItemIndex(itemName) --return the index of requested item, or false if it isn't held
    turtle.select(1)
    for i = 1, 16, 1
    do
        turtle.select(i)
        if(turtle.getItemDetail() ~= nil and turtle.getItemDetail().name == itemName)
        then
            return i;
        end
    end
    return false;
end
 
local function refuel()
    local bucketIndex = getItemIndex("minecraft:lava_bucket")
    if(bucketIndex)
    then
        turtle.refuel()
    else
        print("no lava, looking for coal...")
        local coalIndex = getItemIndex("minecraft:coal")
        if(coalIndex)
        then
            while(
                turtle.getItemDetail() ~= nil and
                turtle.getFuelLevel() < 1000)
            do
                turtle.refuel(1)
            end
        else
            print("can't refuel!")
            error("no lava or coal!")
        end
    end
end
 
local function diggy()
    turtle.dig()
    turtle.digUp()
    turtle.digDown()
    while(turtle.forward() == false)
    do
        turtle.dig()
    end
    if(turtle.getFuelLevel() < 1000)
    then
        refuel()
    end
end
 
local function continue(steps)
    for i = 0, steps, 1
    do
        diggy()
    end
    turtle.turnLeft()
end
 
local function dumpInventory()
    for i = 1, 16, 1 --cycle through inventory
    do
        turtle.select(i)
        -- check for unwanted items
        for i=1, #ignoreThese, 1
        do
            if(turtle.getItemDetail() ~= nil and turtle.getItemDetail().name == (ignoreThese[i]))
            then
                turtle.dropDown()
            end
        end
 
        -- deposit all but lava
        if(
            turtle.getItemDetail() ~= nil and 
            turtle.getItemDetail().name ~= "minecraft:lava_bucket")
        then
            turtle.drop()
        end
    end
    turtle.turnLeft()
    local bucketIndex = getItemIndex("minecraft:lava_bucket")
    if(bucketIndex == false)
    then
        turtle.suck(1)
    end
    turtle.turnLeft()
end
 
local function returnHome()
    turtle.turnRight()
    local done = false
    local steps = 0
    while (not done)
    do
        local succ, data = turtle.inspect()
        if(data.name ~= "minecraft:chest" and data.name ~= "quark:custom_chest")
        then
            diggy()
            steps = steps + 1
        else
            done = true
            dumpInventory()
            continue(steps)
        end
    end
end
 
local function routine()
    print("performing routine")
    for i = 0, 30, 1
    do
        diggy()
    end
    turtle.turnRight()
    diggy()
    turtle.turnRight()
    for i = 0, 30, 1
    do
        diggy()
    end
    returnHome()
end
 
refuel()
while(true)
do
    routine()
end