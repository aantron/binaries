BUILD_DIR := _build
DEPLOY_DIR := _deploy

export BUILD_DIR
export DEPLOY_DIR

.PHONY : build
build :
	rm -rf $(BUILD_DIR)
	bash src/util/build.sh

.PHONY : deploy
deploy : build
	rm -rf $(DEPLOY_DIR)
	bash src/util/deploy.sh
