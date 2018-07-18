apt -y install jq && \
  pip install virtualenv && \
  virtualenv sdk && \
    source sdk/bin/activate && \
    pip install grpcio grpcio-tools && \
    curl -L -O -s https://github.com/libopenstorage/openstorage/archive/master.zip
