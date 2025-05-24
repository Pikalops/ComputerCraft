--get movement library
local m=require("movement")


-- location variables
local branchX
local branchY
local branchZ
local branchFacing

-- store coordinates and facing before going left/right
function setBranch()
    branchX = m.coorX
    branchY = m.coorY
    branchZ = m.coorZ
end

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

function dirCheck()
    if dir == "North" then
        setBranch()
        print("setBranch" .. " " .. m.dir)
        while dir ~= "West" do
            m.tLeft()
        end
        if turtle.compare() then
            grabEm()
        end
    elseif dir == "East" then
        if turtle.compare() then
            grabEm()
        else
            print("going to branch home")
            goTo(branchX, branchY, branchZ)
            if turtle.compare() then
                grabEm()
            end
    end
    elseif dir == "West" then
        if turtle.compare() then
            grabEm()
        else
            print("going to branch home")
            goTo(branchX, branchY, branchZ)
        end
    end
end

-- Recursive function to gather all connected blocks of the same type
function grabEm()
    maxSteps = 5
    hasRun = false
    checkFuel()
    -- Select desired block
    turtle.select(1)
    if turtle.compare() then
        -- Next block is match
        print("Initial compare  ")
        m.dForward()
        m.mForward()
        if turtle.compareUp() then
            -- Block above is match
            print("Up compare")
            m.setHome()
            while turtle.compareUp() do
                m.dUp()  
                m.mUp()
            end
            m.returnHome()
            if turtle.compareDown() then
                -- Block below is match
                print("Down compare")
                m.setHome()
                    while turtle.compareDown() do
                        m.dDown()
                        m.mDown()
                    end
                m.returnHome()
                print (dir)
            end
        print("turtle.compareUp() match")
        end
        grabEm()
        return
    else
        m.setHome()
        print("up for loop")
        for i=1,maxSteps,1
        do
            if turtle.detectUp() == false then
                print("moving up for loop")
                m.mUp()
                if turtle.compare() then
                    print("try up Match!")
                    grabEm()
                    return
                end
            else
                break
            end
        end
        m.returnHome()
        print("down for loop")
        for i=1,maxSteps,1
        do
            if turtle.detectDown() == false then
                print("moving down for loop")
                m.mDown()
                if turtle.compare() then
                    print("try down Match!")
                    grabEm()
                    return
                end
            else
                break
            end

        end
        m.returnHome()
    end
end
 
        

grabEm()
m.resetHome()
m.returnHome()

--debug purposes, turning the turtle back north
m.tLeft()
m.tLeft()

