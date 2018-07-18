VIRTUALENV="sdkenv"

echo "Install packages"
apt -y install jq

echo "Installing python virtual env"
pip -q install virtualenv && \
  virtualenv -q ${VIRTUALENV}&& \
    source ${VIRTUALENV}/bin/activate && \
    pip -q install grpcio grpcio-tools && \
    curl -L -O -s https://github.com/libopenstorage/openstorage/archive/master.zip && \
    unzip -q master.zip 'openstorage-master/api/client/sdk/python/*' && \
    mv openstorage-master/api/client/sdk/python/* . && \
    rm -rf openstorage-master master.zip
