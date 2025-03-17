  FROM ubuntu:24.04

  RUN apt update && apt upgrade -y
  RUN apt install -y \
      wget \
      g++ \
      make \
      expat \
      libexpat1-dev \
      zlib1g-dev \
      liblz4-dev \
      apache2 \
      vim

  COPY osm-3s_latest.tar.gz /osm-3s_latest.tar.gz
  COPY scripts /scripts
  COPY aero.osm /data.osm

  RUN chmod +x /scripts/*.sh
  # RUN /scripts/configure.sh
  CMD [ "/scripts/configure.sh" ]