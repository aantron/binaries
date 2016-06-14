set -e

# Generate scripts.
REGEX='.*/([^/]+)/([^/]+)\.([^/.]+)\.([^/.]+)$'

for FILE in $(ls src/install/*/*.*.*)
do
    if [[ ! $FILE =~ $REGEX ]]
    then
        continue
    fi

    PLATFORM=${BASH_REMATCH[1]}
    TITLE=${BASH_REMATCH[2]}
    KIND=${BASH_REMATCH[3]}
    EXTENSION=${BASH_REMATCH[4]}

    OUTPUT_SUBDIRECTORY=$(echo $TITLE | tr '-' '/')
    OUTPUT_FILE="$BUILD_DIR/$PLATFORM/$OUTPUT_SUBDIRECTORY/install.$EXTENSION"
    OUTPUT_DIRECTORY=$(dirname $OUTPUT_FILE)

    case $KIND in
        "in")
            COMMAND="bash src/install/$PLATFORM/template.sh $FILE > $OUTPUT_FILE";;
        "full")
            COMMAND="cp $FILE $OUTPUT_FILE";;
        *)
            continue;;
    esac

    mkdir -p $OUTPUT_DIRECTORY
    echo "$COMMAND"
    eval "$COMMAND"
done

# Generate directory indexes.
for DIRECTORY in $(find $BUILD_DIR/* -type d)
do
    INDEX=$DIRECTORY/index.html
    for ENTRY in $(ls $DIRECTORY)
    do
        if [ -d $DIRECTORY/$ENTRY ]
        then
            LINK=$ENTRY/index.html
        else
            LINK=$ENTRY
        fi
        echo "<a href='$LINK'>$ENTRY</a><br/>" >> $INDEX
    done
done
