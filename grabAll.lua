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
    checkFuel()
    turtle.select(1)
    if turtle.compare() then
        print("Initial compare  ")
        m.dForward()
        m.mForward()
        if turtle.compareUp() then
            print("Up compare")
            m.setHome()
            while turtle.compareUp() do
                m.dUp()  
                m.mUp()
            end
            m.returnHome()
            if turtle.compareDown() then
                print("Down compare")
                m.setHome()
                    while turtle.compareDown() do
                        m.dDown()
                        m.mDown()
                    end
                m.returnHome()
                print (dir)
                dirCheck()
            end
        end
        grabEm()
    elseif turtle.compare() == false then
        -- try a few blocks up
        print("trying up")
        local i = 0
        if i < 5 and turtle.detectUp() == false then
            i=i+1
            m.mUp()
            if turtle.compare() then
                print("try up Match!")
                grabEm()
            end
        elseif i == 5 then
            returnHome()
        elseif i<=10 and turtle.detectDown() == false then
            print("trying down")
            i=i+1
            m.mDown()
            if turtle.compare() then
                grabEm()
            end
        end
    end
    dirCheck()
end
 
        

grabEm()
m.resetHome()
m.returnHome()

