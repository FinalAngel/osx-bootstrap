#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo 'OSX Bootstrap Projects'
echo '----------------------'
echo ''

# define helpers
source_dir='~/.osx-bootstrap'
source $source_dir/core/helpers.sh

# define variables
workspace=~/Sites
current_path=`pwd`
port=8000

# project function
function project() {
	# cancel if no argument is given
	[ -z $1 ] && echo '##### Warning: No project specified, use "project organization/project"' && exit

	array=(${1//\// })
	organization=${array[0]}
	project=${array[1]}
	project_path=$workspace/$project

	cd $workspace

	# clone and setup a testproject
	if [[ ! -d $project_path ]]; then
		echo '##### Cloning Repository'
		git clone git@github.com:$organization/$project.git
		cd $project
	else
		echo '##### Updating Repository'
		cd $project
		git pull
	fi

	# lets figure out what to do
	echo '##### Initializing Project'
	echo '##### '$project

	# project is django-cms
	if [[ $project = 'django-cms' ]]; then
		# activate virtualenv
		[[ ! -d env ]] && virtualenv env
		source env/bin/activate
		# installing requirements
		pip install -r test_requirements/django-1.5.txt
		# python runtestserver.py -p $port -b 0.0.0.0
	fi

	# project is from divio-django-template
	if [[ -f Makefile && -f src/settings.py ]]; then
		# activate virtualenv
		[[ ! -d env ]] && virtualenv env
		source env/bin/activate
		# check if we should init or update project
		[[ ! -f requirements_local.txt ]] && make init
		[[ -f requirements_local.txt ]] && make update
		# make run PORT=$port
	fi

	# project is from divio-flask-template
	if [[ -f Makefile && -f run.py ]]; then
		# activate virtualenv
		[[ ! -d env ]] && virtualenv env
		source env/bin/activate
		# installing requirements
		make update
		# make run
	fi

	# setup database
	# fab dev pg.download
	# bin/django dbshell < /path/
}

if [[ ! $1 = 'all' ]]; then
	project $1
else
	export projects='
		aldryn/aldryn-blog
		aldryn/aldryn-events
		aldryn/aldryn-news
		aldryn/aldryn-people
		
		FinalAngel/classjs
		FinalAngel/classjs-plugins
		
		divio/divio-boilerplate
		divio/divio-flask-template
		divio/divio-django-template
		divio/divio-newsletter
		divio/divio-styleguide

		divio/django-cms
		divio/djangocms-admin-style
		divio/djangocms-grid
		divio/djangocms-style
		divio/djangocms-text-ckeditor
	'
	for project in $projects
	do
		project $project
	done
fi