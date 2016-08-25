mkdir $LOCAL_PIAZZA_REPO_PATH/pz-workflow/appbuild
export GOPATH=$LOCAL_PIAZZA_REPO_PATH/pz-workflow/appbuild

export VCAP_SERVICES='{"user-provided": [{"credentials": {"host": "192.168.44.44:9200","hostname": "192.168.44.44","port": "9200"},"label": "user-provided","name": "pz-elasticsearch","syslog_drain_url": "","tags": []},{"credentials": {"host": "localhost:14600","hostname": "localhost","port": "14600"},"label": "user-provided","name": "pz-logger","syslog_drain_url": "","tags": []},{"credentials": {"host": "localhost:14800","hostname": "localhost","port": "14800"},"label": "user-provided","name": "pz-uuidgen","syslog_drain_url": "","tags": []}]}'


export PORT=14400

export VCAP_APPLICATION='{"application_id": "14fca253-8087-402e-abf5-8fd40ddda81f","application_name": "pz-workflow","application_uris": ["pz-workflow.int.geointservices.io"],"application_version": "5f0ee99d-252c-4f8d-b241-bc3e22534afc","limits": {"disk": 1024,"fds": 16384,"mem": 512},"name": "pz-workflow","space_id": "d65a0987-df00-4d69-a50b-657e52cb2f8e","space_name": "simulator-stage","uris": ["pz-workflow.int.geointservices.io"],"users": null,"version": "5f0ee99d-252c-4f8d-b241-bc3e22534afc"}'

cd $GOPATH

go get github.com/venicegeo/pz-workflow
go install github.com/venicegeo/pz-workflow

$GOPATH/bin/pz-workflow
