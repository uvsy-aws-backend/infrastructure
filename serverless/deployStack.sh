#!/bin/bash

file="deploy.properties"

export PROFILE="uvsy-sls-dev"
export STAGE="dev2"
export REGION="sa-east-1"

while getopts ":p:s:r:" opt; do
  case $opt in
    p) PROFILE=$OPTARG
    ;;
    s) STAGE=$OPTARG
    ;;
    r) REGION=$OPTARG
    ;;
    \?) echo "Invalid parameter -$OPTARG" >&2
    ;;
  esac
done

echo "Deploy stage [$STAGE] at region [$REGION] with profile [$PROFILE]"

if [ -f "$file" ]; then
  chmod +x ./lambda/clone-and-deploy.sh

  echo "Reading $file file."

  mkdir tmp

  deploys=()
  while IFS='=' read -r key value; do
    deploys+=("$key:$value")
  done \
    <"$file"

  for deploy in "${deploys[@]}" ; do
    project="${deploy%%:*}"
    version="${deploy##*:}"

    ./lambda/clone-and-deploy.sh \
      -p "${PROFILE}" \
      -s "${STAGE}" \
      -r "${REGION}" \
      -l "${project}" \
      -v "${version}"
  done

else
  echo "$file not found."
fi

rm -rf tmp
