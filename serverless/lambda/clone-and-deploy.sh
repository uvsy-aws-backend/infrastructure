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

echo "${REGION} ${PROFILE} ${STAGE} ${LAMBDA} ${VERSION}"

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

# Create temporary folder to build and deploy from
cd tmp || exit

# Clone project
#git clone "https://github.com/uvsy-aws-backend/${LAMBDA}.git"
git clone -b "${VERSION}" --single-branch --depth 1 "https://github.com/uvsy-aws-backend/${LAMBDA}.git"

cd "${LAMBDA}" || echo "No folder ${LAMBDA} found"
#git checkout "${VERSION}"

# Build project
./gradlew clean build -x test

# Deploy lambda
serverless deploy --stage "${STAGE}" --region "${REGION}" --profile "${PROFILE}"

cd ../../

