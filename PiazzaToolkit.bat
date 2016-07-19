@ECHO OFF
:MAIN_PAGE
title Piazza Toolkit / Ver: 1.0 / Auth: Sonny.Saniev
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
echo  --LOCAL DEPLOYMENT----       ^|  --LOCAL SERVICES----
echo                               ^|
echo    0. EASY START(~30 mins)    ^|    3. Start vagrant boxes
echo    1. Clone/Pull projects     ^|    5. Stop vagrant boxes
echo    2. Build projects          ^|    6. Destroy vagrant boxes
echo    4. Start Piazza projects   ^|    7. List vagrant boxes
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
	start cmd /C "title Cloning piazza repositories & echo Cloning piazza repositories... & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & git clone https://github.com/venicegeo/pz-gateway.git & git clone https://github.com/venicegeo/pz-ingest.git & git clone https://github.com/venicegeo/pz-access.git & git clone https://github.com/venicegeo/pz-jobmanager.git & git clone https://github.com/venicegeo/pz-search-metadata-ingest.git & git clone https://github.com/venicegeo/pz-servicecontroller.git & git clone https://github.com/venicegeo/kafka-devbox.git & git clone https://github.com/venicegeo/pz-logger.git & git clone https://github.com/venicegeo/pz-uuidgen.git & git clone https://github.com/venicegeo/pz-workflow.git & echo. & cd pz-gateway & echo pz-gateway update & git pull & echo. & cd ../pz-access & echo pz-access update & git pull & echo. & cd ../pz-ingest & echo pz-ingest update & git pull & echo. & cd ../pz-jobmanager & echo pz-jobmanager update & git pull & echo. & cd ../pz-search-metadata-ingest & echo pz-search-metadata-ingest update & git pull & echo. & cd ../pz-servicecontroller & echo pz-servicecontroller update & git pull & echo. & cd ../pz-workflow & echo pz-workflow update & git pull & echo. & cd ../pz-uuidgen & echo pz-uuidgen update & git pull & echo. & cd ../pz-logger & echo pz-logger update & git pull & echo. & cd ../kafka-devbox & echo kafka-devbox update & git pull & echo. & pause" 
)

if %Var1%==2 (
	start cmd /K "title Building piazza projects & cd %LOCAL_PIAZZA_REPO_PATH% & echo =====Building pz-gateway===== & cd pz-gateway & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-access===== & cd ../pz-access & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-ingest===== & cd ../pz-ingest & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-jobmanager===== & cd ../pz-jobmanager & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-search-metadata-ingest===== & cd ../pz-search-metadata-ingest & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-servicecontroller===== & cd ../pz-servicecontroller & mvn clean install & Choice /M "Keep shell prompt open for debugging? Auto closing in 20 seconds..." /t 20 /D N & (If Errorlevel 2 exit)"
)

rem Start all services in local vagrant boxes
if %Var1%==3 (
	start cmd /C "echo. & echo ===========Starting Kafka boxes=========== & cd %LOCAL_PIAZZA_REPO_PATH%\kafka-devbox & vagrant up zk & vagrant up ca & vagrant up kafka & echo ===========Starting jobdb mongoDB instance=========== & cd ..\pz-jobmanager\config & vagrant up jobdb & vagrant status & echo. & echo. & echo. & echo ===========Starting GeoServer=========== & cd ..\..\pz-access\config & vagrant up geoserver & vagrant status & echo. & echo. & echo. & echo ===========Starting PostGIS=========== & cd ..\..\pz-ingest\config & vagrant up postgis & vagrant status & echo. & echo. & echo. & echo ===========Starting ElasticSearch=========== & cd ..\..\pz-search-metadata-ingest\config & vagrant up search & echo. & echo. & echo. & vagrant global-status --prune & pause"

	rem starting GO apps
	start cmd /C "title PZ-LOGGER & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-logger... & cd pz-logger\config & vagrant up & pause"
	
	rem wait couple of seconds before starting the uuidgen, logger needs to be running.
	timeout /t 40

	start cmd /C "title PZ-UUIDGEN & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-uuidgen... & cd pz-uuidgen\config & vagrant up & pause"
	rem wait couple of seconds before starting the workflow, logger and uuidgen needs to be running.
	timeout /t 30
	
	start cmd /C "title PZ-WORKFLOW & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-workflow... & cd pz-workflow\config & vagrant up & pause"	
)

rem Start all piazza projects
if %Var1%==4 (
	start cmd /C "title PZ-GATEWAY & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-gateway... & cd pz-gateway & java -jar target/piazza-gateway-0.1.0.jar --access.prefix=localhost --jobmanager.prefix=localhost --servicecontroller.port=8088 --servicecontroller.prefix=localhost --servicecontroller.protocol=http & pause"
	start cmd /C "title PZ-INGEST & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-ingest... & cd pz-ingest & mvn spring-boot:run & pause"
	start cmd /C "title PZ-ACCESS & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-access... & cd pz-access & mvn spring-boot:run & pause"
	start cmd /C "title PZ-JOBMANAGER & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-jobmanager... & cd pz-jobmanager & mvn spring-boot:run & pause"
	start cmd /C "title PZ-SEARCH-METADATA-INGEST & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-search-metadata-ingest... & cd pz-search-metadata-ingest & mvn spring-boot:run & pause"
	start cmd /C "title PZ-SERVICECONTROLLER & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-servicecontroller... & cd pz-servicecontroller & mvn spring-boot:run & pause"

	rem starting all GO apps in VMs
	start cmd /C "title PZ-LOGGER & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-logger... & cd pz-logger\config & vagrant up & pause"
	
	rem wait couple of seconds before starting the uuidgen, logger needs to be running.
	timeout /t 30

	start cmd /C "title PZ-UUIDGEN & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-uuidgen... & cd pz-uuidgen\config & vagrant up & pause"
	rem wait couple of seconds before starting the workflow, logger and uuidgen needs to be running.
	timeout /t 20
	
	start cmd /C "title PZ-WORKFLOW & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Starting pz-workflow... & cd pz-workflow\config & vagrant up & pause"
)

