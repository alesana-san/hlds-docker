mkdir -p /home/steam/opts/config
mkdir -p /home/steam/opts/amxx

if [ ! -f /home/steam/opts/config/mapcycle.txt ]; then
	mv /home/steam/hlds/cstrike/mapcycle.txt /home/steam/opts/config
fi

if [ ! -f /home/steam/opts/config/motd.txt ]; then
	mv /home/steam/hlds/cstrike/motd.txt /home/steam/opts/config
fi

if [ ! -f /home/steam/opts/config/listenserver.cfg ]; then
	mv /home/steam/hlds/cstrike/listenserver.cfg /home/steam/opts/config
fi

if [ ! -f /home/steam/opts/config/server.cfg ]; then
	mv /home/steam/hlds/cstrike/server.cfg /home/steam/opts/config
fi

if [ ! -f /home/steam/opts/config/plugins.ini ]; then
	mv /home/steam/hlds/cstrike/addons/metamod/plugins.ini /home/steam/opts/config
fi

if [ ! -f /home/steam/opts/config/dproto.cfg ]; then
	mv /home/steam/hlds/cstrike/dproto.cfg /home/steam/opts/config
fi

if [ ! -d /home/steam/opts/maps ]; then
	mv /home/steam/hlds/cstrike/maps /home/steam/opts/
fi

if [ ! -d /home/steam/opts/amxx/configs ]; then
	mv /home/steam/hlds/cstrike/addons/amxmodx/configs /home/steam/opts/amxx
fi

if [ ! -d /home/steam/opts/amxx/logs ]; then
	mv /home/steam/hlds/cstrike/addons/amxmodx/logs /home/steam/opts/amxx
fi

if [ ! -d /home/steam/opts/amxx/modules ]; then
	mv /home/steam/hlds/cstrike/addons/amxmodx/modules /home/steam/opts/amxx
fi

if [ ! -d /home/steam/opts/amxx/plugins ]; then
	mv /home/steam/hlds/cstrike/addons/amxmodx/plugins /home/steam/opts/amxx
fi

rm -rf /home/steam/hlds/cstrike/addons/amxmodx/plugins
rm -rf /home/steam/hlds/cstrike/addons/amxmodx/modules
rm -rf /home/steam/hlds/cstrike/addons/amxmodx/logs
rm -rf /home/steam/hlds/cstrike/addons/amxmodx/configs
rm -rf /home/steam/hlds/cstrike/maps

ln -s /home/steam/opts/amxx/plugins /home/steam/hlds/cstrike/addons/amxmodx/plugins
ln -s /home/steam/opts/amxx/modules /home/steam/hlds/cstrike/addons/amxmodx/modules
ln -s /home/steam/opts/amxx/logs /home/steam/hlds/cstrike/addons/amxmodx/logs
ln -s /home/steam/opts/amxx/configs /home/steam/hlds/cstrike/addons/amxmodx/configs
ln -s /home/steam/opts/maps /home/steam/hlds/cstrike/maps
ln -sf /home/steam/opts/config/dproto.cfg /home/steam/hlds/cstrike/dproto.cfg
ln -sf /home/steam/opts/config/plugins.ini /home/steam/hlds/cstrike/addons/metamod/plugins.ini
ln -sf /home/steam/opts/config/server.cfg /home/steam/hlds/cstrike/server.cfg
ln -sf /home/steam/opts/config/listenserver.cfg /home/steam/hlds/cstrike/listenserver.cfg
ln -sf /home/steam/opts/config/motd.txt /home/steam/hlds/cstrike/motd.txt
ln -sf /home/steam/opts/config/mapcycle.txt /home/steam/hlds/cstrike/mapcycle.txt

cd /home/steam/hlds/
##./hlds_run -game cstrike +maxplayers 32 +map de_dust2 +hostname "Krow7hosT" -nosteam -nomaster -insecure -port 27015 -dev
./hlds_run -game cstrike +maxplayers 32 +map de_dust2 -port 27015 -dev