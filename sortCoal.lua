local quitting = false
local coalStack = 0

--[[
    cycle through inventory and search for an item, return
    an int relating to the slot containing the item, or false if none was found
    @param startingSlot the slot to start the cycle from
    @param itemName the item you want to find
]]--
local function cycleInventory(startingSlot, itemName)
    for i = startingSlot, 16, 1
    do
        turtle.select(i)
        if(turtle.getItemDetail() ~= nil and turtle.getItemDetail().name == itemName)
        then
            return i
        end
    end

    return false
end

--[[
    returns the index of a requested item, or false if the turtle is not carrying one
    @param  itemName    the specific name of the item you want to find
]]--
local function getItemIndex(itemName)
    turtle.select(1)
    local slotNum = cycleInventory(1, itemName)
    if(slotNum)
    then 
        return true
    else 
        return false 
    end
end

local function sortCoal()
    local doneSorting = false

    while(doneSorting == false)
    do
        turtle.select(1)
        if(turtle.getItemDetail() == nil) or (turtle.getItemDetail().name ~= "minecraft:coal")
        then
            print("slot 1 is not coal! quitting...")
            quitting = true
            return
        end

        coalStack = turtle.getItemCount()
        
        if(coalStack == 64)
        then
            doneSorting = true
            return
        else

            local spareCoal = cycleInventory(2, "minecraft:coal")

            if(spareCoal)
            then
                turtle.select(spareCoal)
                while(turtle.getItemCount() > 0 and coalStack < 64)
                do
                    turtle.transferTo(1, 1)
                    coalStack = coalStack + 1
                end
            else
                print("there's no more coal to stack.")
                doneSorting = true
                quitting = true
            end
        
        end
    end
end

while (quitting == false)
do
    sortCoal()
end