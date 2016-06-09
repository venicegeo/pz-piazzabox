@ECHO OFF
:MAIN_PAGE
title VeniceGeo Toolkit / Ver: 1.0 / Author: Sonny Saniev
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
echo  LOCAL DEPLOYMENT----         ^|  LOCAL SERVICES----
echo                               ^|
echo    1. Clone/Pull projects     ^|    3. Start vagrant boxes
echo    2. Build projects          ^|    5. Stop vagrant boxes
echo    4. Start Piazza projects   ^|    6. Destroy vagrant boxes
echo                               ^|    7. List vagrant boxes
echo.
echo  *Type help for help
echo ______________________________________________________________

rem echo %username%
set /p Var1=" PLEASE SELECT AN OPTION: "
cls

REM common variables set here
SET PATH=%PATH%;%M2%;
SET BASE_DIR=%CD%;
set PIAZZA=PIAZZA
REM creating required folders.
IF not exist %PIAZZA% (mkdir %PIAZZA%)

if %Var1%==1 (
	start cmd /K "title Cloning piazza repositories & color 0A & echo Cloning piazza repositories... & echo. & cd %PIAZZA% & git clone https://github.com/venicegeo/pz-gateway.git & git clone https://github.com/venicegeo/pz-ingest.git & git clone https://github.com/venicegeo/pz-access.git & git clone https://github.com/venicegeo/pz-jobmanager.git & git clone https://github.com/venicegeo/pz-search-metadata-ingest.git & git clone https://github.com/venicegeo/pz-servicecontroller.git & git clone https://github.com/venicegeo/kafka-devbox.git & echo. & 	cd pz-gateway & echo pz-gateway update & git pull & echo. & cd ../pz-access & echo pz-access update & git pull & echo. & cd ../pz-ingest & echo pz-ingest update & git pull & echo. & cd ../pz-jobmanager & echo pz-jobmanager update & git pull & echo. & cd ../pz-search-metadata-ingest & echo pz-search-metadata-ingest update & git pull & echo. & cd ../pz-servicecontroller & echo pz-servicecontroller update & git pull & echo. & cd ../kafka-devbox & echo kafka-devbox update & git pull & echo. & Choice /M "Keep shell prompt open for debugging? Auto closing in 10 seconds..." /t 10 /D N & (If Errorlevel 2 exit)" 
	
	https://github.com/venicegeo/kafka-devbox.git
)

if %Var1%==2 (
	start cmd /K "title Building piazza projects & color 0A & cd %PIAZZA% & echo =====Building pz-gateway===== & cd pz-gateway & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-access===== & cd ../pz-access & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-ingest===== & cd ../pz-ingest & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-jobmanager===== & cd ../pz-jobmanager & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-search-metadata-ingest===== & cd ../pz-search-metadata-ingest & mvn clean install & echo. & echo. & echo. & echo. & echo =====Building pz-servicecontroller===== & cd ../pz-servicecontroller & mvn clean install & Choice /M "Keep shell prompt open for debugging? Auto closing in 20 seconds..." /t 20 /D N & (If Errorlevel 2 exit)"
)

rem Start all services in local vagrant boxes
if %Var1%==3 (
	start cmd /C "color 0F & echo. & echo ===========Starting jobdb mongoDB instance=========== & cd %PIAZZA%\pz-jobmanager\config & vagrant up jobdb & vagrant status & echo. & echo. & echo. & echo ===========Starting GeoServer=========== & cd ..\..\pz-access\config & vagrant up geoserver & vagrant status & echo. & echo. & echo. & echo ===========Starting PostGIS=========== & cd ..\..\pz-ingest\config & vagrant up postgis & vagrant status & echo. & echo. & echo. & echo ===========Starting ElasticSearch=========== & cd ..\..\pz-search-metadata-ingest\config & vagrant up search & echo. & echo. & echo. & echo ===========Starting Kafka boxes=========== & cd ..\..\kafka-devbox & vagrant up zk & vagrant up ca & vagrant up kafka & vagrant global-status --prune & pause"
)

