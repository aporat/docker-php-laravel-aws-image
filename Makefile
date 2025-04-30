.PHONY: help build

################################################################################
# Configuration
################################################################################

SECRET_ID := api-app

# Pull values from Secrets Manager (assuming the stored SecretString is JSON)
$(eval AWS_REGION      = $(shell aws secretsmanager get-secret-value --secret-id $(SECRET_ID) --query SecretString | jq -r 'fromjson | .AWS_REGION'))
$(eval AWS_ACCOUNT_ID  = $(shell aws secretsmanager get-secret-value --secret-id $(SECRET_ID) --query SecretString | jq -r 'fromjson | .AWS_ACCOUNT_ID'))
$(eval ECR_REPO_NAME  = $(shell aws secretsmanager get-secret-value --secret-id $(SECRET_ID) --query SecretString | jq -r 'fromjson | .ECR_APP_REPO_NAME'))

ECR_BASE_URL := $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
ECR_REPOSITORY_URI := $(ECR_BASE_URL)/$(ECR_REPO_NAME)

################################################################################
# Targets
################################################################################

help: ## Print help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build: ## Build base API container
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_BASE_URL)
	docker build -t $(ECR_REPO_NAME) .