FROM debian:12.11-slim AS base

ENV HLDS_PATH=/home/steam/hlds \
	STEAMCMD_PATH=/home/steam/steamcmd \
    OPTS_PATH=/home/steam/opts \
    STEAMCMD_URL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
    REHLDS_URL="https://github.com/rehlds/ReHLDS/releases/download/3.14.0.857/rehlds-bin-3.14.0.857.zip" \
    METAMOD_URL="https://github.com/rehlds/Metamod-R/releases/download/1.3.0.149/metamod-bin-1.3.0.149.zip" \
    REGAMEDLL_URL="https://github.com/rehlds/ReGameDLL_CS/releases/download/5.28.0.756/regamedll-bin-5.28.0.756.zip" \
    REAPI_URL="https://github.com/rehlds/ReAPI/releases/download/5.26.0.338/reapi-bin-5.26.0.338.zip" \ 
    REUNION_URL="https://github.com/rehlds/ReUnion/releases/download/0.2.0.25/reunion-0.2.0.25.zip" \
    AMX_MOD_BASE_URL="http://www.amxmodx.org/release/amxmodx-1.8.2-base-linux.tar.gz" \
    AMX_MOD_CSTRIKE_URL="http://www.amxmodx.org/release/amxmodx-1.8.2-cstrike-linux.tar.gz" \
    # https://github.com/rehlds/ReHLDS/issues/999
    APP_UPDATE_90_OPTIONS="-beta steam_legacy" 

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
        ca-certificates \ 
        netcat-traditional \
        libc6:i386 \ 
        libstdc++6:i386 \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y  \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && useradd -m steam

FROM base AS builder

RUN apt-get install -y \
        curl \ 
        unzip

USER steam

