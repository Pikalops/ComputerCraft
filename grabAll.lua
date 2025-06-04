-- grab movement library
require "turtle"

-- Initiate extra location variables
-- for main recursion
local trunkX = 0
local trunkY = 0
local trunkZ = 0

-- for offshoot branches
local branchX = 0
local branchY = 0
local branchZ = 0

-- flag for reaching full recursion depth
local fullRecursion = false

--Saftey dig functions to resolve possible issues with gravity blocks
function digUntilEmpty()
    -- dig until no more blocks in front
    while turtle.detect() do
        turtle.dig()
    end
end

function digUpUntilEmpty()
    -- dig until no more blocks above
    while turtle.detectUp() do
        turtle.digUp()
    end
end


-- refuel if needed
function checkFuel()
    if turtle.getFuelLevel() < 100 then
        print("Refueling")
        while turtle.getFuelLevel() < 250 do
            turtle.select(2)
            if turtle.refuel(1) == false then
                print("No more fuel")
                turtle.select(1)
                break
            end
        end
        turtle.select(1)
    end
end

-- store coordinates for the main trunk
function setTrunk()
    trunkX = turtle.coorX
    trunkY = turtle.coorY
    trunkZ = turtle.coorZ
end

-- store coordinates before going left/right
function setBranch()
    branchX = turtle.coorX
    branchY = turtle.coorY
    branchZ = turtle.coorZ
end

function checkVerticalContinue()
    setTrunk()
    for i=1,maxSteps,1 do
        if turtle.detectUp() == false then
            if turtle.compare() then
                grabAll()
                return
            end
            turtle.up()
        else
            break
        end
    end
    turtle.goTo(trunkX, trunkY, trunkZ)
    for i=1,maxSteps,1 do
        if turtle.detectDown() == false then
            if turtle.compare() then
                grabAll()
                return
            end
            turtle.down()
        else
            turtle.goTo(trunkX, trunkY, trunkZ)
            break
        end
    end
    fullRecursion = true
end
    

-- Main recursion function to gather all connected blocks for the same type
function grabAll()
    maxSteps = 5

    checkFuel()

    --select desired item
    turtle.select(1)

    --start of primary logic
    if turtle.compare() then
        digUntilEmpty()
        turtle.forward()
        -- begin vertical checks
        -- +Y checks
        if turtle.compareUp() then
            setTrunk()
            while turtle.compareUp() do
                digUpUntilEmpty()
                turtle.up()
            end
            --resolve Y
            turtle.goTo(trunkX, trunkY, trunkZ)

            -- -Y checks
            if turtle.compareDown() then
                setTrunk()
                while turtle.compareDown() do
                    turtle.digDown()
                    turtle.down()
                end
                --resolve Y
                turtle.goTo(trunkX, trunkY, trunkZ)
            end
        end

        -- branch logic
        if turtle.dir == "North" then
            turtle.turnLeft()
            setBranch()
            if turtle.compare() then
                grabAll()
                return
            end
        end
        
        grabAll()
        return
    else
        -- vertical checks too see if able to continue recursion
        checkVerticalContinue()
    end

    --secondary branch logic
    if fullRecursion == true then
        turtle.goTo(branchX, branchY, branchZ,"East")
        if turtle.compare() then
            fullRecursion = false
            grabAll()
            return
        elseif turtle.dir == "East" then
            turtle.goTo(branchX, branchY, branchZ,"North")
            fullRecursion = false
            grabAll()
            return
        else
            return
        end
    end
end

grabAll()
turtle.goTo(0,0,0,"North")



        



        
