FROM debian:buster-slim AS base
LABEL maintainer="krow7@ya.ru"

# Setting envs
ENV HLDS_PATH=/home/steam/hlds \
	STEAMCMD_PATH=/home/steam/steamcmd \
	OPTS_PATH=/home/steam/opts \
	STEAM_PATH=/home/steam/Steam

# Installing netcat for selftesting
RUN apt-get update \
    && apt-get install -y \
        lib32gcc1 \
		netcat \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y  \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && useradd -m steam

FROM base AS builder

# Install some stuff
RUN apt-get install -y \
        curl
		
# Switching to steam user
USER steam

# Download steamcmd
RUN mkdir -p $STEAMCMD_PATH \
    && cd $STEAMCMD_PATH \
    && curl -o steamcmd_linux.tar.gz "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
    && tar zxf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz \
    && $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 90 +quit \
	    || $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 70 +quit \
	    || $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 10 +quit \
	    || $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 90 validate +quit \
	    || $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 70 validate +quit \
	    || $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 10 validate +quit \
	    || exit 0 \
    && mkdir -p $HLDS_PATH/cstrike/addons/metamod/dlls \
	&& curl -sqL "http://prdownloads.sourceforge.net/metamod/metamod-1.20-linux.tar.gz?download" | tar -C $HLDS_PATH/cstrike/addons/metamod/dlls -zxvf - \
	&& touch $HLDS_PATH/cstrike/addons/metamod/plugins.ini \
	&& sed -i '/^gamedll_linux/d' $HLDS_PATH/cstrike/liblist.gam \
	&& echo 'gamedll_linux "addons/metamod/dlls/metamod_i386.so"' >> $HLDS_PATH/cstrike/liblist.gam \
    && mkdir -p $HLDS_PATH/cstrike/addons/dproto/dlls \
	&& echo 'linux addons/dproto/dlls/dproto_i386.so' >> $HLDS_PATH/cstrike/addons/metamod/plugins.ini \
    && curl -sqL "http://www.amxmodx.org/release/amxmodx-1.8.2-base-linux.tar.gz" | tar -C $HLDS_PATH/cstrike/ -zxvf - \
	&& curl -sqL "http://www.amxmodx.org/release/amxmodx-1.8.2-cstrike-linux.tar.gz" | tar -C $HLDS_PATH/cstrike/ -zxvf - \
	&& echo 'linux addons/amxmodx/dlls/amxmodx_mm_i386.so' >> $HLDS_PATH/cstrike/addons/metamod/plugins.ini \
    && mkdir -p $HLDS_PATH/cstrike/SAVE \
	&& cp $HLDS_PATH/cstrike/steam_appid.txt $HLDS_PATH/steam_appid.txt \
	&& rm -rf $STEAM_PATH/appcache/httpcache \
	&& rm -rf $STEAM_PATH/depotcache \
	&& rm -rf $STEAM_PATH/logs \
	&& find $HLDS_PATH/valve/maps -name "*.*" -type f -delete \
	&& find $HLDS_PATH/valve/media -name "*.*" -type f -delete \
	&& find $HLDS_PATH/valve/overviews -name "*.*" -type f -delete \
	&& find $HLDS_PATH/valve/sound -name "*.*" -type f -delete \
	&& find $HLDS_PATH/valve/gfx -name "*.*" -type f -delete \
#	find $HLDS_PATH/valve/models -name "*.*" -type f -delete && \
	&& find $HLDS_PATH/ -name "*.dll" -type f -delete \
	&& find $HLDS_PATH/ -name "*_amd64.so" -type f -delete \
	&& find $HLDS_PATH/ -name "*.dylib" -type f -delete \
	&& sed -i 's/exec listip/\/\/exec listip/' $HLDS_PATH/cstrike/server.cfg \
	&& sed -i 's/exec banned/\/\/exec banned/' $HLDS_PATH/cstrike/server.cfg \
	&& mkdir -p $HLDS_PATH/cstrike/logs \
#	find $HLDS_PATH/cstrike/maps -name "*.*" -type f -delete && \
	&& find $HLDS_PATH/cstrike/maps ! -name 'de_dust2.bsp' -type f -exec rm -f {} + \
	&& echo "de_dust2" > $HLDS_PATH/cstrike/mapcycle.txt \
	&& find $HLDS_PATH/cstrike/overviews -name "*.*" -type f -delete \
	&& rm -rf $HLDS_PATH/libSDL2.so \
	&& rm -rf $HLDS_PATH/linux64/steamclient.so \
	&& ln -s $HLDS_PATH /home/steam/.steam/sdk32 \
	&& chown steam:steam /home/steam/.steam/sdk32 \
	&& rm -rf $HLDS_PATH/valve/cl_dlls/client.so \
	&& rm -rf $HLDS_PATH/valve/dlls/hl.so \
	&& rm -rf $HLDS_PATH/valve/dlls/director.so

# Install DProto
COPY --chown=steam:steam files/dproto_i386.so $HLDS_PATH/cstrike/addons/dproto/dlls/dproto_i386.so
COPY --chown=steam:steam files/dproto.cfg $HLDS_PATH/cstrike/dproto.cfg
	
# Start from scratch
FROM base as final

COPY --chown=steam:steam --from=builder $HLDS_PATH $HLDS_PATH
COPY --chown=steam:steam --from=builder /home/steam/.steam /home/steam/.steam
COPY --chown=steam:steam --from=builder $STEAM_PATH $STEAM_PATH
COPY --chown=steam:steam files/start.sh /bin/start.sh
COPY --chown=steam:steam files/hc.sh /bin/hc.sh

USER steam

RUN mkdir -p $OPTS_PATH && \
	chmod 744 /bin/start.sh && \
	chmod 744 /bin/hc.sh

# Sharing a port
EXPOSE 27015/udp

# Setting a default dir
WORKDIR /home/steam

# Adding healthcheck
HEALTHCHECK --interval=1m --start-period=1m \
	CMD /bin/hc.sh "$HLDS_PATH" > /dev/null || exit 1
	
# Setting default command to be executed
CMD /bin/start.sh "$OPTS_PATH" "$HLDS_PATH"