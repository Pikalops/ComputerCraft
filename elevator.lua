--pastebin BfXczBtR

local tArgs = {...}
local direction = nil
local distance = nil

function usage()
	print("Usage: elevator <direction> [distance]\n\n")
	print("If distance is omitted, the turtle will move down the given direction until it hits a block. When going up, it will try to return to a cached height.\n")
	print("*** IF YOU HIT A BLOCK GOING UP YOU WILL LIKELY DIE ***\n")
	error()
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

function readCache()
	local file=fs.open("/elevator.tmp", "r")
	if file == nil then
		print("Cached height not found, you must provide a distance!")
		error()
	end
	
	distance=tonumber(file.readLine())
	
	if (distance == nil) or (distance < 1) then
		print("Cached height invalid, you must provide a distance!")
		error()
	end
	
	file.close()
	fs.delete("/elevator.tmp")

	return distance
end

function writeCache(n)
	local file=fs.open("/elevator.tmp", "w")

	if file == nil then
		print("couldn't open file")
		error()
	end

	file.write(n)

	file.close()
end

-- Validate command line arguments
if (table.getn(tArgs) < 1) or (table.getn(tArgs) > 2) then
	usage()
elseif (tArgs[1] ~= "up") and (tArgs[1] ~= "down") then
	usage()
elseif (table.getn(tArgs) == 2) and (tArgs[2] < 1) then
	usage()
end

direction = tArgs[1]

if table.getn(tArgs) == 2 then
	distance = tArgs[2]
end

refuel()

-- elevator down
if direction == "down" then
	-- Distance was provided, dig down that many blocks
	if distance ~= nil then
		for i=1,distance do 
			turtle.digDown()
			turtle.down()
		end
		writeCache(distance)
	-- No distance provided, go down until a block is hit
	else
		local i=0
		while turtle.detectDown() == false do
			turtle.down()
			i=i+1
		end
		writeCache(i)
	end
-- elevator up
else
	-- No distance provided, use cached distance
	if distance == nil then
		distance = readCache()
	end
	
	for i=1,distance do 
		turtle.digUp()
		turtle.up()
	end
end