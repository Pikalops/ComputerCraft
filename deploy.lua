--pastebin vgKwR9x4
files = {BfXczBtR="elevator.lua", sfdXCBH8="stripMine.lua", vgKwR9x4="deploy.lua"}
for pasteCode,fileName in pairs(files) do

    if fs.exists(fileName) then
        fs.delete(fileName)
    end

    shell.execute("pastebin get "..pasteCode.." "..fileName)
end