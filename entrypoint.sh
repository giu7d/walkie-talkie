#!/bin/sh

# blue=`tput setaf 4`
# green=`tput setaf 2`
# reset=`tput sgr0`

while ! pg_isready -q -h $DB_HOST -p $DB_PORT -U $DB_USERNAME 
do 
    # echo $blue
    echo "[$(date)] Waiting for database to start..." 
    # echo $reset
    sleep 2 
done 

if [[ -z `psql -Atqc "\\list $DB_NAME"` ]]; then 

    # echo $blue
    echo "[$(date)] Database $DB_NAME does not exist. Creating..." 
    # echo $reset
    
    mix ecto.setup 

    # echo $green
    echo "--------------------------" 
    echo "Database $DB_NAME created." 
    echo "--------------------------" 
    # echo $reset
fi 

exec mix phx.server