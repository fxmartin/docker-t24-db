#!/usr/bin/env bash
##############################################################################
# Script for building and managing t24 set of images and tools
# Syncordis Copyright 2016
# Author: FX
# Date: 11-mar-2016
# Version: 1.0.0
##############################################################################

SCRIPT=t24.sh
VERSION=1.0.0

IMAGE_H2="fxmartin/docker-h2-server"

ID_H2=`docker ps | grep "$IMAGE_H2" | head -n1 | cut -d " " -f1`
IP=`docker-machine ip docker`

is_running() {
	[ "$ID_H2" ]
}

function displayhelp {
	echo "$SCRIPT, version $VERSION"
	echo
	echo "usage: $0 help"
	echo "usage: $0 build {t24|db|jboss|h2-tools}"
	echo "usage: $0 start {db}"
	echo "usage: $0 stop {db}"
	echo "usage: $0 ssh {db|t24|jboss}"
	echo "usage: $0 h2 {console|shell}"
	echo
	echo " help  : display help"
	echo " build : build the relevant component"
	echo " start : Start the relevant image"
	echo " stop  : Stop the relevant image"
	echo " ssh   : SSH to the relevant image"
	echo " h2    : launch shell or console"
 	exit 0
}

function displayhelp-build {
	echo "$SCRIPT, version $VERSION"
	echo
	echo "usage: $0 build {t24|h2-tools}"
	echo
	echo " t24  : TODO complete"
	echo " h2-tools : build the h2 tools"
 	exit 0
}

function displayhelp-h2 {
	echo "$SCRIPT, version $VERSION"
	echo
	echo "usage: $0 h2 {console|shell}"
	echo
	echo " console  : Launch the h2 console"
	echo " shell    : Launch the h2 shell"
 	exit 0
}

function buildh2tools {
	FILE=tools/h2/bin/
	if [ -f $FILE ];
		then
			echo "h2 tools already deployed"
		else
			# Download the installation package from the official website
			cd ../sources/downloads
			if [ ! -f h2-2014-04-05.zip ];
			then
				wget http://www.h2database.com/h2-2014-04-05.zip
			fi
			# Unzip the archive
			unzip h2-2014-04-05.zip -d ../
			cd ..
			# Copy the jar
			mkdir -p ../docker-t24-db/tools/h2/bin
			cp h2/bin/h2-1.3.176.jar ../docker-t24-db/tools/h2/bin/
			# Clean-up all uncompressed files
			rm -R h2
			echo "h2 tools deployed"
		fi
}

case "$1" in
	help)
		displayhelp
		exit 0;;
 		
	build)
		case "$2" in
			h2-tools)
				buildh2tools
				exit 0;;
			t24)
				echo "Not yet implemented"
				exit 0;;
			jboss)
				echo "Not yet implemented"
				exit 0;;
			db)
				if [ -f data/R15MB.h2.db ];
				then
					echo "h2 tools already deployed"
				else
					mkdir t24-db
					cp sources/R15MB.h2.db t24-db/
					echo "T24 database deployed"
				fi
				exit 0;;
			*)
				displayhelp-build
				exit 1;;
		esac
		exit 0;;
	
	ssh)
		case "$2" in
			db)
				ssh root@$IP -p 55522 -i ~/.ssh/id_rsa_docker
				exit 0;;
			t24)
				echo "Not yet implemented"
				exit 0;;
			jboss)
				echo "Not yet implemented"
				exit 0;;
			*)
				displayhelp
				exit 1;;
		esac
		exit 0;;
		
	start)
		case "$2" in
			db)
				if is_running; then
                	echo "Image '$IMAGE_H2' is already running under Id: '$ID_H2'"
                	exit 1;
                fi
                echo "Starting Docker image: '$IMAGE_H2'"
                docker run -d -p 55522:22 -p 55580:80 -p 55581:81 -p 1521:1521 -v $(pwd)/t24-db:/opt/h2-data $IMAGE_H2
                echo "Docker image: '$IMAGE_H2' started"
				exit 0;;
			t24)
				echo "Not yet implemented"
				exit 0;;
			jboss)
				echo "Not yet implemented"
				exit 0;;
			*)
				displayhelp-build
				exit 1;;
		esac
		exit 0;;
		
	stop)
		case "$2" in
			db)
				if is_running; then
					echo "Stopping Docker image: '$IMAGE_H2' with Id: '$ID_H2'"
	                docker stop "$ID_H2"
					echo "Docker image: '$IMAGE_H2' with Id: '$ID_H2' stopped"

                else
                	echo "Image '$IMAGE_H2' is not running"
                fi
                ;;
			t24)
				echo "Not yet implemented"
				exit 0;;
			jboss)
				echo "Not yet implemented"
				exit 0;;
			*)
				displayhelp-build
				exit 1;;
		esac
		exit 0;;
		
	h2)
		case "$2" in
			console)
				java -cp tools/h2/bin/h2-1.3.176.jar org.h2.tools.Console -url "jdbc:h2:tcp://$IP:1521/R15MB" -user t24 -password t24
				exit 0;;
			shell)
				java -cp tools/h2/bin/h2-1.3.176.jar org.h2.tools.Shell -url "jdbc:h2:tcp://$IP:1521/R15MB;DB_CLOSE_ON_EXIT=FALSE;MODE=Oracle;TRACE_LEVEL_FILE=0;TRACE_LEVEL_SYSTEM_OUT=0;FILE_LOCK=NO;IFEXISTS=TRUE;CACHE_SIZE=8192" -user t24 -password t24
				exit 0;;
			*)
				displayhelp-h2
				exit 1;;
		esac
		exit 0;;
		
	*)
		displayhelp
		exit 1;;
esac