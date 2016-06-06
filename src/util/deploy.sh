set -e

[ -d .git ] || ( >&2 echo "Run in project root" ; exit 1 )

COMMIT=$(git log | head -n 1 | awk '{print $2}')

DEPLOY_CLONE=scratch/deploy

rm -rf $DEPLOY_CLONE
mkdir -p scratch
git clone git@github.com:aantron/binaries.git $DEPLOY_CLONE

(cd $DEPLOY_CLONE && \
    git checkout gh-pages)
rm -rf $DEPLOY_CLONE/*
cp src/util/index.html $DEPLOY_CLONE/

for FILE in $(ls src/install/cygwin/*.in)
do
    BASENAME=$(basename $FILE)
    TITLE=${BASENAME%.*.*}
    SUBDIRECTORY=$(echo $TITLE | tr '-' '/')
    OUTPUT_FILE=$DEPLOY_CLONE/cygwin/$SUBDIRECTORY/install.ps1
    OUTPUT_DIRECTORY=$(dirname $OUTPUT_FILE)

    mkdir -p $OUTPUT_DIRECTORY
    bash src/util/cygwin-install-template.sh $FILE > $OUTPUT_FILE
done

(cd $DEPLOY_CLONE && \
    git add -A && \
    git commit --amend --reset-author -m $COMMIT && \
    git push -f && \
    git checkout deploy)

cp appveyor.yml $DEPLOY_CLONE/

(cd $DEPLOY_CLONE && \
    git add -A && \
    git commit --amend --reset-author -m $COMMIT && \
    git push -f)