if %Var1%==4 (
	start cmd /C "title PZ-GATEWAY & color 0F & echo. & cd %PIAZZA% & echo Starting pz-gateway... & cd pz-gateway & mvn spring-boot:run & pause"
	start cmd /C "title PZ-INGEST & color 0F & echo. & cd %PIAZZA% & echo Starting pz-ingest... & cd pz-ingest & mvn spring-boot:run & pause"
	start cmd /C "title PZ-ACCESS & color 0F & echo. & cd %PIAZZA% & echo Starting pz-access... & cd pz-access & mvn spring-boot:run & pause"
	start cmd /C "title PZ-JOBMANAGER & color 0F & echo. & cd %PIAZZA% & echo Starting pz-jobmanager... & cd pz-jobmanager & mvn spring-boot:run & pause"
	start cmd /C "title PZ-SEARCH-METADATA-INGEST & color 0F & echo. & cd %PIAZZA% & echo Starting pz-search-metadata-ingest... & cd pz-search-metadata-ingest & mvn spring-boot:run & pause"
	start cmd /C "title PZ-SERVICECONTROLLER & color 0F & echo. & cd %PIAZZA% & echo Starting pz-servicecontroller... & cd pz-servicecontroller & mvn spring-boot:run & pause"
)

rem Gracefully shutdown of all running vagrant services created by piazza toolkit
if %Var1%==5 (
	start cmd /C "color 0F & echo. & echo ===========Stopping Jobdb MongoDB=========== & cd %PIAZZA%\pz-jobmanager\config & vagrant halt jobdb & vagrant status & echo. & echo. & echo. & echo ===========Stopping GeoServer=========== & cd ..\..\pz-access\config & vagrant halt geoserver & vagrant status & echo. & echo. & echo. & echo ===========Stopping PostGIS=========== & cd ..\..\pz-ingest\config & vagrant halt postgis & vagrant status & echo. & echo. & echo. & echo ===========Stopping ElasticSearch=========== & cd ..\..\pz-search-metadata-ingest\config & vagrant halt search & vagrant status & echo. & echo. & echo. & echo ===========Suspending Kafka Boxes=========== & cd ..\..\kafka-devbox & vagrant suspend kafka & vagrant suspend ca & vagrant suspend zk & vagrant global-status & pause"
)


rem Destroy all vagrant boxes created by piazza toolkit
if %Var1%==6 (
	start cmd /C "color 0F & echo. & echo ===========Destroying jobdb mongoDB instance=========== & cd %PIAZZA%\pz-jobmanager\config & vagrant destroy -f jobdb & vagrant status & echo. & echo. & echo. & echo ===========Destroying GeoServer=========== & cd ..\..\pz-access\config & vagrant destroy -f geoserver & vagrant status & echo. & echo. & echo. & echo ===========Destroying PostGIS=========== & cd ..\..\pz-ingest\config & vagrant destroy -f postgis & vagrant status & echo. & echo. & echo. & echo ===========Destroying ElasticSearch=========== & cd ..\..\pz-search-metadata-ingest\config & vagrant destroy -f search & echo. & echo. & echo. & echo ===========Destroying Kafka boxes=========== & cd ..\..\kafka-devbox & vagrant destroy -f kafka & vagrant destroy -f ca & vagrant destroy -f zk & vagrant global-status & pause"
)

if %Var1%==7 (
	start cmd /C "color 0F & echo. & echo List of local VMs: & vagrant global-status & pause"
)

if %Var1%==help (
	start cmd /C "title Piazza Help & color 0F & echo Vagrant / Maven / Oracle VM VirtualBox must be installed & echo. & pause"
)

else (
	goto MAIN_PAGE
)

goto MAIN_PAGE

endlocal