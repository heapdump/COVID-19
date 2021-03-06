#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'covid19';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb covid19;"
   eval $cmd
fi

psql covid19 -f schema/create_schema.sql

mkdir /tmp/data

cp csse_covid_19_data/csse_covid_19_daily_reports/*.csv /tmp/data

dos2unix /tmp/data/*

for file in /tmp/data/*
do
    sed -i -e '$a\' $file
done

sed -e 's/$/,,/' -i /tmp/data/0[12]-*2020.csv

tail -q -n+2 /tmp/data/*.csv > /tmp/dailies.csv
psql covid19 -f loaders/load_csse_dailies.sql
rm /tmp/dailies.csv
rm /tmp/data/*
rmdir /tmp/data
