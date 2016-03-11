# docker-t24-db
This repository gives instructions and provides tools to set-up the database layer of a Temenos T24 stack, using h2 database engine.

It does not provide any Temenos proprietary installation files nor a T24 H2 database.

You'll have to collect the install files yourself to test this. it should be available from your company's file server ;-)

## About
The beauty of Docker is that as soon as you can get hold of a proper image you can very quickly deploy a working container.

Here we're using the image [fxmartin/docker-h2-server](https://hub.docker.com/r/fxmartin/docker-h2-server) but running it with a host directory mounted as data volume where the T24 *.h2.db file is stored. It is that simple!

For convenience there is a *./t24.sh* command for starting (with proper port mappings), stopping, connecting via ssh and launching the h2 console or shell.

*The script assumes that the h2 jar file is available in tools/h2/bin to be able to launch org.h2.tools.Console or org.h2.tools.Shell*

## Usage

A bash script is provided: t24.sh, which allows to manage the container, considering that it won't stop by itself due to supervisor daemon:
* start: to start the container
* stop: to stop the container
* ssh: ssh to the container
* shell: launch a h2 shell locally, which connects to the container -url "jdbc:h2:tcp://$IP:1521/R15MB"
* console: launch the h2 console, which connects to the container -url "jdbc:h2:tcp://$IP:1521/R15MB"

**Run using command:**
```
docker run -d -p 55522:22 -p 55580:80 -p 55581:81 -p 1521:1521 -v $(pwd)/t24-db:/opt/h2-data fxmartin/docker-h2-server
or
t24.sh start db
```

*__Note__: what 5 to 10 seconds after start before connecting otherwise you'll get an error <<Exception in thread "main" org.h2.jdbc.JdbcSQLException: Connection is broken: "java.net.ConnectException: Connection refused:>>*

**Connect via h2 shell:**
```
java -cp tools/h2/bin/h2-1.3.176.jar org.h2.tools.Shell -url "jdbc:h2:tcp://$IP:1521/R15MB;DB_CLOSE_ON_EXIT=FALSE;MODE=Oracle;TRACE_LEVEL_FILE=0;TRACE_LEVEL_SYSTEM_OUT=0;FILE_LOCK=NO;IFEXISTS=TRUE;CACHE_SIZE=8192" -user t24 -password t24
or
t24.sh h2 shell
```

## Screenshots

Image 1 - h2 console

![h2 console](https://raw.github.com/fxmartin/docker-t24-db/master/screenshots/h2-console.png)

Image 1 - h2 shell

![h2 shell](https://raw.github.com/fxmartin/docker-t24-db/master/screenshots/h2-shell.png)

## Disclaimer
*The information in this page is provided “AS IS” with no warranties, and confers no rights.*

*This page does not represent the thoughts, intentions, plans or strategies of my employer. It is solely my opinion.*

*Feel free to challenge me, disagree with me, or tell me I’m completely nuts, but I reserve the right to delete any comment for any reason whatsoever (abusive, profane, rude, or anonymous comments) – so keep it polite, please.*

## What is Temenos T24?
T24 is a core banking system developed and sold by Temenos company. See their [web site](http://www.temenos.com/en/) for more information 
