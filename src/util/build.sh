set -e

for FILE in $(ls src/install/cygwin/*.in)
do
    BASENAME=$(basename $FILE)
    TITLE=${BASENAME%.*.*}
    SUBDIRECTORY=$(echo $TITLE | tr '-' '/')
    OUTPUT_FILE=$BUILD_DIR/cygwin/$SUBDIRECTORY/install.ps1
    OUTPUT_DIRECTORY=$(dirname $OUTPUT_FILE)

    mkdir -p $OUTPUT_DIRECTORY
    bash src/util/cygwin-install-template.sh $FILE > $OUTPUT_FILE
done
