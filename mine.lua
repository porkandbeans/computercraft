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

local quitting = false

--[[
    cycle through inventory and search for an item, return an int relating to the slot containing the item, or false if none was found
    @param startingSlot the slot to start the cycle from
    @param itemName the item you want to find
]]--
local function cycleInventory(startingSlot, itemName)
    for i = startingSlot, 16, 1
    do
        turtle.select(i)
        if(turtle.getItemDetail() ~= nil and turtle.getItemDetail().name == itemName)
        then
            return i;
        end
    end
end

--[[
    returns the index of a requested item, or false if the turtle is not carrying one
    @param  itemName    the specific name of the item you want to find
]]--
local function getItemIndex(itemName)
    turtle.select(1)
    local slotNum = cycleInventory(1, itemName)
    if(slotNum) then return true else return false;
end
 
local function refuel()
    while (turtle.getFuelLevel() < 1000)
    do
        local bucketIndex = getItemIndex("minecraft:lava_bucket")
        if(bucketIndex) -- if I have a lava bucket in my inventory
        then
            turtle.refuel()
        else
            print("found no lava, looking for coal...")
            local coalIndex = getItemIndex("minecraft:coal")
            if(coalIndex)
            then
                while( -- while the currently selected slot is NOT NOTHING and fuel level is below 1000
                    turtle.getItemDetail() ~= nil and
                    turtle.getFuelLevel() < 1000)
                do
                    turtle.refuel(1) -- refuel function from within the turtle API, not here
                end
            else
                print("found no coal, looking again...")
            end
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

local funciton sortCoal()
    local doneSorting = false

    while(doneSorting == false)
    do
        turtle.select(1)
        if(turtle.getItemDetail().name ~= "minecraft:coal")
            print("slot 1 is not coal! something very fucky is happening.")
            quitting = true
            return
        end

        local stackSize = turtle.getItemCount()
        
        if(stackSize == 64)
        then
            doneSorting = true
            return
        end

        local spareCoal = cycleInventory(2, "minecraft:coal")

        if(spareCoal)
        then
            turtle.select(spareCoal)
        end
    end
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
 
        -- deposit all but lava + coal
        if((turtle.getItemDetail() ~= nil) 
        and (turtle.getItemDetail().name ~= "minecraft:lava_bucket") 
        and (turtle.getItemDetail().name ~= "minecraft:coal"))
        then
            turtle.drop()
        elseif((turtle.getItemDetail().name == "minecraft:coal") and ())
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
    if(turtle.getItemDetail().name ~= "minecraft:coal")
        print("slot 1 is not coal! something very fucky is happening.")
        quitting = true
        return
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


while(quitting == false) -- loop forever
do
    routine()
end--[[
    cycle through inventory and search for an item, return an int relating to the slot containing the item, or false if none was found
    @param startingSlot the slot to start the cycle from
    @param itemName the item you want to find
]]--
local function cycleInventory(startingSlot, itemName)
    for i = startingSlot, 16, 1
    do
        turtle.select(i)
        if(turtle.getItemDetail() ~= nil and turtle.getItemDetail().name == itemName)
        then
            return i;
        end
    end
end

--[[
    returns the index of a requested item, or false if the turtle is not carrying one
    @param  itemName    the specific name of the item you want to find
]]--
local function getItemIndex(itemName)
    turtle.select(1)
    local slotNum = cycleInventory(1, itemName)
    if(slotNum) then return true else return false;
end