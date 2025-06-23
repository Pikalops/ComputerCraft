-- Create /usr if it doesn't exist
if(not(fs.exists("/usr")))
then
	shell.run("mkdir", "/usr")
end

-- Add /usr to path if it's not already there
oldPath = shell.path()
inPath = string.find(oldPath, "/usr")
if(inPath == nil)
then
	shell.setPath(oldPath .. ":/usr")
end

-- Download programs from github
shell.run("deploy", "https://github.com/Pikalops/ComputerCraft")