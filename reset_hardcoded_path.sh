#!/usr/bin/env bash

pathToClean="\/home\/user"
newPath="\/home\/$USER"
#newPath="\/home\/user"
find . -type f -exec sed -i "s/$pathToClean/$newPath/g" {} \;
