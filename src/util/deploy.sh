set -e
set -x

MESSAGE=$(git log --format=$'%H\n\n%B' -n 1)

if [ -n "$SUBDIRECTORY" ]
then
    MESSAGE="[$SUBDIRECTORY] $MESSAGE"
fi

git clone git@github.com:aantron/binaries.git $DEPLOY_DIR

# Commit index.html and the generate install scripts in branch gh-pages.
(cd $DEPLOY_DIR && \
    git checkout gh-pages)

rm -rf $DEPLOY_DIR/$SUBDIRECTORY/*
mkdir -p $DEPLOY_DIR/$SUBDIRECTORY
cp src/util/index.html $DEPLOY_DIR/$SUBDIRECTORY/
cp -r $BUILD_DIR/* $DEPLOY_DIR/$SUBDIRECTORY/

(cd $DEPLOY_DIR && \
    git add -A && \
    git commit -m "$MESSAGE" && \
    git push)

# Commit appveyor.yml in branch deploy to trigger a self-test.
(cd $DEPLOY_DIR && \
    git checkout deploy)

cp appveyor.yml $DEPLOY_DIR/
if [ -n "$SUBDIRECTORY" ]
then
    echo $SUBDIRECTORY > $DEPLOY_DIR/subdirectory
else
    echo / > $DEPLOY_DIR/subdirectory
fi

# Make sure git doesn't claim there is "nothing to commit."
date > $DEPLOY_DIR/timestamp

(cd $DEPLOY_DIR && \
    git add -A && \
    git commit -m "$MESSAGE" && \
    git push)