rem Gracefully shutdown of all running vagrant services created by piazza toolkit
if %Var1%==5 (
	rem stopping kafka / mongodb / geoserver / postgis / elasticsearch
	start cmd /C "echo. & echo ===========Stopping Jobdb MongoDB=========== & cd %LOCAL_PIAZZA_REPO_PATH%\pz-jobmanager\config & vagrant halt jobdb & vagrant status & echo. & echo. & echo. & echo ===========Stopping GeoServer=========== & cd ..\..\pz-access\config & vagrant halt geoserver & vagrant status & echo. & echo. & echo. & echo ===========Stopping PostGIS=========== & cd ..\..\pz-ingest\config & vagrant halt postgis & vagrant status & echo. & echo. & echo. & echo ===========Stopping ElasticSearch=========== & cd ..\..\pz-search-metadata-ingest\config & vagrant halt search & vagrant status & echo. & echo. & echo. & echo ===========Suspending Kafka Boxes=========== & cd ..\..\kafka-devbox & vagrant suspend kafka & vagrant suspend ca & vagrant suspend zk & echo. & vagrant global-status & pause"
	
	rem shutting down GO apps running VMs
	start cmd /C "title PZ-LOGGER & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Stopping pz-logger... & cd pz-logger\config & vagrant halt & vagrant status & pause"
	start cmd /C "title PZ-UUIDGEN & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Stopping pz-uuidgen... & cd pz-uuidgen\config & vagrant halt & vagrant status & pause"
	start cmd /C "title PZ-WORKFLOW & echo. & cd %LOCAL_PIAZZA_REPO_PATH% & echo Stopping pz-workflow... & cd pz-workflow\config & vagrant halt & vagrant status & pause"
)

rem Destroy all vagrant boxes created by piazza toolkit
if %Var1%==6 (
	start cmd /C "echo. & echo ===========Destroying jobdb mongoDB instance=========== & cd %LOCAL_PIAZZA_REPO_PATH%\pz-jobmanager\config & vagrant destroy -f jobdb & vagrant status & echo. & echo. & echo. & echo ===========Destroying GeoServer=========== & cd ..\..\pz-access\config & vagrant destroy -f geoserver & vagrant status & echo. & echo. & echo. & echo ===========Destroying PostGIS=========== & cd ..\..\pz-ingest\config & vagrant destroy -f postgis & vagrant status & echo. & echo. & echo. & echo ===========Destroying ElasticSearch=========== & cd ..\..\pz-search-metadata-ingest\config & vagrant destroy -f search & echo. & echo. & echo. & echo ===========Destroying Kafka boxes=========== & cd ..\..\kafka-devbox & vagrant destroy -f kafka & vagrant destroy -f ca & vagrant destroy -f zk & echo ===========Destroying PZ-Workflow Box=========== & cd ..\pz-workflow\config & vagrant destroy -f workflow & echo ===========Destroying PZ-Uuidgen Box=========== & cd ..\..\pz-uuidgen\config & vagrant destroy -f uuid & echo ===========Destroying PZ-Logger Box=========== & cd ..\..\pz-logger\config & vagrant destroy -f logger & vagrant global-status & pause"
)

if %Var1%==7 (
	start cmd /C "echo. & echo List of local VMs: & vagrant global-status --prune & pause"
)

if %Var1%==0 (
	start cmd /C "echo. & echo UNDER CONSTRUCTION... & echo. & pause"
)

if %Var1%==h (
	start cmd /C "title Piazza Help & echo Following must be installed on the system: & echo ------------------------------------------ & echo Vagrant: https://www.vagrantup.com/ & echo Oracle VM VirtualBox: https://www.virtualbox.org/  & echo Maven 3.3.x: https://maven.apache.org/ & echo Java jdk1.8.x from http://www.oracle.com & echo. & echo. & echo Following environment variables should be set: & echo ---------------------------------------------- & echo vcap.services.pz-blobstore.credentials.access_key_id & echo vcap.services.pz-blobstore.credentials.secret_access_key & echo vcap.services.pz-geoserver.credentials.s3.access_key_id & echo vcap.services.pz-geoserver.credentials.s3.secret_access_key & echo. & echo *You may also set the LOCAL_PIAZZA_REPO_PATH environment variable to point to your preferred local directory containing existing repositories & echo. & pause"
)

else (
	goto MAIN_PAGE
)

goto MAIN_PAGE

endlocal