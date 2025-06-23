print("turtle.lua loaded")

turtle.extended = true

turtle.dir = "North"
turtle.facing = 0
turtle.coorX = 0
turtle.coorY = 0
turtle.coorZ = 0


local baseTurnRight = turtle.turnRight
local baseTurnLeft = turtle.turnLeft
local baseForward = turtle.forward
local baseUp = turtle.up
local baseDown = turtle.down

function turtle.updateDir()
    local facing = turtle.facing%4

    if facing == 0 then
        turtle.dir = "North"
    elseif facing == 1 then
        turtle.dir = "East"
    elseif facing == 2 then
        turtle.dir ="South"
    elseif facing == 3 then
        turtle.dir = "West"
    else
        print("Update failed")
    end
end

function turtle.updateCoor()
    local facing = turtle.facing%4

    if facing == 0 then
        turtle.coorX = turtle.coorX+1
        turtle.updateDir()
    elseif facing == 2 then
        turtle.coorX = turtle.coorX -1
        turtle.updateDir()
    elseif facing == 1 then
        turtle.coorZ = turtle.coorZ +1
        turtle.updateDir()
    elseif facing == 3 then
        turtle.coorZ = turtle.coorZ -1
        turtle.updateDir()
    else
        print("I am lost")
    end
end

function turtle.turnRight()
    baseTurnRight()
    turtle.facing = turtle.facing +1
    turtle.updateDir()
end

function turtle.turnLeft()
    baseTurnLeft()
    turtle.facing = turtle.facing -1
    turtle.updateDir()
end

function turtle.turnAround()
    turtle.turnLeft()
    turtle.turnLeft()
end

function turtle.forward()
    local success = baseForward()
    if success == false then
        print("Stuck at "..turtle.coorX..","..turtle.coorY..","..turtle.coorZ)
        while turtle.detect() do
        end
        baseForward()
    end
    turtle.updateCoor()
end

function turtle.up()
    local success = baseUp()
    if success == false then
        print("Stuck at "..turtle.coorX..","..turtle.coorY..","..turtle.coorZ)
        while turtle.detectUp() do
        end
        baseUp()
    end
    turtle.coorY = turtle.coorY +1
end

function turtle.down()
    local success = baseDown()

    if success == false then
        print("Stuck at "..turtle.coorX..","..turtle.coorY..","..turtle.coorZ)
        while turtle.detectDown() do
        end
        baseDown()
    end

    turtle.coorY = turtle.coorY -1
end

-- go to function
--d is optional, will not turn after moving unless provided
function turtle.goTo(x,y,z,d)
    if d == nil then
        d = turtle.dir
    end
    if turtle.coorX > x then               --Resolve X axis home
        repeat
            turtle.turnRight()
        until(turtle.dir == "South")
        repeat
            turtle.dig()
            turtle.forward()
        until(turtle.coorX == x)

    elseif turtle.coorX <  x then
        repeat
            turtle.turnRight()
        until(turtle.dir == "North")
        repeat 
            turtle.dig()
            turtle.forward()
        until(turtle.coorX == x)
    end
    if turtle.coorZ > z then               --Resolve Z axis home
        repeat
            turtle.turnRight()
        until(turtle.dir == "West")
        repeat
            turtle.dig()
            turtle.forward()
        until(turtle.coorZ == z)

    elseif turtle.coorZ < z then
        repeat
            turtle.turnRight()
        until(turtle.dir == "East")
        repeat
            turtle.dig()
            turtle.forward()
        until(turtle.coorZ == z)
    end

    
    if turtle.coorY > y then                --Resolve Y axis home
        repeat
            turtle.digDown()
            turtle.down()
        until(turtle.coorY == y)

    elseif turtle.coorY < y then
        repeat
            turtle.digUp()
            turtle.up()
        until(turtle.coorY == y)
    end
    
    --Resolve diection

    while turtle.dir ~= d do
        turtle.turnRight()
    end

end

function turtle.dumpState()
    print("dir: "..turtle.dir.."\nfacing: "..turtle.facing.."\ncoord: ("..turtle.coorX..","..turtle.coorY..","..turtle.coorZ..")")
end