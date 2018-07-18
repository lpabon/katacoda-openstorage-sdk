apt -y install jq && \
  pip install virtualenv && \
  virtualenv sdk && \
    source sdk/bin/activate && \
    pip install grpcio grpcio-tools && \
    curl -L -O -s https://github.com/libopenstorage/openstorage/archive/master.zip && \
    unzip master.zip 'openstorage-master/api/client/sdk/python/*' && \
    mv openstorage-master/api/client/sdk/python/* .
