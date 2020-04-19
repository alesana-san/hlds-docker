#!/usr/bin/env bash
WRITE_DATA="\xFF\xFF\xFF\xFF\x54\x53\x6F\x75\x72\x63\x65\x20\x45\x6E\x67\x69\x6E\x65\x20\x51\x75\x65\x72\x79\x00"
FILE_NAME=answer.dat
SAVE_PATH=$1
echo -n -e ${WRITE_DATA} | nc -u -q 1 localhost 27015 | grep --text 'cstrike' > ${SAVE_PATH}/${FILE_NAME}
cat "$SAVE_PATH/$FILE_NAME"
# if RESULT is NULL then something is wrong. Either way server is OK
[[ -s "$SAVE_PATH/$FILE_NAME" ]]