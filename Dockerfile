# Galaxy - ITSoneWB

FROM bgruening/galaxy-stable:20.05

MAINTAINER ma.tangaro@ibiom.cnr.it

ENV GALAXY_CONFIG_BRAND="ITSONEWB"

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800
# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]
