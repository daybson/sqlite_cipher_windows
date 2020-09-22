#!/bin/bash
if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit
fi
 

echo "Encrypting $1"
echo "ATTACH DATABASE 'encrypted.db' AS encrypted KEY '123456ABC'; SELECT sqlcipher_export('encrypted'); DETACH DATABASE encrypted;" | sqlite3 $1

echo
echo "Copying to project"
#rm C:/databases/original_database.db

cp encrypted.db C:/databases/original_database.db
#rm original_database.db

echo "Done."