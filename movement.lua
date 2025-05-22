-- Library for general movement functions

-- Relative coordinate info
coorX = 0

coorY = 0

coorZ = 0

homeX = 0
homeY = 0
homeZ = 0
homeFacing = facing

facing = 0 --%4 in future

dir = "North"  -- Direction isn't real, north is where you're facing initially


-- Keep track of Direction
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

--Keep track of coordinates
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


-- Non-digging movement functions
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

function mForward()
    turtle.forward()
    updateCoor()
end

function mUp()
    if turtle.up() then
        coorY = coorY + 1
    end
end

function mDown()
    if turtle.down() then
        coorY = coorY - 1
    end
end

-- To stop getting stuck by gravity blocks
function digUntilEmpty()

    while turtle.detect() do

        turtle.dig()

    end

end


-- Niche vertial version of the above   
function digUpUntilEmpty()

    while turtle.detectUp() do

        turtle.digUp()

    end

end

-- Viable digging functions
function dForward()

    digUntilEmpty()
end

function dUp(x)
    digUpUntilEmpty()
end

function dDown()
        turtle.digDown()
end

-- go to function
function goTo(x,y,z,d)
    if d == nil then
        d = dir
    end
    if coorX > x then               --Resolve X axis home

        repeat

            tRight()

        until(dir == "South")

        repeat

            dForward(1)
            mForward()

        until(coorX == x)

    elseif coorX <  x then

        repeat

            tRight()

        until(dir == "North")

        repeat 

            dForward(1)
            mForward()

        until(coorX == x)

    end



    if coorZ > z then               --Resolve Z axis home

        repeat

            tRight()

        until(dir == "West")

        repeat

            dForward(1)
            mForward()

        until(coorZ == z)

    elseif coorZ < z then

        repeat

            tRight()

        until(dir == "East")

        repeat

            dForward(1)
            mForward()

        until(coorZ == z)

    end



    if coorY > y then                --Resolve Y axis home

        repeat

            mDown(1)

        until(coorY == y)

    elseif coorY < y then

        repeat

            mUp(1)

        until(coorY == y)

    end
    while dir ~= d do
        tRight()
    end
end

function setHome()
    homeX = coorX
    homeY = coorY
    homeZ = coorZ
    homeFacing = facing
end

function resetHome()
    homeX = 0
    homeY = 0
    homeZ = 0
end

function returnHome()

    if coorX > homeX then               --Resolve X axis home

        repeat

            tRight()

        until(dir == "South")

        repeat

            dForward(1)
            mForward()

        until(coorX == homeX)

    elseif coorX <  homeX then

        repeat

            tRight()

        until(dir == "North")

        repeat 

            dForward(1)
            mForward()

        until(coorX == homeX)

    end



    if coorZ > homeZ then               --Resolve Z axis home

        repeat

            tRight()

        until(dir == "West")

        repeat

            dForward(1)
            mForward()

        until(coorZ == homeZ)

    elseif coorZ < homeZ then

        repeat

            tRight()

        until(dir == "East")

        repeat

            dForward(1)
            mForward()

        until(coorZ == homeZ)

    end



    if coorY > homeY then                --Resolve Y axis home

        repeat

            mDown(1)

        until(coorY == homeY)

    elseif coorY < homeY then

        repeat

            mUp(1)

        until(coorY == homeY)

    end
end


return {
    coorX = coorX,
    coorY = coorY,
    coorZ = coorZ,
    facing = facing,
    mForward = mForward,
    mUp = mUp,
    mDown = mDown,
    tRight = tRight,
    tLeft = tLeft,
    tAround = tAround,
    dForward = dForward,
    dUp = dUp,
    dDown = dDown,
    updateDir = updateDir,
    updateCoor = updateCoor,
    returnHome = returnHome,
    setHome = setHome,
    resetHome = resetHome,
    homeX = homeX,
    homeY = homeY,
    homeZ = homeZ,
    homeFacing = homeFacing,
    dir = dir,
    goTo = goTo,
}
