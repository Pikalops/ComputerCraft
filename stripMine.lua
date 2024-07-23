-- base movement
-- pastebin sfdXCBH8
--Home position/orientation assumed 0,0,0 north =0 east =1 south =2 west =3
local tArgs = {...}  -- expecting <length> <tunnels (forced even)>
local tunnels = 0
local path = {init}
local coorX = 0
local coorY = 0
local coorZ = 0
local facing = 0 --%4 in future
local dir = "North"

function updateDir()
    if facing%4 == 0 then
        dir = "North"
    elseif facing%4 == 1 then
        dir = "East"
    elseif facing%4 == 2 then
        dir ="South"
    elseif facing%4==3 then
        dir = "West"
    else
        print("Update failed")
    end
end

function tRight()
    turtle.turnRight()
    facing = facing +1
    updateDir()
end

function tLeft()
    turtle.turnLeft()
    facing = facing -1
    updateDir()
end

function tAround()
    turtle.turnLeft()
    turtle.turnLeft()
    facing = facing -2
    updateDir()
end

function updateCoor()
    if facing%4 == 0 then
        coorX = coorX+1
        updateDir()
    elseif facing%4 == 2 then
        coorX = coorX -1
        updateDir()
    elseif facing%4 == 1 then
        coorZ = coorZ +1
        updateDir()
    elseif facing%4 ==3 then
        coorZ = coorZ -1
        updateDir()
    else
        print("I am lost")
    end
end

function mForward(x)
    for i=1,x,1 do
        if turtle.forward() then
            updateCoor()
        else
            print("Stuck at "..coorX..","..coorY..","..coorZ)
            while turtle.detect() do
            end
            turtle.forward()
            updateCoor()
        end
    end
end

function mBack(x)
    tAround()
    for i=1,x,1 do
        if turtle.forward() then
            updateCoor()
        else
            print("Stuck at "..coorX..","..coorY..","..coorZ)
            while turtle.detect() do
            end
            turtle.forward()
            updateCoor()
        end
    end
end

function mRight(x)
    tRight()
    for i=1,x,1 do
        if turtle.forward() then
            updateCoor()
        else
            print("Stuck at "..coorX..","..coorY..","..coorZ)
            while turtle.detect() do
            end
            turtle.forward()
            updateCoor()
        end
    end
end

function mLeft(x)
    tLeft()
    for i=1,x,1 do
        if turtle.forward() then
            updateCoor()
        else
            print("Stuck at "..coorX..","..coorY..","..coorZ)
            while turtle.detect() do
            end
            turtle.forward()
            updateCoor()
        end
    end
end

function mUp(x)
    for i=1,x,1 do
        if turtle.up() then
            coorY = coorY + 1
        else
            print("Stuck at "..coorX..","..coorY..","..coorZ)
            while turtle.detectUp() do
            end
            turtle.up()
            coorY = coorY +1
        end
    end
end

function mDown(x)
    for i=1,x,1 do
        if turtle.down() then
            coorY = coorY - 1
            x=x-1
        else
            print("Stuck at "..coorX..","..coorY..","..coorZ)
            while turtle.detectDown() do
            end
            turtle.down()
            coorY = coorY -1
        end

    end
end

function returnHome()
    if coorX > 0 then               --Resolve X axis home
        repeat
            tRight()
        until(dir == "South")
        repeat
            dForward(1)
        until(coorX == 0)
    elseif coorX < 0 then
        repeat
            tRight()
        until(dir == "North")
        repeat 
            dForward(1)
        until(coorX == "0")
    end

    if coorZ > 0 then               --Resolve Z axis home
        repeat
            tRight()
        until(dir == "West")
        repeat
            dForward(1)
        until(coorZ == 0)
    elseif coorZ < 0 then
        repeat
            tRight()
        until(dir == "East")
        repeat
            dForward(1)
        until(coorZ == 0)
    end

    if coorY >0 then                --Resolve Y axis home
        repeat
            mDown(1)
        until(coorY == 0)
    elseif coorY < -1 then
        repeat
            mUp(1)
        until(coorY == 0)
    end

    if dir ~= "North" then
        repeat
            tRight()
        until dir == "North"
    end
end

function determineMovement()
    for i = 1,#path[1],1 do
        local t = string.sub(path[1],i,i)
        print(t)
        if t == "e" then
            mForward(1)
        elseif t == "x" then
            tAround()
        elseif t == "r" then
            tRight()
        elseif t == "w" then
            tLeft()
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
    if tArgs[2] ~= nil and tArgs[2] ~=1 and tArgs[2]%2 ~=0 then
        tArgs[2] = tArgs[2] + 1
    elseif tArgs[2] == nil then
        tArgs[2] = 1
    end
    
    for i=1,tArgs[2] do
        if #tArgs[1] > 0 then
            for i=1,tArgs[1] do
                path[1] = path[1].."E"
                if i%7 == 0 then                --torch logic
                    path[1] = path[1].."wtr"
                end
            end
        end
        tArgs[2] = tArgs[2] - 1
        tunnels = tunnels + 1
        pitStop()
        if tArgs[2]%2 ~=0  and tArgs[2] > 0 then
            path[1] = path[1].."rEEEEr"
        end
    end
end

function dropOff()
    for i=3,16,1 do
        turtle.select(i)
        turtle.dropDown()
    end
    turtle.select(1)
end

function pitStop()
    refuel()
    if tunnels > 1 and tArgs[2]%2 == 0 then
        path[1] = path[1].."r"
        for i=1,(tunnels-1)*4 do
            path[1] = path[1].."E"
        end
        if tArgs[2] ~=0 then
            path[1] = path[1].."dDurr"
            for i=1,(tunnels)*4 do
                path[1] = path[1].."E"
            end
        end
        path[1] = path[1].."w"
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

refuel()
createPath()
determineMovement()
returnHome()
dropOff()

