@ECHO OFF
:MAIN_PAGE
title Piazza Toolkit
rem Auth: Sonny Saniev
rem Desc: Toolkit to manage piazza locally.
mode con:cols=64 lines=20
color 0A
cls
echo ::::::::: :::::::::     :::     ::::::::: ::::::::     :::     
echo :+:    :+:   :+:      :+: :+:        :+:       :+:   :+: :+:   
echo +:+    +:+   +:+     +:+   +:+      +:+       +:+   +:+   +:+  
echo +#++:++#+    +#+    +#++:++#++:    +#+       +#+   +#++:++#++: 
echo +#+          +#+    +#+     +#+   +#+       +#+    +#+     +#+ 
echo #+#          #+#    #+#     #+#  #+#       #+#     #+#     #+# 
echo ###       ######### ###     ### ########  ######## ###     ### 
echo ==============================================================
echo.
echo    --LOCAL APPS----           ^|    --LOCAL SERVICES----
echo                               ^|
echo    1. Pull projects           ^|    5. Stop services
echo    2. Build projects          ^|    6. Destroy services
echo    3. Start local services    ^|    7. List running services
echo    4. Start Piazza projects   ^|
echo.
echo  *Type h for help
echo ______________________________________________________________

rem echo %username%
set /p Var1=" PLEASE SELECT AN OPTION: "
cls

REM common variables set here
SET PATH=%PATH%;%M2%;
SET BASE_DIR=%CD%;
if "%LOCAL_PIAZZA_REPO_PATH%" == "" (
	set LOCAL_PIAZZA_REPO_PATH=PIAZZA
)

REM creating required folders.
if not exist %LOCAL_PIAZZA_REPO_PATH% (mkdir %LOCAL_PIAZZA_REPO_PATH%)

if %Var1%==1 (
	start cmd /C "title Cloning piazza repositories & echo Cloning piazza repositories... & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & git clone https://github.com/venicegeo/pz-gateway.git & git clone https://github.com/venicegeo/pz-ingest.git & git clone https://github.com/venicegeo/pz-access.git & git clone https://github.com/venicegeo/pz-jobmanager.git & git clone https://github.com/venicegeo/pz-search-metadata-ingest.git & git clone https://github.com/venicegeo/pz-search-query.git & git clone https://github.com/venicegeo/pz-servicecontroller.git & git clone https://github.com/venicegeo/kafka-devbox.git & git clone https://github.com/venicegeo/pz-logger.git & git clone https://github.com/venicegeo/pz-uuidgen.git & git clone https://github.com/venicegeo/pz-workflow.git & git clone https://github.com/venicegeo/pz-jobcommon.git & echo. & cd pz-gateway & echo pz-gateway update & git pull & echo. & cd ../pz-access & echo pz-access update & git pull & echo. & cd ../pz-ingest & echo pz-ingest update & git pull & echo. & cd ../pz-jobmanager & echo pz-jobmanager update & git pull & echo. & cd ../pz-search-metadata-ingest & echo pz-search-metadata-ingest update & git pull & echo. & cd ../pz-search-query & echo pz-search-query update & git pull & cd ../pz-servicecontroller & echo pz-servicecontroller update & git pull & echo. & cd ../pz-workflow & echo pz-workflow update & git pull & echo. & cd ../pz-uuidgen & echo pz-uuidgen update & git pull & echo. & cd ../pz-logger & echo pz-logger update & git pull & echo. & cd ../kafka-devbox & echo kafka-devbox update & git pull & echo. & cd ../pz-jobcommon & echo pz-jobcommon update & git pull &	echo. & pause" 
)

if %Var1%==2 (
	start cmd /C "title Building piazza projects & cd %LOCAL_PIAZZA_REPO_PATH% & echo ==========Building pz-jobcommon========== & cd pz-jobcommon & mvn clean install & echo. & echo. & echo. & echo. & echo. & timeout /t 2 & echo ==========Building pz-gateway========== & cd ../pz-gateway & mvn clean install & echo. & echo. & echo. & echo. & echo. & timeout /t 2 & echo ==========Building pz-access========== & cd ../pz-access & mvn clean install & echo. & echo. & echo. & echo. & echo. & timeout /t 2 & echo ==========Building pz-ingest========== & cd ../pz-ingest & mvn clean install & echo. & echo. & echo. & echo. & echo. & timeout /t 2 & echo ==========Building pz-jobmanager========== & cd ../pz-jobmanager & mvn clean install & echo. & echo. & echo. & echo. & echo. & timeout /t 2 & echo ==========Building pz-search-metadata-ingest========== & cd ../pz-search-metadata-ingest & mvn clean install & echo. & echo. & echo. & echo. & echo. & timeout /t 2 & echo ==========Building pz-search-query========== & cd ../pz-search-query & mvn clean install & echo. & echo. & echo. & echo. & echo. & timeout /t 2 & echo ==========Building pz-servicecontroller========== & cd ../pz-servicecontroller/mainServiceController & mvn clean install & pause"
	rem timer for cmd auto exit>> & Choice /M "Keep shell prompt open for debugging? Auto closing in 20 seconds..." /t 20 /D N & (If Errorlevel 2 exit)
)

