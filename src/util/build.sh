set -e

REGEX='.*/([^/]+)/([^/]+)\.([^/.]+)\.([^/.]+)$'

for FILE in $(ls src/install/*/*.*.*)
do
    if [[ ! $FILE =~ $REGEX ]]
    then
        continue
    fi

    PLATFORM=${BASH_REMATCH[1]}
    TITLE=${BASH_REMATCH[2]}
    KIND=${BASH_REMATCH[4]}
    EXTENSION=${BASH_REMATCH[3]}

    OUTPUT_SUBDIRECTORY=$(echo $TITLE | tr '-' '/')
    OUTPUT_FILE="$BUILD_DIR/$PLATFORM/$OUTPUT_SUBDIRECTORY/install.$EXTENSION"
    OUTPUT_DIRECTORY=$(dirname $OUTPUT_FILE)

    case $KIND in
        "in")
            COMMAND="bash src/util/cygwin-install-template.sh $FILE > $OUTPUT_FILE";;
        "full")
            COMMAND="cp $FILE $OUTPUT_FILE";;
        *)
            continue;;
    esac

    mkdir -p $OUTPUT_DIRECTORY
    echo "$COMMAND"
    eval "$COMMAND"
done
