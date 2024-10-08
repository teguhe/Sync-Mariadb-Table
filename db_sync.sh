#!/bin/bash

# ----------------------------------------------
#
# Sync Database Table
#
# Author : 
# Teguh Prasetyo (teguhe@gmail.com)
# Chasmim R. Murzid (cidcuid@gmail.com)
#
# Initiated in 2020
#
# ----------------------------------------------

# Remote Database Connection
REMOTE_USER=[remote_user]
REMOTE_PASS=[remote_pass]
REMOTE_HOST=[remote_host]
REMOTE_PORT=[remote_port]
REMOTE_DBNAME=[remote_dbname]
DBTABLE=["table1 table2 table3"]

# Local Database Connection
LOCAL_USER=[local_user]
LOCAL_PASS=[local_pass]
LOCAL_DBNAME=[local_dbname]

# Filename (directory with trailing slash)
SAVETO="/home/sync/"
FILENAME=`date +%Y%m%d%H%M%S`

# Create Directory
mkdir -p ${SAVETO}

# Check Connection
if mysql -u${REMOTE_USER} -p${REMOTE_PASS} -e "use "${REMOTE_DBNAME}; then

	# Start Export from SIMPEG (SQL File Output)
	mysqldump -u${REMOTE_USER} -p${REMOTE_PASS} -h${REMOTE_HOST} --port=${REMOTE_PORT} ${REMOTE_DBNAME} ${DBTABLE} > ${SAVETO}${FILENAME}.sql

	# Import to Local Database
	mysql -u${LOCAL_USER} -p${LOCAL_PASS} ${LOCAL_DBNAME} < ${SAVETO}${FILENAME}.sql
	##mysql -u${LOCAL_USER} -p${LOCAL_PASS} ${LOCAL_DBMASTER} < ${SAVETO}${FILENAME}_MASTER.sql

	# Remove Old SQL File (only keep for last 2 days)
	find ${SAVETO} -type f -mtime +1 -name '*.sql' -execdir rm -- '{}' +

	# Message
	#echo "Sync table completed"
fi