rem Start all services in local vagrant boxes
if %Var1%==3 (
	
	rem checking for host updater plugin.
	vagrant plugin list | findstr /m "vagrant-hostsupdater" 
	if %errorlevel%==1 ( 
	echo vagrant-hostsupdater plugin not found, installing... & vagrant plugin install vagrant-hostsupdater
	) 

	start cmd /C "title Starting Piazza Services & echo. & echo ===========Starting ElasticSearch=========== & cd %LOCAL_PIAZZA_REPO_PATH%\pz-search-metadata-ingest\config & vagrant up search & echo. & echo. & echo. & echo ===========Starting Kafka boxes=========== & cd ..\..\kafka-devbox & vagrant up zk & vagrant up ca & vagrant up kafka & echo. & echo. & echo. & echo ===========Starting jobdb mongoDB instance=========== & cd ..\pz-jobmanager\config & vagrant up jobdb & vagrant status & echo. & echo. & echo. & echo ===========Starting GeoServer=========== & cd ..\..\pz-access\config & vagrant up geoserver & vagrant status & echo. & echo. & echo. & echo ===========Starting PostGIS=========== & cd ..\..\pz-ingest\config & vagrant up postgis & vagrant status & echo. & echo. & echo. & echo ===========Starting Logger=========== & cd ..\..\pz-logger\config & vagrant up & vagrant reload & echo. & echo. & echo. & echo ===========Starting pz-uuidgen=========== & cd ..\..\pz-uuidgen\config & vagrant up & vagrant reload & echo. & echo. & echo. & echo ===========Starting pz-workflow=========== & cd ..\..\pz-workflow\config & vagrant up & vagrant reload & vagrant global-status --prune & pause"

	rem starting GO apps
	rem start cmd /C "title PZ-LOGGER & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-logger... & cd pz-logger\config & vagrant up & pause"
	
	rem wait couple of seconds before starting the uuidgen, logger needs to be running.
	rem timeout /t 40

	rem start cmd /C "title PZ-UUIDGEN & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-uuidgen... & cd pz-uuidgen\config & vagrant up & pause"
	rem wait couple of seconds before starting the workflow, logger and uuidgen needs to be running.
	rem timeout /t 30
	
	rem start cmd /C "title PZ-WORKFLOW & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-workflow... & cd pz-workflow\config & vagrant up & pause"	
)

rem Start all piazza projects
if %Var1%==4 (
	start cmd /C "title PZ-GATEWAY & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-gateway... & cd pz-gateway & java -jar target/piazza-gateway-0.1.0.jar --access.prefix=localhost --search.url=localhost:8581 --jobmanager.prefix=localhost --servicecontroller.port=8088 --servicecontroller.prefix=localhost --servicecontroller.protocol=http --logger.url=http://192.168.46.46:14600 --uuid.url=http://192.168.48.48:14800 --workflow.url=http://192.168.50.50:14400 & pause"
	start cmd /C "title PZ-INGEST & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-ingest... & cd pz-ingest & java -jar target/piazza-ingest-0.1.0.jar --logger.url=http://192.168.46.46:14600 --uuid.url=http://192.168.48.48:14800 --workflow.url=http://192.168.50.50:14400 & pause"
 	start cmd /C "title PZ-ACCESS & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-access... & cd pz-access & java -jar target/piazza-access-0.1.0.jar --logger.url=http://192.168.46.46:14600 --uuid.url=http://192.168.48.48:14800 & pause"
 	start cmd /C "title PZ-JOBMANAGER & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-jobmanager... & cd pz-jobmanager & java -jar target/piazza-jobmanager-0.1.0.jar --logger.url=http://192.168.46.46:14600 --uuid.url=http://192.168.48.48:14800 & pause"
 	start cmd /C "title PZ-SEARCH-METADATA-INGEST & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-search-metadata-ingest... & cd pz-search-metadata-ingest & java -jar target/pz-search-metadata-ingest-0.0.1-SNAPSHOT.jar --logger.url=http://192.168.46.46:14600 & pause"
	start cmd /C "title PZ-SEARCH-QUERY & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-search-query... & cd pz-search-query & java -jar target/pz-search-query-0.0.1-SNAPSHOT.jar --logger.url=http://192.168.46.46:14600 & pause"
 	start cmd /C "title PZ-SERVICECONTROLLER & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-servicecontroller... & cd pz-servicecontroller & java -jar mainServiceController/target/piazzaServiceController-1.0.0.BUILD-SNAPSHOT.jar --logger.url=http://192.168.46.46:14600 --uuid.url=http://192.168.48.48:14800 & pause"
)

