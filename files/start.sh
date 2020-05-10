#!/usr/bin/env bash
OPTS=$1
HLDS=$2
mkdir -p ${OPTS}/config
mkdir -p ${OPTS}/amxx

if [[ ! -f ${OPTS}/config/mapcycle.txt ]]; then
	mv ${HLDS}/cstrike/mapcycle.txt ${OPTS}/config
fi

if [[ ! -f ${OPTS}/config/motd.txt ]]; then
	mv ${HLDS}/cstrike/motd.txt ${OPTS}/config
fi

if [[ ! -f ${OPTS}/config/listenserver.cfg ]]; then
	mv ${HLDS}/cstrike/listenserver.cfg ${OPTS}/config
fi

if [[ ! -f ${OPTS}/config/server.cfg ]]; then
	mv ${HLDS}/cstrike/server.cfg ${OPTS}/config
fi

if [[ ! -f ${OPTS}/config/plugins.ini ]]; then
	mv ${HLDS}/cstrike/addons/metamod/plugins.ini ${OPTS}/config
fi

if [[ ! -f ${OPTS}/config/dproto.cfg ]]; then
	mv ${HLDS}/cstrike/dproto.cfg ${OPTS}/config
fi

if [[ ! -d ${OPTS}/maps ]]; then
	mv ${HLDS}/cstrike/maps ${OPTS}/
fi

if [[ ! -d ${OPTS}/logs ]]; then
	mv ${HLDS}/cstrike/logs ${OPTS}/
fi

if [[ ! -d ${OPTS}/amxx/configs ]]; then
	mv ${HLDS}/cstrike/addons/amxmodx/configs ${OPTS}/amxx
fi

if [[ ! -d ${OPTS}/amxx/logs ]]; then
	mv ${HLDS}/cstrike/addons/amxmodx/logs ${OPTS}/amxx
fi

if [[ ! -d ${OPTS}/amxx/modules ]]; then
	mv ${HLDS}/cstrike/addons/amxmodx/modules ${OPTS}/amxx
fi

if [[ ! -d ${OPTS}/amxx/plugins ]]; then
	mv ${HLDS}/cstrike/addons/amxmodx/plugins ${OPTS}/amxx
fi

rm -rf ${HLDS}/cstrike/addons/amxmodx/plugins
rm -rf ${HLDS}/cstrike/addons/amxmodx/modules
rm -rf ${HLDS}/cstrike/addons/amxmodx/logs
rm -rf ${HLDS}/cstrike/addons/amxmodx/configs
rm -rf ${HLDS}/cstrike/maps
rm -rf ${HLDS}/cstrike/logs

ln -s ${OPTS}/amxx/plugins ${HLDS}/cstrike/addons/amxmodx/plugins
ln -s ${OPTS}/amxx/modules ${HLDS}/cstrike/addons/amxmodx/modules
ln -s ${OPTS}/amxx/logs ${HLDS}/cstrike/addons/amxmodx/logs
ln -s ${OPTS}/amxx/configs ${HLDS}/cstrike/addons/amxmodx/configs
ln -s ${OPTS}/maps ${HLDS}/cstrike/maps
ln -s ${OPTS}/logs ${HLDS}/cstrike/logs
ln -sf ${OPTS}/config/dproto.cfg ${HLDS}/cstrike/dproto.cfg
ln -sf ${OPTS}/config/plugins.ini ${HLDS}/cstrike/addons/metamod/plugins.ini
ln -sf ${OPTS}/config/server.cfg ${HLDS}/cstrike/server.cfg
ln -sf ${OPTS}/config/listenserver.cfg ${HLDS}/cstrike/listenserver.cfg
ln -sf ${OPTS}/config/motd.txt ${HLDS}/cstrike/motd.txt
ln -sf ${OPTS}/config/mapcycle.txt ${HLDS}/cstrike/mapcycle.txt

cd ${HLDS}/
##./hlds_run -game cstrike +maxplayers 32 +map de_dust2 +hostname "Krow7hosT" -nosteam -nomaster -insecure -port 27015 -dev
./hlds_run -game cstrike +maxplayers 32 +map de_dust2 -port 27015 -dev +log on