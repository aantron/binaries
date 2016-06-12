set -e
set -x

MESSAGE=$(git log --format=$'%H\n\n%B' -n 1)

git clone git@github.com:aantron/binaries.git $DEPLOY_DIR

# Commit index.html and the generate install scripts in branch gh-pages.
(cd $DEPLOY_DIR && \
    git checkout gh-pages)

rm -rf $DEPLOY_DIR/*
cp src/util/index.html $DEPLOY_DIR/
cp -r $BUILD_DIR/* $DEPLOY_DIR/

(cd $DEPLOY_DIR && \
    git add -A && \
    git commit --amend --reset-author -m "$MESSAGE" && \
    git push -f)

# Commit appveyor.yml in branch deploy to trigger a self-test.
(cd $DEPLOY_DIR && \
    git checkout deploy)

cp appveyor.yml $DEPLOY_DIR/

(cd $DEPLOY_DIR && \
    git add -A && \
    git commit --amend --reset-author -m "$MESSAGE" && \
    git push -f)
