VIRTUALENV="sdkenv"

fail() {
  echo "$1"
  exit 1
}

echo "Install packages"
echo "+ Updating apt..."
apt update > /dev/null 2>&1 || fail "Failed to update apt"
echo "+ Installing python3..."
apt -y install python3 python3-dev python3-venv jq > /dev/null 2>&1 || fail "Failed to install packages"

echo "Installing python virtual env"
echo "+ Creating virtual environment in ${VIRTUALENV}"
python3 -m venv ${VIRTUALENV} || fail "Failed to create virtualenv"
source ${VIRTUALENV}/bin/activate

echo "+ Installing libopenstorage-openstorage"
pip3 install libopenstorage-openstorage || fail "Failed to install grpc libraries"

echo "Done"
