VIRTUALENV="sdkenv"

echo "Install packages"
apt -y install jq > /dev/null 2>&1

echo "Installing python virtual env"
pip -q install virtualenv && \
  virtualenv -q ${VIRTUALENV}&& \
    source ${VIRTUALENV}/bin/activate && \
    pip -q install grpcio grpcio-tools && \
    curl -L -O -s https://github.com/libopenstorage/openstorage-sdk-clients/archive/master.zip && \
    unzip -q master.zip 'openstorage-sdk-clients-master/sdk/python/*' && \
    mv openstorage-sdk-clients-master/sdk/python/* . && \
    rm -rf openstorage-master master.zip Makefile README.md DCO LICENSE

echo "Done"