#!/usr/bin/env bash

die () {
  echo >&2 "$@"
  exit 1
}

usage() {
cat << EOF
Usage: $0 --name=<project-name> -[vhd]

-h, --help                  Display help

-n, --name                  Project name

-d, --for-docker            Run bootstrap to run project with Docker

-v, --verbose               Run script in verbose mode. Will print out each step of execution.

EOF
}

docker=0
project_name=""

while getopts n:vhd-: OPT; do
  if [ "$OPT" = "-" ]; then   # long option: reformulate OPT and OPTARG
    OPT="${OPTARG%%=*}"       # extract long option name
    OPTARG="${OPTARG#$OPT}"   # extract long option argument (may be empty)
    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
  fi
  case "$OPT" in
    n|name)
      project_name="$OPTARG"
      ;;
    d|for-docker)
      [ -n $(which docker-compose) ] || die "$OPTARG was specified but docker-compose is not installed. Please install docker-compose to run bootstrap for docker"
      docker=1
      ;;
    h|help)
      usage
      exit 0
      ;;
    v|verbose)
      set -exu
      ;;
    *)
      die "Invalid option: run $0 --help for more information"
      ;;
  esac
done
shift $((OPTIND-1))

if [[ -z $project_name ]]; then
  die "Please specify the project name. Run $0 --help for more information"
fi

# generate a .env from the sample file
cp .env.sample .env

# sed command implementation is different for GNU and macOS
sed_i() {
  if [[ $OSTYPE == 'darwin'* ]]; then
    sed -i '' $@
  else
    sed -i $@
  fi
}

# Export the function to make it available to the find command
export -f sed_i

# Define the file types to search for
file_types=("yml" "yaml" "erb" "rb" "json")

for file_type in "${file_types[@]}"
do
  # Find and replace the string in files of the current type
  find . -name "*.$file_type" -type f -exec bash -c 'sed_i "s|rails_api_base|'"$project_name"'|g" "$0"' {} \;
done

echo "Replacement completed successfully."

# spin up docker services if flag is specified for the setup to take place inside the containers
if [[ $docker -eq 1 ]]; then
  # Update DOCKER_ENABLED variable in .env
  sed_i "s/DOCKER_ENABLED=false/DOCKER_ENABLED=true/g" .env

  # build and spin up containers
  docker-compose up --build --detach
fi

# install ruby gems
bin/setup
