#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo "OSX Projects 1.0.0"
echo "------------------"
echo ""

workspace=~/Sites
organization='divio'
project='django-cms'
project_path=$workspace/$project

# clone and setup a testproject
git clone git@github.com:$organization/$project.git $workspace/$project

virtualenv $project_path/env

# source $project_path/env/bin/activate && pip install test_requirements/django-1.5.txt