RUN cd ~ \
    # Install SteamCMD with CS server
    && mkdir -p $STEAMCMD_PATH \
    && cd $STEAMCMD_PATH \
    && curl -o steamcmd_linux.tar.gz $STEAMCMD_URL \
    && tar zxf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz \
    && $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 90 $APP_UPDATE_90_OPTIONS +quit \
	&& $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 70 +quit \
	&& $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 10 +quit \
	&& $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 90 $APP_UPDATE_90_OPTIONS validate +quit \
	&& $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 70 validate +quit \
	&& $STEAMCMD_PATH/steamcmd.sh +login anonymous +force_install_dir $HLDS_PATH +app_update 10 validate +quit \
    # Install MetaMod
    && mkdir -p $HLDS_PATH/cstrike/addons/metamod/dlls \
    && curl -L $METAMOD_URL -o metamod.zip \
    && mkdir metamod \
    && unzip metamod.zip -d metamod \
    && rm metamod/addons/metamod/metamod.dll \
    && cp metamod/addons/metamod/* $HLDS_PATH/cstrike/addons/metamod/dlls/ \
    && rm metamod.zip \
    && rm -rf metamod \
	&& touch $HLDS_PATH/cstrike/addons/metamod/plugins.ini \
    # Register MetaMod
	&& sed -i '/^gamedll_linux/d' $HLDS_PATH/cstrike/liblist.gam \
	&& echo 'gamedll_linux "addons/metamod/dlls/metamod_i386.so"' >> $HLDS_PATH/cstrike/liblist.gam \
    # Install ReHLDS
    && curl -L $REHLDS_URL -o rehlds.zip \
    && mkdir rehlds \
    && unzip rehlds.zip -d rehlds \
    && cp -rf rehlds/bin/linux32/* $HLDS_PATH/ \
    && rm rehlds.zip \
    && rm -rf rehlds \
    # Make hlds_linux executable
    && chmod +x $HLDS_PATH/hlds_linux \
    # Install ReGame DLL
    # && curl -L $REGAMEDLL_URL -o regame.zip \
    # && mkdir regame \
    # && unzip regame.zip -d regame \
    # && cp -rf regame/bin/linux32/* $HLDS_PATH/ \
    # && rm regame.zip \
    # && rm -rf regame \
    # Install AMXMOD
    && curl -sqL $AMX_MOD_BASE_URL | tar -C $HLDS_PATH/cstrike/ -zxvf - \
	&& curl -sqL $AMX_MOD_CSTRIKE_URL | tar -C $HLDS_PATH/cstrike/ -zxvf - \
    # Register AMXMOD
	&& echo 'linux addons/amxmodx/dlls/amxmodx_mm_i386.so' >> $HLDS_PATH/cstrike/addons/metamod/plugins.ini \
    # Install ReAPI module
    && curl -L $REAPI_URL -o reapi.zip \
    && mkdir reapi \
    && unzip reapi.zip -d reapi \
    && cp -rf reapi/addons/amxmodx/modules/reapi_amxx_i386.so $HLDS_PATH/cstrike/addons/amxmodx/modules/ \
    && rm reapi.zip \
    && rm -rf reapi \
    # Register ReAPI
    && echo 'reapi' >> $HLDS_PATH/cstrike/addons/amxmodx/configs/modules.ini \
    # Install ReUnion (DProto continuation)
    && curl -L $REUNION_URL -o reunion.zip \
    && mkdir reunion \
    && mkdir $HLDS_PATH/cstrike/addons/reunion \
    && unzip reunion.zip -d reunion \
    && cp -rf reunion/bin/Linux/* $HLDS_PATH/cstrike/addons/reunion \
    # https://github.com/rehlds/ReUnion/issues/1
    && sed -i "s/^SteamIdHashSalt.*/SteamIdHashSalt = $(head -c 10000 /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32)/" reunion/reunion.cfg \ 
    && cp -rf reunion/reunion.cfg $HLDS_PATH/cstrike/ \
    && rm reunion.zip \
    && rm -rf reunion \
    # Register ReUnion
    && echo 'linux addons/reunion/reunion_mm_i386.so' >> $HLDS_PATH/cstrike/addons/metamod/plugins.ini \
    # Cleanups
    && find $HLDS_PATH/valve/maps -name "*.*" -type f -delete \
	&& find $HLDS_PATH/valve/media -name "*.*" -type f -delete \
	&& find $HLDS_PATH/valve/overviews -name "*.*" -type f -delete \
	&& find $HLDS_PATH/valve/sound -name "*.*" -type f -delete \
	&& find $HLDS_PATH/valve/gfx -name "*.*" -type f -delete \
	&& find $HLDS_PATH/ -name "*.dll" -type f -delete \
	&& find $HLDS_PATH/ -name "*_amd64.so" -type f -delete \
	&& find $HLDS_PATH/ -name "*.dylib" -type f -delete \
	&& find $HLDS_PATH/cstrike/maps ! -name 'de_dust2.bsp' -type f -exec rm -f {} + \
	&& find $HLDS_PATH/cstrike/overviews -name "*.*" -type f -delete \
	&& rm -rf $HLDS_PATH/libSDL2.so \
	&& rm -rf $HLDS_PATH/linux64/steamclient.so \
	&& rm -rf $HLDS_PATH/valve/cl_dlls/client.so \
	&& rm -rf $HLDS_PATH/valve/dlls/hl.so \
	&& rm -rf $HLDS_PATH/valve/dlls/director.so \
    # Fixes
    && mkdir -p $HLDS_PATH/cstrike/logs \
	&& echo "de_dust2" > $HLDS_PATH/cstrike/mapcycle.txt \ 
    && mkdir -p $HLDS_PATH/cstrike/SAVE \
	&& cp $HLDS_PATH/cstrike/steam_appid.txt $HLDS_PATH/steam_appid.txt \
	&& sed -i 's/exec listip/\/\/exec listip/' $HLDS_PATH/cstrike/server.cfg \
	&& sed -i 's/exec banned/\/\/exec banned/' $HLDS_PATH/cstrike/server.cfg 

# Start from scratch
FROM base AS final

COPY --chown=steam:steam --from=builder $HLDS_PATH $HLDS_PATH
COPY --chown=steam:steam files/* $HLDS_PATH/

USER steam

RUN mkdir -p $OPTS_PATH \
    # https://developer.valvesoftware.com/wiki/SteamCMD#Unable_to_Locate_a_Running_Instance_of_Steam
    && mkdir -p ~/.steam/sdk32 \
    && ln -s $HLDS_PATH/steamclient.so ~/.steam/sdk32/steamclient.so \
	&& chmod 744 $HLDS_PATH/start.sh \
	&& chmod 744 $HLDS_PATH/hc.sh

# Sharing a port
EXPOSE 27015/udp

# Setting a default dir
WORKDIR $HLDS_PATH

# Adding healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
	CMD ./hc.sh || exit 1
	
# Setting default command to be executed
CMD ["./start.sh"]