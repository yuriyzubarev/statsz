#!/usr/bin/env bash

echo '  _____ _        _       ______'
echo ' / ____| |      | |     |___  /'
echo '| (___ | |_ __ _| |_ ___   / / '
echo ' \___ \| __/ _` | __/ __| / /  '
echo ' ____) | || (_| | |_\__ \/ /__ '
echo '|_____/ \__\__,_|\__|___/_____|'
echo

info() {
    echo "INFO - " $1
}

DATA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATA_DIR=$DATA_DIR/data
mkdir -p $DATA_DIR
info "Using '$DATA_DIR' for data files"

BUCKET=$1
VALUE=$2
TIMESTAMP=$3
INSTRUCTIONS=$4

info "Bucket: $BUCKET"
info "Value: $VALUE"
info "Timestamp: $TIMESTAMP"
info "Instructions: $INSTRUCTIONS"

RESULT=`mktemp /tmp/XXXXXXXX`

mean() {
    awk '{mean += $1} END {print "mean = " mean/NR;}' $1 >> $2
}

last_n() {
    mkdir -p $2
    DATA_FILE=$2/last
    touch $DATA_FILE

    echo "Before new value" >> $RESULT
    mean $DATA_FILE $RESULT
    
    echo $3 >> $DATA_FILE
    
    echo "After new value" >> $RESULT
    mean $DATA_FILE $RESULT
}

case $INSTRUCTIONS in
    last-10)
        info "last-10 case is detected"
        last_n 10 $DATA_DIR/$BUCKET $VALUE
        ;;
    *)
        info "Unknown instruction: $INSTRUCTIONS"
        exit 1
esac

cat $RESULT
rm $RESULT
