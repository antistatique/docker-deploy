#!/usr/bin/env bash
set -e

scriptDir=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )

USE_CACHE=1

# Options
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
       echo "test.sh - test Dockerfile and scripts"
       echo " "
       echo "test.sh [options]"
       echo " "
       echo "options:"
       echo "-h, --help                show brief help"
       echo "--no-cache"               do not pull image from repository previously to build it
       echo "--clean"                  clean all local tags of the imahe
       exit 0
       ;;
    --no-cache)
      USE_CACHE=0
      ;;
    --clean)
      if [ ! -z "$(docker images | grep antistatique/deploy | tr -s ' ' | cut -d ' ' -f 2 | grep -v '<none>')" ]; then
        docker images | grep antistatique/deploy | tr -s ' ' | cut -d ' ' -f 2 | grep -v '<none>' | xargs -I {} docker rmi antistatique/deploy:{}
      fi
      echo "** images cleanded"
      exit 0
      ;;
  esac
  shift
done

# functions

function tag {
  if [ "$1" = "latest" ]; then
    echo "latest"
  else
    echo "$1"
  fi
}

function pull {
  (
    set +e
    TAG="latest"

    docker pull antistatique/deploy:$TAG || true
  )
}

function build {
  (
    set -e
    TAG=$(tag $1)

    echo "** build"
    docker build .
  )
}

function test {
  (
    set -e
    TAG="latest"

    echo "** test"
    container-structure-test test --image antistatique/deploy:${TAG} --config ${scriptDir}/tests/config.yaml
  )
}

function process {
  tag="latest"

  echo "** test files for antistatique/deploy:$tag"

  # build docker imge if required
  if [ "$USE_CACHE" -gt 0 ]; then
    pull
  fi
  build
  test
}

process
