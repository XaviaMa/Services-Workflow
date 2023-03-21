#!/bin/sh

CONF_PATH=/ci
LOG_PATH=/ci
PAGES_PATH=/pages
PODMAN_EXECUTOR='podman'
SCRIPT_PATH=$(dirname $(realpath $0))

if [ $1 == 0 ]; then
        echo Unspecified, exiting...
        exit 0
fi

DATA=$(cat $LOG_PATH/request.log | head -n $1 | tail -n 1)

if [ "$(echo $DATA | cut -f 1 -d " ")" == "200" ]; then
        JSON="{"${DATA#*\{}
        JSON=$(echo $JSON | rev)
        JSON="}"${JSON#*\}}
        JSON=$(echo $JSON | rev)

        URL=$(echo $JSON | awk -F 'repository' '{print $2}' - | awk -F 'clone_url' '{print $2}' - | cut -f 3 -d "\"" | cut -f 1 -d ".")
        OWNER=$(echo $URL | rev | cut -f 2 -d "/" | rev)
        NAME=$(echo $URL | rev | cut -f 1 -d "/" | rev)

        if ! [ echo $JSON | grep -q 'committer' ]; then # NEEDS EXPANDING
                rm -rf $PAGES_PATH/$OWNER/$NAME
                exit 0
        fi

        COMMITTER=$(echo $JSON | awk -F 'committer' '{print $2}' - | awk -F 'username' '{print $2}' - | cut -f 3 -d "\"")
        if ! cat $CONF_PATH/authorized 2> /dev/null | grep -q $COMMITTER; then
            echo '403 '$COMMITTER' '$URL >> $LOG_PATH/denied.log # Deny unprivileged usernames
            exit 1
        fi

        SECRET_POSITION=$(cat -n $CONF_PATH/authorized | grep $COMMITTER | awk -F ' ' '{print $1}' - )
        SECRET=$(cat $CONF_PATH/secret | head -n $SECRET_POSITION | tail -n 1)
        
        COMMIT=$(echo $JSON | awk -F 'commits' '{print $2}' - | awk -F 'id' '{print $2}' - | cut -f 3 -d "\"")

        
        DOMAIN=$(echo $URL | cut -f 3 -d "/")

        mkdir -p $LOG_PATH/shared/$COMMIT

        echo $SECRET > $LOG_PATH/shared/$COMMIT/secret

        mkdir -p $LOG_PATH/logging/$OWNER/$NAME 2> /dev/null

        exec 3>&1
        exec 2>&1
        $PODMAN_EXECUTOR run --name "$COMMIT" -v /ci/shared/$COMMIT:/data --rm -it -v /ci:/runner ci/container runner $URL $COMMIT $COMMITTER $OWNER $DOMAIN > $LOG_PATH/logging/$OWNER/$NAME/$COMMIT.log

        cp $LOG_PATH/logging/$OWNER/$NAME/$COMMIT.log $LOG_PATH/logging/$OWNER/$NAME/latest.log

        if [ -d $LOG_PATH/shared/$COMMIT/page ]; then
                P=$PAGES_PATH/$OWNER/$NAME
                chown -R root:root $LOG_PATH/shared/$COMMIT/page
                chmod -R +rw $LOG_PATH/shared/$COMMIT/page
                rm -rf $P
                mkdir -p $P
                rm -rf $P
                mv $LOG_PATH/shared/$COMMIT/page $P
        else
                rm -rf $PAGES_PATH/$OWNER/$NAME
        fi

        if [ -f $SCRIPT_PATH/postscript/$OWNER-$NAME.sh ]; then
                sh $SCRIPT_PATH/postscript/$OWNER-$NAME.sh $PAGES_PATH/$OWNER/$NAME /ci/shared/$COMMIT
        fi

        chown -R root:root $LOG_PATH/shared/$COMMIT
        chmod -R 770 $LOG_PATH/shared/$COMMIT
        rm -rf $LOG_PATH/shared/$COMMIT

        exit 0
else
        echo $DATA | cut -f 2 -d " " >> $LOG_PATH/malicious.log # put malicious IP onto the log.
        exit 2
fi
