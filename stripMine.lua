-- base movement
-- pastebin sfdXCBH8
if turtle.extended == nil then
    require "turtle" 
end

--Home position/orientation assumed 0,0,0 north =0 east =1 south =2 west =3
local tArgs = {...}  -- expecting <length> <tunnels (forced even)>
local tunnels = 0
local length = nil
local tunnelsRemaining = nil
local path = {init}

function usage()
    print("Usage: stripMine <length> <tunnels>\n")
    print("*** TUNNELS MUST BE EVEN ***")
    error()
end

function dumpState()
    print("tunnels: " .. tunnels)
    print("length: " .. length)
    print("tunnelsRemaining: ".. tunnelsRemaining)
    turtle.dumpState()
end

function mForward(x)
    for i = 1, x, 1 do
        turtle.forward()
    end
end

function mBack(x)
    turtle.turnAround()
    for i = 1, x, 1 do
        turtle.forward()
    end
end

function mRight(x)
    turtle.turnRight()
    for i = 1, x, 1 do
        turtle.forward()
    end
end

function mLeft(x)
    turtle.turnLeft()
    for i = 1, x, 1 do
        turtle.forward()
    end
end

function mUp(x)
    for i = 1, x, 1 do
        turtle.up()
    end
end

function mDown(x)
    for i = 1, x, 1 do
        turtle.down()
    end
end

function returnHome()
    if turtle.coorX > 0 then               --Resolve X axis home
        repeat
            turtle.turnRight()
            print("Resolving X axis: target South current " .. turtle.dir)
        until(turtle.dir == "South")
        repeat
            dForward(1)
        until(turtle.coorX == 0)
    elseif turtle.coorX < 0 then
        repeat
            turtle.turnRight()
            print("Resolving X axis: target North current " .. turtle.dir)
        until(turtle.dir == "North")
        repeat 
            dForward(1)
        until(turtle.coorX == "0")
    end

    if turtle.coorZ > 0 then               --Resolve Z axis home
        repeat
            turtle.turnRight()
            print("Resolving Z axis: target West current " .. turtle.dir)
        until(turtle.dir == "West")
        repeat
            dForward(1)
        until(turtle.coorZ == 0)
    elseif turtle.coorZ < 0 then
        repeat
            turtle.turnRight()
            print("Resolving Z axis: target East current " .. turtle.dir)
        until(turtle.dir == "East")
        repeat
            dForward(1)
        until(turtle.coorZ == 0)
    end

    if turtle.coorY > 0 then               --Resolve Y axis home
        repeat
            mDown(1)
        until(turtle.coorY == 0)
    elseif turtle.coorY < -1 then
        repeat
            mUp(1)
        until(turtle.coorY == 0)
    end

    if turtle.dir ~= "North" then
        repeat
            turtle.turnRight()
            print("Resolving Y axis: target North current " .. turtle.dir)
        until turtle.dir == "North"
    end
end

function determineMovement()
    for i = 1, #path[1], 1 do
        local t = string.sub(path[1], i, i)
        print(t)
        if t == "e" then
            mForward(1)
        elseif t == "x" then
            turtle.turnAround()
        elseif t == "r" then
            turtle.turnRight()
        elseif t == "w" then
            turtle.turnLeft()
        elseif t == "s" then
            mLeft(1)
        elseif t == "f" then
            mRight(1)
        elseif t == "u" then
            mUp(1)
        elseif t == "d" then
            mDown(1)
        elseif t == "h" then
            returnHome()
        elseif t == "E" then
            dForward(1)
        elseif t == "." then
            io.write()
        elseif t == "t" then
            torch()
        elseif t == "D"then
            dropOff()
        else
            print("Unknown direction")
        end
    end
end

function digUntilEmpty()
    while turtle.detect() do
        turtle.dig()
    end
end

function digUpUntilEmpty()
    while turtle.detectUp() do
        turtle.digUp()
    end
end

function dForward(x)
    digUntilEmpty()
    mForward(1)
    turtle.digDown()
end

function torch()
    turtle.select(1)
    local heldItem = turtle.getItemDetail()
    if heldItem.name == "minecraft:torch" then
        turtle.placeDown()
    else print("No torches")
    end
end

function createPath()
    path[1] = "u"
    if tunnelsRemaining ~= nil and tunnelsRemaining ~= 1 and (tunnelsRemaining % 2) ~= 0 then
        tunnelsRemaining = tunnelsRemaining + 1
    elseif tunnelsRemaining == nil then
        tunnelsRemaining = 1
    end
    
    for i = 1, tunnelsRemaining do
        if length > 0 then
            for i = 1, length do
                path[1] = path[1] .. "E"
                if i % 7 == 0 then                --torch logic
                    path[1] = path[1] .. "wtr"
                end
            end
        end
        tunnelsRemaining = tunnelsRemaining - 1
        tunnels = tunnels + 1
        pitStop()
        if (tunnelsRemaining % 2) ~= 0  and tunnelsRemaining > 0 then
            path[1] = path[1] .. "rEEEEr"
        end
    end
end

function dropOff()
    for i = 3, 16, 1 do
        turtle.select(i)
        turtle.dropDown()
    end
    turtle.select(1)
    dumpState()
end

function pitStop()
    refuel()
    if tunnels > 1 and (tunnelsRemaining % 2) == 0 then
        path[1] = path[1] .. "r"
        for i = 1, (tunnels - 1) * 4 do
            path[1] = path[1] .. "E"
        end
        if tunnelsRemaining ~= 0 then
            path[1] = path[1] .. "dDurr"
            for i = 1, (tunnels * 4) do
                path[1] = path[1] .. "E"
            end
        end
        path[1] = path[1] .. "w"
    end
end

function refuel()
    if turtle.getFuelLevel() < 200 then
        repeat 
            turtle.select(2)
            turtle.refuel()
        until(turtle.getFuelLevel()>200)
        turtle.select(1)
    end
end

-- Validate command line arguments
if table.getn(tArgs) ~= 2 then
    usage()
else
    length = tonumber(tArgs[1])
    tunnelsRemaining = tonumber(tArgs[2])

    if (length == nil) or (tunnelsRemaining == nil) or (tunnelsRemaining % 2 ~= 0) then
        usage()
    end
end

refuel()
createPath()
determineMovement()
returnHome()
dropOff()