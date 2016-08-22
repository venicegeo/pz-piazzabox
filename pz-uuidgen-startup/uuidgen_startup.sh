mkdir $LOCAL_PIAZZA_REPO_PATH/pz-uuidgen/appbuild
export GOPATH=$LOCAL_PIAZZA_REPO_PATH/pz-uuidgen/appbuild

export VCAP_SERVICES='{"user-provided": [{"credentials": {"host": "192.168.44.44:9200","hostname": "192.168.44.44","port": "9200"},"label": "user-provided","name": "pz-elasticsearch","syslog_drain_url": "","tags": []},{"credentials": {"host": "localhost:14600","hostname": "localhost","port": "14600"},"label": "user-provided","name": "pz-logger","syslog_drain_url": "","tags": []}]}'

export VCAP_APPLICATION='{"application_id": "fe5dfc8d-e36e-4f21-9223-2ed4f7a984dd","application_name": "pz-uuidgen","application_uris": ["pz-uuidgen.int.geointservices.io","pz-uuidgen-Sprint03-74-g7862a67.int.geointservices.io"],"application_version": "f3905ce7-52f3-4d35-8309-1003963250ca","limits": {"disk": 1024,"fds": 16384,"mem": 512},"name": "pz-uuidgen","space_id": "5f97f401-4277-4a13-bbd9-5e5ff62f21a2","space_name": "int","uris": ["pz-uuidgen.int.geointservices.io","pz-uuidgen-Sprint03-74-g7862a67.int.geointservices.io"],"users": null,"version": "f3905ce7-52f3-4d35-8309-1003963250ca"}'

export PORT=14800

cd $GOPATH

go get github.com/venicegeo/pz-uuidgen
go install github.com/venicegeo/pz-uuidgen


$GOPATH/bin/pz-uuidgen