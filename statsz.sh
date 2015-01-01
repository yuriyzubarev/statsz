#!/usr/bin/env bash

# echo '  _____ _        _       ______'
# echo ' / ____| |      | |     |___  /'
# echo '| (___ | |_ __ _| |_ ___   / / '
# echo ' \___ \| __/ _` | __/ __| / /  '
# echo ' ____) | || (_| | |_\__ \/ /__ '
# echo '|_____/ \__\__,_|\__|___/_____|'
# echo

PROG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATA_DIR=$PROG_DIR/data
mkdir -p $DATA_DIR
LOG=$PROG_DIR/log.txt

info() {
    echo "INFO - " $1 >> $LOG
}

info "Launched at `date`"
info "Using '$DATA_DIR' as data directory"

BUCKET=$1
VALUE=$2
TIMESTAMP=$3
INSTRUCTIONS=$4

info "Bucket: $BUCKET"
info "Value: $VALUE"
info "Timestamp: $TIMESTAMP"
info "Instructions: $INSTRUCTIONS"

RESULT=`mktemp /tmp/XXXXXXXX`

# depending on a linux distro, "date" might require different options
date -r 123 > /dev/null
exit_status=$?
if test $exit_status -eq 0
then
    DATE_PARAMS="-r "
else
    DATE_PARAMS="-d@"
fi

stats() {
    if [ -s $1 ] 
    then
        sort -n $1 | awk -f sns.awk >> $2
    else
        echo "{ \"count\": 0 }" >> $2
    fi
}

last_n() {
    # not maintained for now
    mkdir -p $2
    DATA_FILE=$2/last
    info "Data file: $DATA_FILE"
    touch $DATA_FILE

    echo "Before new value" >> $RESULT
    stats $DATA_FILE $RESULT
    
    echo $3 >> $DATA_FILE
    
    echo "After new value" >> $RESULT
    stats $DATA_FILE $RESULT
}

d7m5() {
    T_DATA_DIR=$2/7d/5m
    mkdir -p $T_DATA_DIR/{1..7}
    T_DATA_DIR=$T_DATA_DIR/`date $DATE_PARAMS$4 +%u`
    info "Data dir : $T_DATA_DIR"
    
    DATA_FILE=$T_DATA_DIR/`date $DATE_PARAMS$(($4-($4%300))) +%H%M`
    info "Data file: $DATA_FILE"
    touch $DATA_FILE

    echo "{ \"before\": " >> $RESULT
    stats $DATA_FILE $RESULT
    echo "," >> $RESULT
    
    echo $3 >> $DATA_FILE
    
    echo " \"after\": " >> $RESULT
    stats $DATA_FILE $RESULT
    echo "}" >> $RESULT
}

case $INSTRUCTIONS in
    last-all)
        info "last-all case is detected"
        last_n 10 $DATA_DIR/$BUCKET $VALUE
        ;;
    d-7_5m) # 7 day ago, precision bucket is 5 min
        info "d-7_5m case is detected"
        d7m5 10 $DATA_DIR/$BUCKET $VALUE $TIMESTAMP
        ;;
    *)
        info "Unknown instruction: $INSTRUCTIONS"
        exit 1
esac

if hash jq 2>/dev/null; then
    cat $RESULT | jq .
else
    cat $RESULT
fi

rm $RESULT
