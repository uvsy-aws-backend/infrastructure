#! /bin/bash

export PROFILE=""
export STAGE=""
export REGION=""
export LAMBDA=""
export VERSION=""


while getopts ":p:s:r:l:v:" opt; do
  case $opt in
    p) PROFILE=$OPTARG
    ;;
    s) STAGE=$OPTARG
    ;;
    r) REGION=$OPTARG
    ;;
    l) LAMBDA=$OPTARG
    ;;
    v) VERSION=$OPTARG;
    ;;
    \?) echo "Invalid parameter -$OPTARG" >&2
    ;;
  esac
done

if [ -z "$STAGE" ]; then
      echo "Stage must be defined."
      exit 1
fi

if [ -z "$PROFILE" ]; then
      echo "Profile must be defined."
      exit 1
fi

if [ -z "$REGION" ]; then
      echo "Region must be defined."
      exit 1
fi

if [ -z "$LAMBDA" ]; then
      echo "Lambda project must be defined."
      exit 1
fi

if [ -z "$VERSION" ]; then
      echo "Version must be defined."
      exit 1
fi

printf "\n\n"
echo "Starting remove for [${LAMBDA}]"

# Change to temporary folder from which to build and deploy from
cd tmp || exit

# Clone project
echo "Cloning version [${VERSION}]"
git clone -b "${VERSION}" --single-branch --depth 1 "https://github.com/uvsy-aws-backend/${LAMBDA}.git" &> /dev/null

cd "${LAMBDA}" || echo "No folder ${LAMBDA} found"

# Deploy lambda
serverless remove --stage "${STAGE}" --region "${REGION}" --profile "${PROFILE}"

cd ../../

