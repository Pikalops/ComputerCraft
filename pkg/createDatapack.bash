#!/usr/bash

# requires zip installed and on path
if ! command -v zip >/dev/null 2>&1
then
    echo "zip could not be found"
    exit 1
fi

mkdir ./tmp
cd ./tmp
mkdir -p ./data/computercraft/lua/rom/programs
mkdir -p ./data/computercraft/lua/rom/autorun

cp ../dist/* ./data/computercraft/lua/rom/programs
cp ../deploy.lua ./data/computercraft/lua/rom/programs
cp ../autorun.lua ./data/computercraft/lua/rom/autorun
cp ../pack.mcmeta ./

zip -r deploy.zip ./data ./pack.mcmeta
cp ./deploy.zip ..
cd ..
rm -r ./tmp
