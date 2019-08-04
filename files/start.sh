#!/usr/bin/env bash
mkdir -p $OPTS_PATH/config
mkdir -p $OPTS_PATH/amxx

if [ ! -f $OPTS_PATH/config/mapcycle.txt ]; then
	mv $HLDS_PATH/cstrike/mapcycle.txt $OPTS_PATH/config
fi

if [ ! -f $OPTS_PATH/config/motd.txt ]; then
	mv $HLDS_PATH/cstrike/motd.txt $OPTS_PATH/config
fi

if [ ! -f $OPTS_PATH/config/listenserver.cfg ]; then
	mv $HLDS_PATH/cstrike/listenserver.cfg $OPTS_PATH/config
fi

if [ ! -f $OPTS_PATH/config/server.cfg ]; then
	mv $HLDS_PATH/cstrike/server.cfg $OPTS_PATH/config
fi

if [ ! -f $OPTS_PATH/config/plugins.ini ]; then
	mv $HLDS_PATH/cstrike/addons/metamod/plugins.ini $OPTS_PATH/config
fi

if [ ! -f $OPTS_PATH/config/dproto.cfg ]; then
	mv $HLDS_PATH/cstrike/dproto.cfg $OPTS_PATH/config
fi

if [ ! -d $OPTS_PATH/maps ]; then
	mv $HLDS_PATH/cstrike/maps $OPTS_PATH/
fi

if [ ! -d $OPTS_PATH/logs ]; then
	mv $HLDS_PATH/cstrike/logs $OPTS_PATH/
fi

if [ ! -d $OPTS_PATH/amxx/configs ]; then
	mv $HLDS_PATH/cstrike/addons/amxmodx/configs $OPTS_PATH/amxx
fi

if [ ! -d $OPTS_PATH/amxx/logs ]; then
	mv $HLDS_PATH/cstrike/addons/amxmodx/logs $OPTS_PATH/amxx
fi

if [ ! -d $OPTS_PATH/amxx/modules ]; then
	mv $HLDS_PATH/cstrike/addons/amxmodx/modules $OPTS_PATH/amxx
fi

if [ ! -d $OPTS_PATH/amxx/plugins ]; then
	mv $HLDS_PATH/cstrike/addons/amxmodx/plugins $OPTS_PATH/amxx
fi

rm -rf $HLDS_PATH/cstrike/addons/amxmodx/plugins
rm -rf $HLDS_PATH/cstrike/addons/amxmodx/modules
rm -rf $HLDS_PATH/cstrike/addons/amxmodx/logs
rm -rf $HLDS_PATH/cstrike/addons/amxmodx/configs
rm -rf $HLDS_PATH/cstrike/maps
rm -rf $HLDS_PATH/cstrike/logs

ln -s $OPTS_PATH/amxx/plugins $HLDS_PATH/cstrike/addons/amxmodx/plugins
ln -s $OPTS_PATH/amxx/modules $HLDS_PATH/cstrike/addons/amxmodx/modules
ln -s $OPTS_PATH/amxx/logs $HLDS_PATH/cstrike/addons/amxmodx/logs
ln -s $OPTS_PATH/amxx/configs $HLDS_PATH/cstrike/addons/amxmodx/configs
ln -s $OPTS_PATH/maps $HLDS_PATH/cstrike/maps
ln -s $OPTS_PATH/logs $HLDS_PATH/cstrike/logs
ln -sf $OPTS_PATH/config/dproto.cfg $HLDS_PATH/cstrike/dproto.cfg
ln -sf $OPTS_PATH/config/plugins.ini $HLDS_PATH/cstrike/addons/metamod/plugins.ini
ln -sf $OPTS_PATH/config/server.cfg $HLDS_PATH/cstrike/server.cfg
ln -sf $OPTS_PATH/config/listenserver.cfg $HLDS_PATH/cstrike/listenserver.cfg
ln -sf $OPTS_PATH/config/motd.txt $HLDS_PATH/cstrike/motd.txt
ln -sf $OPTS_PATH/config/mapcycle.txt $HLDS_PATH/cstrike/mapcycle.txt

cd $HLDS_PATH/
##./hlds_run -game cstrike +maxplayers 32 +map de_dust2 +hostname "Krow7hosT" -nosteam -nomaster -insecure -port 27015 -dev
./hlds_run -game cstrike +maxplayers 32 +map de_dust2 -port 27015 -dev +log on