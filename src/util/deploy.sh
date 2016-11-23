set -e
set -x

MESSAGE=$(git log --format=$'%H\n\n%B' -n 1)
MESSAGE=$(echo "$MESSAGE" | sed -e 's/\[skip[^]]*\]//g')

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

touch $DEPLOY_DIR/.nojekyll

(cd $DEPLOY_DIR && \
    git add -A && \
    git commit --allow-empty -m "$MESSAGE" && \
    git push)

# Commit appveyor.yml in branch deploy to trigger a self-test.
(cd $DEPLOY_DIR && \
    git checkout deploy)

cp appveyor.yml $DEPLOY_DIR/
cp src/util/deploy.travis.yml $DEPLOY_DIR/.travis.yml
if [ -n "$SUBDIRECTORY" ]
then
    echo $SUBDIRECTORY > $DEPLOY_DIR/subdirectory
else
    echo / > $DEPLOY_DIR/subdirectory
fi

date > $DEPLOY_DIR/timestamp

(cd $DEPLOY_DIR && \
    git add -A && \
    git commit --allow-empty -m "$MESSAGE" && \
    git push)
