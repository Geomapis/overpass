#!/bin/bash
OVERPASS_ROOT='/osm-3s_v0.7.62.5'
EXEC_DIR="$OVERPASS_ROOT/bin"
CGI_DIR="$OVERPASS_ROOT/cgi-bin"
DB_DIR='/db'

if [ ! -d $OVERPASS_ROOT ]; then
  tar -xzvf /osm-3s_latest.tar.gz
fi

cd $OVERPASS_ROOT

if [ ! -f '/compile_finished' ]; then
  ./configure --prefix="`pwd`" && \
  make && make install

  chmod 755 $EXEC_DIR/*.sh $CGI_DIR/*

  touch /compile_finished
fi

if [ ! -f '/db_populated' ]; then
  mkdir -p /db
  cat /data.osm | $EXEC_DIR/update_database --db-dir="$DB_DIR" --meta
  chmod 666 $DB_DIR/osm3s_osm_base
  touch /db_populated
fi

a2enmod cgid
service apache2 restart

nohup $EXEC_DIR/dispatcher --osm-base --db-dir="$DB_DIR" --allow-duplicate-queries=yes &

tail -f /dev/null