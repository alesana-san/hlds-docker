FROM debian:stretch AS base
LABEL maintainer="krow7@ya.ru"

# Setting envs
ENV HLDS_PATH=/home/steam/hlds \
	STEAMCMD_PATH=/home/steam/steamcmd \
	OPTS_PATH=/home/steam/opts \
	STEAM_PATH=/home/steam/Steam

# Install some stuff
RUN apt-get update && apt-get install -y \
        lib32gcc1 \
        curl && \
		apt-get clean autoclean && \
		apt-get autoremove -y && \
		rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
        useradd -m steam
		
# Starting anew
FROM base as builder
		
# Switching to steam user
USER steam

# Download steamcmd
RUN mkdir -p $STEAMCMD_PATH && cd $STEAMCMD_PATH && \
        curl -o steamcmd_linux.tar.gz "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" && \
        tar zxf steamcmd_linux.tar.gz && \
        rm steamcmd_linux.tar.gz

# Install HLDS		
RUN $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 90 +quit || \
	$STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 70 +quit || \
	$STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 10 +quit || \
	$STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 90 validate +quit || \
	$STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 70 validate +quit || \
	$STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 10 validate +quit || exit 0

# Install MetaMod
RUN mkdir -p $HLDS_PATH/cstrike/addons/metamod/dlls && \
	curl -sqL "http://prdownloads.sourceforge.net/metamod/metamod-1.20-linux.tar.gz?download" | tar -C $HLDS_PATH/cstrike/addons/metamod/dlls -zxvf - && \
	touch $HLDS_PATH/cstrike/addons/metamod/plugins.ini && \
	sed -i '/^gamedll_linux/d' $HLDS_PATH/cstrike/liblist.gam && \
	echo 'gamedll_linux "addons/metamod/dlls/metamod_i386.so"' >> $HLDS_PATH/cstrike/liblist.gam

# Install DProto
COPY --chown=steam:steam files/dproto_i386.so $HLDS_PATH/cstrike/addons/dproto/dlls/dproto_i386.so
COPY --chown=steam:steam files/dproto.cfg $HLDS_PATH/cstrike/dproto.cfg
RUN mkdir -p $HLDS_PATH/cstrike/addons/dproto/dlls && \
	echo 'linux addons/dproto/dlls/dproto_i386.so' >> $HLDS_PATH/cstrike/addons/metamod/plugins.ini

# Install AMXMod X
RUN curl -sqL "http://www.amxmodx.org/release/amxmodx-1.8.2-base-linux.tar.gz" | tar -C $HLDS_PATH/cstrike/ -zxvf - && \
	curl -sqL "http://www.amxmodx.org/release/amxmodx-1.8.2-cstrike-linux.tar.gz" | tar -C $HLDS_PATH/cstrike/ -zxvf - && \
	echo 'linux addons/amxmodx/dlls/amxmodx_mm_i386.so' >> $HLDS_PATH/cstrike/addons/metamod/plugins.ini
	
# Aux stuff
RUN mkdir -p $HLDS_PATH/cstrike/SAVE && \
	cp $HLDS_PATH/cstrike/steam_appid.txt $HLDS_PATH/steam_appid.txt && \
	rm -rf $STEAM_PATH/appcache/httpcache && \
	rm -rf $STEAM_PATH/depotcache && \
	rm -rf $STEAM_PATH/logs && \
	find $HLDS_PATH/valve/maps -name "*.*" -type f -delete && \
	find $HLDS_PATH/valve/media -name "*.*" -type f -delete && \
	find $HLDS_PATH/valve/overviews -name "*.*" -type f -delete && \
	find $HLDS_PATH/ -name "*.dll" -type f -delete && \
	find $HLDS_PATH/ -name "*_amd64.so" -type f -delete && \
	find $HLDS_PATH/ -name "*.dylib" -type f -delete
	
# Start from scratch
FROM base as final

# Clean stuff
RUN apt remove -y curl
		
USER steam

# Stealing only usable dirs from previous image
COPY --chown=steam:steam --from=builder $HLDS_PATH $HLDS_PATH
COPY --chown=steam:steam --from=builder /home/steam/.steam /home/steam/.steam
COPY --chown=steam:steam --from=builder $STEAM_PATH $STEAM_PATH
	
# Correct path for steamclient
RUN ln -s $HLDS_PATH /home/steam/.steam/sdk32 && \
	mkdir -p $OPTS_PATH
	
# Final preparations
COPY files/start.sh /bin/start.sh
EXPOSE 27015/udp
WORKDIR /home/steam
#ENTRYPOINT /bin/start.sh