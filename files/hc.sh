#!/usr/bin/env bash
WRITE_DATA=FFFFFFFF54536F7572636520456E67696E6520517565727900
FILE_NAME=answer.dat
echo $WRITE_DATA | xxd -r -p | nc -u -q 1 localhost 27015 | grep --text 'cstrike' > $HLDS_PATH/$FILE_NAME
# if RESULT is NULL then something is wrong. Either way server is OK
[ -s "$HLDS_PATH/$FILE_NAME" ]