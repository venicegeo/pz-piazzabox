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
echo LOCAL DEPLOYMENT (1-3)       ^|  LOCAL VAGRANT BOXES (4-6)
echo                              ^|
echo   1. Clone piazza projects   ^|    4. Start vagrant boxes
echo   2. Build projects          ^|    5. Stop vagrant boxes
echo   3. Start Piazza projects   ^|    6. Destroy vagrant boxes
echo.
echo _____________________________________________________________

rem echo %username%
set /p Var1=" PLEASE SELECT AN OPTION: "
cls

REM Set common calls here
SET PATH=%PATH%;%M2%;Oracle\core\liquibase-3.3.2-bin

if %Var1%==1 (
	start cmd /K "color 0A & echo CLONING PIAZZA REPOSITORIES... & git clone https://github.com/venicegeo/pz-gateway.git & git clone https://github.com/venicegeo/pz-ingest.git & git clone https://github.com/venicegeo/pz-access.git & git clone https://github.com/venicegeo/pz-jobmanager.git & git clone https://github.com/venicegeo/pz-search-metadata-ingest.git & git clone https://github.com/venicegeo/pz-servicecontroller.git & Choice /M "Keep shell prompt open for debugging? Auto close in 20 seconds..." /t 20 /D N & (If Errorlevel 2 exit)" 
)

if %Var1%==2 (
	start cmd /K "color 0A & echo. & echo Building pz-access... & cd pz-access & mvn clean install & echo. & echo. & echo. & echo Building pz-gateway... & cd ../pz-gateway & mvn clean install & echo. & echo. & echo. & echo Building pz-ingest... & cd ../pz-ingest & mvn clean install & echo. & echo. & echo. & echo Building pz-jobmanager... & cd ../pz-jobmanager & mvn clean install & echo. & echo. & echo. & echo Building pz-search-metadata-ingest... & cd ../pz-search-metadata-ingest & mvn clean install & echo. & echo. & echo. & echo Building pz-servicecontroller... & cd ../pz-servicecontroller & mvn clean install & Choice /M "Keep shell prompt open for debugging? Auto close in 20 seconds..." /t 20 /D N & (If Errorlevel 2 exit)"
)

if %Var1%==3 (
	start cmd /C "color 0A & echo. & echo Starting pz-gateway... & cd pz-gateway & mvn spring-boot:run"
	start cmd /C "color 0F & echo. & echo Starting pz-ingest... & cd pz-inges & mvn spring-boot:run"
	start cmd /C "color 0F & echo. & echo Starting pz-access... & cd pz-access & mvn spring-boot:run"
	start cmd /C "color 0F & echo. & echo Starting pz-jobmanager... & cd pz-jobmanager & mvn spring-boot:run"
	start cmd /C "color 0F & echo. & echo Starting pz-search-metadata-ingest... & cd pz-search-metadata-ingest & mvn spring-boot:run"
	start cmd /C "color 0F & echo. & echo Starting pz-servicecontroller... & cd pz-servicecontroller & mvn spring-boot:run"
)

else (
	goto MAIN_PAGE
)

goto MAIN_PAGE

endlocal