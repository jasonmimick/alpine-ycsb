#!/bin/mksh

set -vex

# maor load
function config_workloads
{
    sed -i "s/recordcount=[0-9]*/recordcount=${RECNUM:=1000000}/g" \
        /opt/ycsb-*/workloads/workload*
    sed -i "s/operationcount=[0-9]*/operationcount=${OPNUM:=5000000}/g" \
        /opt/ycsb-*/workloads/workload*
        
    return
}

function load_data
{
    if [[ ! -e /.loaded_data ]]; then

        /opt/ycsb-*/bin/ycsb.sh load "${DBTYPE}" -s -P "workloads/workload${WORKLETTER}" "${DBARGS}" && touch /.loaded_data
    fi

    return
}

# exit message
trap 'echo "\n${progname} has finished\n"' EXIT

echo "Python version: $(python3 --version)"
if [[ -z "${BINDING_SECRET}" ]]; then
  echo "BINDING_SECRET not set, checking for MDB_URL env variable."
  if [[ -z "${MDB_URL}" ]]; then
    echo "MDB_URL not set, unable to continue."
    exit 1
  fi
else
  python3 /connstring-helper.py secret ${NAMESPACE} ${BINDING_SECRET} > /uri
  cat /uri
  MDB_URL=$(cat /uri)
  echo "target db: ${MDB_URL}"
fi

DBARGS="'-p mongodb.url=${MDB_URL}'
# make sure all the params are set and go.
if [[ -z ${DBTYPE} || -z ${WORKLETTER} || -z ${DBARGS} ]]; then
  echo "Missing params! Exiting"
  exit 1
else
  config_workloads
  if [[ ! -z "${ACTION}" ]]; then
    eval ./bin/ycsb "${ACTION}" "${DBTYPE}" -s -P "workloads/workload${WORKLETTER}" "${DBARGS}"
  else
    load_data
    eval ./bin/ycsb run "${DBTYPE}" -s -P "workloads/workload${WORKLETTER}" "${DBARGS}"
  fi
fi
