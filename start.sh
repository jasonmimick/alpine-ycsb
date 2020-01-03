#!/bin/bash

set -vex


#/ycsb-*/bin/ycsb.sh load "${DBTYPE}" -s -P "workloads/workload${WORKLETTER}" "${DBARGS}" && touch /.loaded_data

ls -l /

#echo "Python version: $(python --version)"

#export $(cat /test.secrets.env | xargs)
#. /test-connstring-helper-env.sh



python /connstring-helper-env.py > /uri
cat /uri
MDB_URL=$(cat /uri)
echo "target db: ${MDB_URL}"


YCSB_HOME="/ycsb-mongodb-binding-${YCSB_VERSION}"
export YCSB_HOME="/ycsb-mongodb-binding-${YCSB_VERSION}"
DBARGS="-p mongodb.url=${MDB_URL}"
YCSBBIN="/ycsb-mongodb-binding-${YCSB_VERSION}/bin/ycsb"
# make sure all the params are set and go.
if [[ -z ${ACTION} || -z ${DBTYPE} || -z ${WORKLETTER} || -z ${DBARGS} ]]; then
  echo "Missing params! Exiting"
  exit 1
fi

cd /ycsb-mongodb-binding-${YCSB_VERSION}
./bin/ycsb "${ACTION}" "${DBTYPE}" -s -P "workloads/workload${WORKLETTER}" -p mongodb.url="${MDB_URL}"
