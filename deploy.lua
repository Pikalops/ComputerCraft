--pastebin vgKwR9x4
files = {BfXczBtR="elevator.lua", FXzuRwCR="stripMine.lua", SGYbjBfb="deploy.lua", Fyf0WAvF="turtle.lua"}
for pasteCode,fileName in pairs(files) do

    if fs.exists(fileName) then
        fs.delete(fileName)
    end

    shell.run("pastebin", "get", pasteCode, fileName)
end