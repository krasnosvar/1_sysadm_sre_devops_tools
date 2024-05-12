#mount NFS directly to container, without mount on host
#https://stackoverflow.com/questions/45282608/how-to-directly-mount-nfs-share-volume-in-container-using-docker-compose-v3

version: "3.2"

services:
  rsyslog:
    image: jumanjiman/rsyslog
    ports:
      - "514:514"
      - "514:514/udp"
    volumes:
      - type: volume
        source: example
        target: /nfs
        volume:
          nocopy: true
volumes:
  example:
    driver_opts:
      type: "nfs"
      o: "addr=10.40.0.199,nolock,soft,rw"
      device: ":/docker/example"
