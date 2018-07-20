VIRTUALENV="sdkenv"

fail() {
  echo "$1"
  exit 1
}

echo "Install packages"
apt -y install jq > /dev/null 2>&1 || fail "Failed to install packages"

echo "Installing python virtual env"
echo "+ Installing virtualenv"
pip -q install virtualenv || fail "Failed to install virtualenv"

echo "+ Creating virtual environment in ${VIRTUALENV}"
virtualenv -q ${VIRTUALENV} || fail "Failed to create virtualenv"
source ${VIRTUALENV}/bin/activate

echo "+ Installing grpc libraries in virtual environment"
pip -q install grpcio grpcio-tools || fail "Failed to install grpc libraries"

echo "+ Installing OpenStorage libraries"
curl -L -O -s https://github.com/libopenstorage/openstorage-sdk-clients/archive/master.zip && \
  unzip -q master.zip 'openstorage-sdk-clients-master/sdk/python/*' && \
  mv openstorage-sdk-clients-master/sdk/python/* . && \
  rm -rf openstorage-sdk-clients-master master.zip Makefile README.md DCO LICENSE

echo "Done"