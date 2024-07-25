--pastebin BfXczBtR

local tArgs = {...}

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
end

refuel()

-- elevator down
if tArgs[1] == "down" then
	-- Distance was provided, dig down that many blocks
	if table.getn(tArgs) == 2 then
		for i=1,tArgs[2] do 
			turtle.digDown()
			turtle.down()
		end
		writeCache(tArgs[2])
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
	local distance = 0
	-- Distance was provided, go up that many blocks
	if table.getn(tArgs) == 2 then
		distance = tArgs[2]
	-- No distance provided, use cached distance
	else
		distance = readCache()
	end
	for i=1,distance do 
		turtle.digUp()
		turtle.up()
	end
end