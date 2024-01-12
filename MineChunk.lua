--[[
TODO:
~ implement docking station for fuel & cargo
~ make sure tim isnt stopped by blocks in front of it
--]]

--[[
The turtle's position in respect to the chunk will determine its orientation.
For the following corners:

NW, turtle faces WEST
NE, turtle faces SOUTH
SW, turtle faces NORTH
SE, turtle faces EAST

*Start by simply placing Timothee in the "bottom left" corner of the chunk (relative to the
player), facing forward.

Starting on the corner its placed, it digs out the block below it before digging out blocks below 
it in a straight line ahead of it; digging out a "lane". Once it reaches the opposite edge of the 
chunk, it goes to the next lane to the right, digging it out. Timothee continues this in a snake-
like pattern until it has dug out a layer. It then goes down a block and continues to dig (again)
in a snake-like pattern going the other direction. Continuing this cycle until it has reached 
bedrock, filled its inventory, or run low on fuel. 

Once Timothee runs low on fuel, it **SHOULD** return to the docking station to refuel and deposit
the items it's mined. Lil' Tim automatically fuels up using coal / other burnable items it mines, 
which isn't enough to keep it fueled all the way to bedrock, so keep the fuel input stocked. 
--]]


-- Functions -----------
function getBlockBelow()
    --[[
    getBlockBelow() uses turtle.inspectDown() to get JUST the name of the block below
    :params: N/A
    :returns: string in the form "<mod>:<block_name>"
    --]] 
    local valid_block_below
    local block_data

    valid_block_below, block_data = turtle.inspectDown()

    return block_data
end

function searchForFuel()
    --[[
    searchForFuel() searches the turtle's inventory for fuel. If any, refuel.
    :params: N/A
    :returns bool: true if the turtle was able to refuel, false if not
    --]] 
    local refueled = false

    for i=1,16 do
        turtle.select(i)
        if turtle.refuel(0) then
            turtle.refuel()
            refueled = true
            chatBox.sendMessage("Timothee refueled!")
        end
    end

    if refueled == false then
        chatBox.sendMessage("Timothee is completely juiced!")
    end

    turtle.select(1)
end

function digLine(length)
    --[[
    digLine() digs a trench below the turtle 
    :param distance: the desired length of the trench 
    :returns: N/A
    --]] 
    for i=1,length do
        turtle.forward()
        turtle.digDown()
    end

end

function digLeftToRight(depth, width)
    --[[
    digLine() digs an area below the turtle in a snaking pattern
    :param depth: The "depth" of the area. In a 2d rectangle, this would be the length.
    :param width: The width of the area.
    :returns: N/A
    --]] 
    if turtle.getFuelLevel() <= (depth * width) then
        searchForFuel()
    end

    for i=1,math.ceil(width/2) do
        digLine(depth)
        turtle.turnRight()
        digLine(1)
        turtle.turnRight()
        digLine(depth)

        turtle.turnLeft()
        digLine(1)
        turtle.turnLeft()
    end

end

function digRightToLeft(depth, width)
    --[[
    digLine() digs an area below the turtle in a snaking pattern
    :param depth: The "depth" of the area. In a 2d rectangle, this would be the length.
    :param width: The width of the area.
    :returns: N/A
    --]] 
    if turtle.getFuelLevel() <= (depth * width) then
        searchForFuel()
    end

    for i=1,math.ceil(width/2) do
        digLine(depth)
        turtle.turnLeft()
        digLine(1)
        turtle.turnLeft()
        digLine(depth)

        turtle.turnRight()
        digLine(1)
        turtle.turnRight()
    end
    
end


-- Setup -------------
local chunk_length = 15 -- blocks in front of the starting position
local chunk_width = 15 -- blocks to the left of starting position
local chatBox = peripheral.find("chatBox") --chatBox.sendMessageToPlayer("message", "player_name")

-- Main Loop -----------
function MainLoop()
    -- Startup
    turtle.refuel()
    turtle.digDown()
    
    -- Keep digging until at bedrock level
    while getBlockBelow() ~= "minecraft:bedrock" do
        
        -- Digs out a layer -snaking left to right- before moving onto the next.
        digLeftToRight(chunk_length, chunk_width)
        turtle.down()
        turtle.digDown()
        -- Digs out a layer -snaking right to left- before moving onto the next.
        digRightToLeft(chunk_length, chunk_width)
        turtle.down()
        turtle.digDown()
        
        --[[ 
        I figured this might be the most fuel efficient; rather than snaking one way then
        returning straight to the starting position w/o mining anything.
        --]]

        -- Tells the player via chat when inventory is full.
        if turtle.getItemSpace(16) == 0 then
            chatBox.sendMessage("Inventory is full!")
        end

    end
end

MainLoop()
