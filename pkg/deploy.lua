local args = {...}
branch = "main"

function usage()
	print("Usage: deploy <github repo URL> [branch]\n")
	print("If branch is omitted, main will be downloaded. Specify master if necessary.\n")
	error()
end

-- Validate command line arguments
if (table.getn(args) < 1) or (table.getn(args) > 2) then
	usage()
elseif (string.find(args[1], "github.com") == nil) then
    usage()
elseif (table.getn(args) == 2) then
    branch = args[2]
end

-- Parse repo URL
repoUrl = args[1]
if (string.sub(repoUrl, -1) == "/") then
    repoUrl = string.sub(repoUrl, 1, -2)
end

-- Get repo name from URL
repoName = string.sub(repoUrl, string.find(repoUrl, "/[^/]*$") + 1)

-- Calculate url of archive for provided repo
archiveName = branch .. ".tar.gz"
archiveUrl = repoUrl .. "/archive/" .. archiveName

-- Calculate name of folder extracted from archive (to copy from and clean up)
folderName = repoName .. "-" .. branch

-- Download and extract archive
shell.run("wget", archiveUrl)
shell.run("tar", "-xzf", archiveName)

-- Get rid of pkg folder, not useful ingame
shell.run("rm", folderName .. "/pkg")

-- Put files in /usr
files = fs.list(folderName)
for i = 1, #files do
    if (fs.exists("/usr/" .. files[i])) then
        fs.delete("/usr/" .. files[i])
    end

    shell.run("move", folderName .. "/" .. files[i], "/usr/")
end

-- Clean up
shell.run("rm", folderName)
shell.run("rm", archiveName)