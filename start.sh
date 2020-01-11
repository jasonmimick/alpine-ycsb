#!/bin/bash

set -vex

# build connection string from secret mounted
# as environment variables
python /connstring-helper-env.py > /uri

MDB_URL=$(cat /uri)
echo "target db: ${MDB_URL}"

export YCSB_HOME="/ycsb"

# make sure all the params are set and go.
if [[ -z ${ACTION} ]]; then
  echo "ACTION env not found, default to 'run'"
  ACTION=run
fi

ls -l /work

cd ${YCSB_HOME}
echo "== workload start"
echo "Starting workload/work"
cat /work/workload
echo "== workload end"

./bin/ycsb "${ACTION}" mongodb -s -P /work/workload -p mongodb.url="${MDB_URL}" -p mongodb.upsert="true"
