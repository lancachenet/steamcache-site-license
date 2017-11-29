FROM sigboe/steamcmd:latest
MAINTAINER Jessica Smith <jess@mintopia.net>

USER root
RUN \
	/opt/steamcmd/steamcmd.sh +quit && \
    apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*
EXPOSE \
	3128/tcp \
	27037/tcp \
	27037/udp \
	27036/tcp \
	27036/udp

VOLUME /cache
ENV \
	STEAM_CACHE_SIZE_GB=1000 \
	STEAM_USERNAME= \
	STEAM_PASSWORD= \
	STEAM_GUARD= \
	STEAM_AUTHCODE_URL=
COPY files /opt/steamcmd
RUN \
	mkdir /opt/steamcmd/cache && \
	chown -R root /opt/steamcmd && \
	chmod +x /opt/steamcmd/entrypoint.sh /opt/steamcmd/run.sh

ENTRYPOINT ["/bin/bash", "/opt/steamcmd/entrypoint.sh"]
CMD ["/bin/bash", "/opt/steamcmd/run.sh"]