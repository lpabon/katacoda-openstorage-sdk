VIRTUALENV="sdkenv"

fail() {
  echo "$1"
  exit 1
}

echo "Install packages"
apt -y install jq > /dev/null 2>&1 || fail "Failed to install packages"

echo "Installing python virtual env"
echo "+ Creating virtual environment in ${VIRTUALENV}"
python3 -m venv ${VIRTUALENV} || fail "Failed to create virtualenv"
source ${VIRTUALENV}/bin/activate

echo "+ Installing libopenstorage-openstorage"
pip3 install --user libopenstorage-openstorage || fail "Failed to install grpc libraries"

echo "Done"
