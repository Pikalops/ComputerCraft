--get movement library
local m=require("movement")

-- location variables
-- Refuel first, if needed
if turtle.getFuelLevel() < 100 then
    print("Refueling")
    while turtle.getFuelLevel() < 250 do
        turtle.select(2)
        if turtle.refuel(1) == false then
            print("No more fuel")
            break
        end
    end
end

-- Recursive function to gather all connected blocks of the same type
function grabEm()
    if turtle.compare() then
        m.dForward()
        m.mForward()
        if turtle.compareUp() then
            m.setHome()
            while turtle.compareUp() do
                m.dUp()  
                m.mUp()
            end
            m.returnHome()
            if turtle.compareDown() then
                m.setHome()
                    while turtle.compareDown() do
                        m.dDown()
                        m.mDown()
                    end
                m.returnHome()
            end
        end
        grabEm()
    elseif turtle.compare() == false then
        -- try a few blocks up/down
        for i=0,5 do
            if turtle.detectUp() == false then
                m.mUp()
                if turtle.compare() then
                grabEm()
                end
            else
                break
            end

        end
    else
        print("No more blocks")
    end
 
end
        

grabEm()
m.resetHome()
print(homeX, homeY, homeZ)
print(coorX, coorY, coorZ)
m.returnHome()

