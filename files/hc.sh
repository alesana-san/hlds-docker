#!/bin/bash
# Работает на Debian, проверяет UDP-сервер CS 1.6
# Без использования strings

set -o pipefail

WRITE_DATA="\xFF\xFF\xFF\xFF\x54\x53\x6F\x75\x72\x63\x65\x20\x45\x6E\x67\x69\x6E\x65\x20\x51\x75\x65\x72\x79\x00"

# Отправляем пакет и ищем 'cstrike' в бинарном потоке
printf '%b' "$WRITE_DATA" | nc -u -w1 localhost 27015 | grep -q --text 'cstrike'

# Возвращаем код последней команды
exit $?
