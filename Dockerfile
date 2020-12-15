FROM linuxserver/ddclient:version-v3.9.1
# TO add bash to a minimal image:
#FROM vault:1.1.1 as base
#FROM alpine:3.10
#COPY --from=base / /

#RUN apk add --no-cache bash

## Add dogfish
## This should be set to where the volume mounts to.
#ARG PERSISTANT_DIR=/vault/file
#COPY dogfish/ /usr/share/dogfish
#COPY migrations/ /usr/share/dogfish/shell-migrations
#RUN ln -s /usr/share/dogfish/dogfish /usr/bin/dogfish
#RUN mkdir /var/lib/dogfish 
## Need to do this all together because ultimately, the config folder is a volume, and anything done in there will be lost. 
#RUN mkdir -p ${PERSISTANT_DIR} && touch ${PERSISTANT_DIR}/migrations.log && ln -s ${PERSISTANT_DIR}/migrations.log /var/lib/dogfish/migrations.log 

#
### Set up the CMD as well as the pre and post hooks.
COPY go-init /bin/go-init
COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY exitpoint.sh /usr/bin/exitpoint.sh
#
ENTRYPOINT ["go-init"]
# TODO: Make it so that -verbose will be used if $DEBUG... or $TECHNOCORE_DEBUG is true.
CMD ["-main", "/usr/bin/entrypoint.sh ddclient -foreground -daemon 1 ", "-post", "/usr/bin/exitpoint.sh"]
#
COPY config /defaults
RUN mkdir -p /var/cache/ddclient/