rem Gracefully shutdown of all running vagrant services created by piazza toolkit
if %Var1%==5 (
	rem stopping kafka / mongodb / geoserver / postgis / elasticsearch / logger / uuidgen / workflow
	start cmd /C "echo. & echo ===========Stopping Jobdb MongoDB=========== & cd %LOCAL_PIAZZA_REPO_PATH%\pz-jobmanager\config & vagrant halt jobdb & vagrant status & echo. & echo. & echo. & echo ===========Stopping GeoServer=========== & cd ..\..\pz-access\config & vagrant halt geoserver & vagrant status & echo. & echo. & echo. & echo ===========Stopping PostGIS=========== & cd ..\..\pz-ingest\config & vagrant halt postgis & vagrant status & echo. & echo. & echo. & echo ===========Stopping ElasticSearch=========== & cd ..\..\pz-search-metadata-ingest\config & vagrant halt search & vagrant status & echo. & echo. & echo. & echo ===========Suspending Kafka Boxes=========== & cd ..\..\kafka-devbox & vagrant suspend kafka & vagrant suspend ca & vagrant suspend zk & echo. & echo. & echo. & echo ===========Stopping Workflow=========== & cd ..\pz-workflow\config & vagrant halt & vagrant status & echo. & echo. & echo. & echo. & echo ===========Stopping UUIDGEN=========== & cd ..\..\pz-uuidgen\config & vagrant halt & vagrant status & echo. & echo. & echo. & echo. & echo ===========Stopping PZ_Logger=========== & cd ..\..\pz-logger\config & vagrant halt & vagrant status & echo. & vagrant global-status & pause"
)

rem Destroy all vagrant boxes created by piazza toolkit
if %Var1%==6 (
	start cmd /C "echo. & echo ===========Destroying jobdb mongoDB instance=========== & cd %LOCAL_PIAZZA_REPO_PATH%\pz-jobmanager\config & vagrant destroy -f jobdb & echo. & echo. & echo. & echo ===========Destroying GeoServer=========== & cd ..\..\pz-access\config & vagrant destroy -f geoserver & echo. & echo. & echo. & echo ===========Destroying PostGIS=========== & cd ..\..\pz-ingest\config & vagrant destroy -f postgis & echo. & echo. & echo. & echo ===========Destroying ElasticSearch=========== & cd ..\..\pz-search-metadata-ingest\config & vagrant destroy -f search & echo. & echo. & echo. & echo ===========Destroying Kafka boxes=========== & cd ..\..\kafka-devbox & vagrant destroy -f kafka & vagrant destroy -f ca & vagrant destroy -f zk & echo. & echo. & echo ===========Destroying PZ-Workflow Box=========== & cd ..\pz-workflow\config & vagrant destroy -f workflow  & echo. & echo. & echo ===========Destroying PZ-Uuidgen Box=========== & cd ..\..\pz-uuidgen\config & vagrant destroy -f uuid  & echo. & echo. & echo ===========Destroying PZ-Logger Box=========== & cd ..\..\pz-logger\config & vagrant destroy -f logger & vagrant global-status & pause"
)

if %Var1%==7 (
	start cmd /C "echo. & echo List of local VMs: & vagrant global-status --prune & pause"
)

if %Var1%==0 (
	start cmd /C "echo. & echo UNDER CONSTRUCTION... & echo. & pause"
)

if %Var1%==h (
	start cmd /C "title Piazza Help & echo Following must be installed on the system: & echo ------------------------------------------ & echo -Vagrant: https://www.vagrantup.com/ & echo -Oracle VM VirtualBox 5.0.10: https://www.virtualbox.org/ & echo -Maven 3.3.x: https://maven.apache.org/ & echo -Java jdk1.8.x from http://www.oracle.com & echo. & echo. & echo Following environment variables should be set: & echo ---------------------------------------------- & echo JAVA_HOME Ex: JAVA_HOME=C:\Program Files\Java\jdk1.8.0_101 & echo vcap.services.pz-blobstore.credentials.access_key_id & echo vcap.services.pz-blobstore.credentials.secret_access_key & echo **You may also set the LOCAL_PIAZZA_REPO_PATH environment variable & echo    to point to preferred local directory containing existing repositories & echo. & echo. & echo Piazza Toolkit steps accomplish the following: & echo step 1: Will clone/pull repositories using git to a folder specified in LOCAL_PIAZZA_REPO_PATH environment variable. & echo step 2: Builds all cloned piazza repositories with maven. Maven must be installed and set in PATH. & echo step 3: Starts all required services MongoDB/ElasticSearch/PostGIS/GeoServer/Kafka/Logger/UUIDGEN/Workflow in individual vagrant managed local VMs. & echo step 4: Starts all java piazza apps locally on a new command/terminal window. Console output can be used for debugging purposes. Invididual app can be killed and restarted manually. & echo step 5: Gracefully stops local running service VMs MongoDB/ElasticSearch/PostGIS/GeoServer/Kafka/Logger/UUIDGEN/Workflow. Must be done before shutting down developer machine. & echo step 6: Destroys all local service VMs MongoDB/ElasticSearch/PostGIS/GeoServer/Kafka/Logger/UUIDGEN/Workflow. & echo step 7: Lists and prunes all global vagrant boxes existing on the developers host machine. & pause"
)

else (
	goto MAIN_PAGE
)

goto MAIN_PAGE

endlocal