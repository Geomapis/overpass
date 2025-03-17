#!/bin/bash
EXEC_DIR='/osm-3s_v0.7.62.5'
DB_DIR='/db'
tar -xzvf /osm-3s_latest.tar.gz
cd $EXEC_DIR

if [ ! -f '/compile_finished' ]; then
  ./configure --prefix="`pwd`" && \
  make && make install

  chmod 755 $EXEC_DIR/bin/*.sh $EXEC_DIR/cgi-bin/*

  touch /compile_finished
fi

if [ ! -f '/db_populated' ]; then
  mkdir -p /db
  cat /data.osm | $EXEC_DIR/bin/update_database --db-dir="$DB_DIR" --meta
  chmod 666 $DB_DIR/osm3s_osm_base
  touch /db_populated
fi

a2enmod cgid
service apache2 restart

nohup $EXEC_DIR/bin/dispatcher --osm-base --db-dir="$DB_DIR" --allow-duplicate-queries=yes &

tail -f /dev/null