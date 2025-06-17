# https://gist.githubusercontent.com/eduardogspereira/7753bc8d780d07b70668c07afac7ec3b/raw/366224fb0c1eddd1cc8fe28e9dbb80646faca455/s3_janitor.sh
#!/bin/bash

# bash s3_cleaner_bash.sh 'initial-dumps-bucket' 7

# You need to uncomment two lines for the script work.
# Please check the logic before use it.

main () {
    aws s3 ls $BUCKETNAME | grep -v ' PRE ' | grep -v ' 0 ' > data.txt
    UNIXDAYS=$(date -d "$DAYS days ago" +%s)
    while read LINE 
    do
        FILEAGE=$(date -d "$(echo $LINE | awk '{print $1 " " $2}')" +%s)
        if [ $FILEAGE -lt $UNIXDAYS ]
        then
            FILENAME=$(echo $LINE | rev | awk '{print $1}' | rev)
            echo "removing $BUCKETNAME$FILENAME."
            #aws s3 rm $BUCKETNAME$FILENAME
        fi
    done < data.txt
}

BUCKETNAME=$1
if [ -z $BUCKETNAME ]
then
    echo "Insert a valid bucket name."
    exit 1
fi

DAYS=$2
if [ -z $DAYS ]
then
    echo "You need the number of days. Files older than this will be deleted."
    exit 1
fi

main $BUCKETNAME $DAYS
