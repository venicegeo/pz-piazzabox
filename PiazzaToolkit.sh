#!/bin/bash

read -r -d '' WELCOME << EOM
::::::::: :::::::::     :::     ::::::::: ::::::::     :::
:+:    :+:   :+:      :+: :+:        :+:       :+:   :+: :+:
+:+    +:+   +:+     +:+   +:+      +:+       +:+   +:+   +:+
+#++:++#+    +#+    +#++:++#++:    +#+       +#+   +#++:++#++:
+#+          +#+    +#+     +#+   +#+       +#+    +#+     +#+
#+#          #+#    #+#     #+#  #+#       #+#     #+#     #+#
###       ######### ###     ### ########  ######## ###     ###
==============================================================

 --LOCAL DEPLOYMENT----       |  --LOCAL SERVICES----
                              |
   0. EASY START(~30 mins)    |    4. Start vagrant boxes
   1. Clone/Pull projects     |    5. Stop vagrant boxes
   2. Build projects          |    6. Destroy vagrant boxes
   3. Start Piazza projects   |    7. List vagrant boxes

 *Type "h" for help, type "q" to quit
______________________________________________________________
EOM

echo "$WELCOME"

while true
do
        read -r -n 1 input
        case $input in
                0)
                        # TODO
                        #;;
						echo Building piazza projects
						cd $LOCAL_PIAZZA_REPO_PATH
						echo $LOCAL_PIAZZA_REPO_PATH
						echo "$WELCOME"
						;;
                1)
                        echo Cloning piazza repositories!
                        echo
						pwd
                        cd $LOCAL_PIAZZA_REPO_PATH
                        git clone https://github.com/venicegeo/pz-gateway.git
                        git clone https://github.com/venicegeo/pz-ingest.git
                        git clone https://github.com/venicegeo/pz-access.git
                        git clone https://github.com/venicegeo/pz-jobmanager.git
                        git clone https://github.com/venicegeo/pz-search-metadata-ingest.git
                        git clone https://github.com/venicegeo/pz-servicecontroller.git
                        git clone https://github.com/venicegeo/kafka-devbox.git
						git clone https://github.com/venicegeo/pz-logger.git
						git clone https://github.com/venicegeo/pz-uuidgen.git
						git clone https://github.com/venicegeo/pz-workflow.git
						git clone https://github.com/venicegeo/pz-jobcommon.git
                        echo
                        cd pz-gateway
                        echo pz-gateway update
                        git pull
                        echo
                        cd ../pz-access
                        echo pz-access update
                        git pull
                        echo
                        cd ../pz-ingest
                        echo pz-ingest update
                        git pull
                        echo
                        cd ../pz-jobmanager
                        echo pz-jobmanager update
                        git pull
                        echo
                        cd ../pz-search-metadata-ingest
                        echo pz-search-metadata-ingest update
                        git pull
                        echo
                        cd ../pz-servicecontroller
                        echo pz-servicecontroller update
                        git pull
                        echo
                        cd ../kafka-devbox
                        echo kafka-devbox update
                        git pull
                        echo
						cd ../pz-workflow
						echo pz-workflow update
						git pull
						echo
						cd ../pz-uuidgen
						echo pz-uuidgen update
						git pull
						echo
						cd ../pz-logger
						echo pz-logger update
						git pull
						echo
						cd ../pz-jobcommon
						echo pz-jobcommon update
						git pull
						echo
                        echo "$WELCOME"
                        ;;
                2)
                        echo Building piazza projects
                        cd $LOCAL_PIAZZA_REPO_PATH
						echo ==========Building pz-jobcommon==========
						cd pz-jobcommon 
						mvn clean install
						echo
						echo
						echo
						echo
						sleep 2
                        echo ==========Building pz-gateway==========
                        cd pz-gateway
                        mvn clean install
                        echo
                        echo
                        echo
                        echo
						sleep 2
                        echo ==========Building pz-access==========
                        cd ../pz-access
                        mvn clean install
                        echo
                        echo
                        echo
                        echo
						sleep 2
                        echo ==========Building pz-ingest==========
                        cd ../pz-ingest
                        mvn clean install
                        echo
                        echo
                        echo
                        echo
						sleep 2
                        echo ==========Building pz-jobmanager==========
                        cd ../pz-jobmanager
                        mvn clean install
                        echo
                        echo
                        echo
                        echo
						sleep 2
                        echo ==========Building pz-search-metadata-ingest==========
                        cd ../pz-search-metadata-ingest
                        mvn clean install
                        echo
                        echo
                        echo
                        echo
						sleep 2
                        echo ==========Building pz-servicecontroller==========
                        cd ../pz-servicecontroller
                        mvn clean install
                        echo "$WELCOME"
                        ;;
                3)
                        osascript -e "tell app \"Terminal\" to do script \"cd $LOCAL_PIAZZA_REPO_PATH && echo Starting pz-gateway... && cd pz-gateway && java -jar target/piazza-gateway-0.1.0.jar --access.prefix=localhost --jobmanager.prefix=localhost --servicecontroller.port=8088 --servicecontroller.prefix=localhost --servicecontroller.protocol=http\""
                        osascript -e "tell app \"Terminal\" to do script \"cd $LOCAL_PIAZZA_REPO_PATH && echo Starting pz-ingest... && cd pz-ingest && mvn spring-boot:run\""
                        osascript -e "tell app \"Terminal\" to do script \"cd $LOCAL_PIAZZA_REPO_PATH && echo Starting pz-access... && cd pz-access && mvn spring-boot:run\""
                        osascript -e "tell app \"Terminal\" to do script \"cd $LOCAL_PIAZZA_REPO_PATH && echo Starting pz-jobmanager... && cd pz-jobmanager && mvn spring-boot:run\""
                        osascript -e "tell app \"Terminal\" to do script \"cd $LOCAL_PIAZZA_REPO_PATH && echo Starting pz-search-metadata-ingest... && cd pz-search-metadata-ingest && mvn spring-boot:run\""
                        osascript -e "tell app \"Terminal\" to do script \"cd $LOCAL_PIAZZA_REPO_PATH && echo Starting pz-servicecontroller... && cd pz-servicecontroller && mvn spring-boot:run\""
                        echo "$WELCOME"
                        ;;
                4)
                        echo
                        echo ===========Starting jobdb mongoDB instance===========
                        cd $LOCAL_PIAZZA_REPO_PATH/pz-jobmanager/config
                        vagrant up jobdb
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Starting GeoServer===========
                        cd ../../pz-access/config
                        vagrant up geoserver
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Starting PostGIS===========
                        cd ../../pz-ingest/config
                        vagrant up postgis
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Starting ElasticSearch===========
                        cd ../../pz-search-metadata-ingest/config
                        vagrant up search
                        echo
                        echo
                        echo
                        echo ===========Starting Kafka boxes===========
                        cd ../../kafka-devbox
                        vagrant up zk
                        vagrant up ca
                        vagrant up kafka
                        vagrant global-status --prune
                        echo "$WELCOME"
                        ;;
                5)
                        echo
                        echo ===========Stopping Jobdb MongoDB===========
                        cd $LOCAL_PIAZZA_REPO_PATH/pz-jobmanager/config
                        vagrant halt jobdb
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Stopping GeoServer===========
                        cd ../../pz-access/config
                        vagrant halt geoserver
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Stopping PostGIS===========
                        cd ../../pz-ingest/config
                        vagrant halt postgis
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Stopping ElasticSearch===========
                        cd ../../pz-search-metadata-ingest/config
                        vagrant halt search
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Suspending Kafka Boxes===========
                        cd ../../kafka-devbox
                        vagrant suspend kafka
                        vagrant suspend ca
                        vagrant suspend zk
                        vagrant global-status
                        echo "$WELCOME"
                        ;;
                6)
                        echo
                        echo ===========Destroying jobdb mongoDB instance===========
                        cd $LOCAL_PIAZZA_REPO_PATH/pz-jobmanager/config
                        vagrant destroy -f jobdb
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Destroying GeoServer===========
                        cd ../../pz-access/config
                        vagrant destroy -f geoserver
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Destroying PostGIS===========
                        cd ../../pz-ingest/config
                        vagrant destroy -f postgis
                        vagrant status
                        echo
                        echo
                        echo
                        echo ===========Destroying ElasticSearch===========
                        cd ../../pz-search-metadata-ingest/config
                        vagrant destroy -f search
                        echo
                        echo
                        echo
                        echo ===========Destroying Kafka boxes===========
                        cd ../../kafka-devbox
                        vagrant destroy -f kafka
                        vagrant destroy -f ca
                        vagrant destroy -f zk
                        vagrant global-status
                        echo "$WELCOME"
                        ;;
                7)
                        echo
                        echo List of local VMs:
                        vagrant global-status
                        echo "$WELCOME"
                        ;;
                h)
						echo Following must be installed on the system: 
						echo ------------------------------------------ 
						echo -Vagrant: https://www.vagrantup.com/ 
						echo -Oracle VM VirtualBox 5.0.10: https://www.virtualbox.org/ 
						echo -Maven 3.3.x: https://maven.apache.org/ 
						echo -Java jdk1.8.x from http://www.oracle.com 
						echo
						echo
						echo Following environment variables should be set: 
						echo ----------------------------------------------
						echo JAVA_HOME Ex: JAVA_HOME=C:\Program Files\Java\jdk1.8.0_101 
						echo vcap.services.pz-blobstore.credentials.access_key_id
						echo vcap.services.pz-blobstore.credentials.secret_access_key
						echo **You may also set the LOCAL_PIAZZA_REPO_PATH environment variable
						echo    to point to preferred local directory containing existing repositories
						echo	
                        echo "$WELCOME"
                        ;;
                q)
                        exit 0
                        ;;
                *)
                        echo "$WELCOME"
                        ;;
        esac
done
