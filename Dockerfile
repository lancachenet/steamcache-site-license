FROM sigboe/steamcmd:latest
MAINTAINER Jessica Smith <jess@mintopia.net>

RUN /opt/steamcmd/steamcmd.sh +quit
USER root
EXPOSE \
	3128/tcp \
	27037/tcp \
	27037/udp

VOLUME /cache
ENV \
	STEAM_CACHE_SIZE_GB=1000 \
	STEAM_USERNAME= \
	STEAM_PASSWORD= \
	STEAM_GUARD=
COPY files /opt/steamcmd
RUN \
	mkdir /opt/steamcmd/cache && \
	chown -R steam /opt/steamcmd && \
	chmod +x /opt/steamcmd/entrypoint.sh /opt/steamcmd/run.sh

ENTRYPOINT ["/bin/bash", "/opt/steamcmd/entrypoint.sh"]
CMD ["/bin/bash", "/opt/steamcmd/run.sh"]