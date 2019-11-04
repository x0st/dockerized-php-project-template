#!/usr/bin/env sh

# parsing arguments and flags
KEYS_FILE=
FORCE_FLAG=0

for ARG in ${@} ; do
    case ${ARG} in
        --force)
            FORCE_FLAG=1;;
        --file=*)
            KEYS_FILE=${ARG//--file=/};;
    esac
done
# finished parsing

if ! $(test -r "${KEYS_FILE}");
then
    echo "The provided file does not exist or is not readable"
    exit
fi

if ! $(consul info > /dev/null);
then
    echo "Couldn't reach Consul"
    exit 1
fi

JSON=$(cat ${KEYS_FILE})
KEYS=$(echo ${JSON} | jq -r 'keys[]')

for KEY in $(cat ${KEYS_FILE} | jq -r 'keys[]')
do
    if [ ${FORCE_FLAG} -eq 0 ];
    then
        consul kv get ${KEY} || \
        consul kv put ${KEY} "$(echo "${JSON}" | jq -r ".[\"${KEY}\"]")"
    else
        consul kv put ${KEY} "$(echo "${JSON}" | jq -r ".[\"${KEY}\"]")"
    fi
done