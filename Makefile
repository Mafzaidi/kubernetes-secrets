# Variables
APP=authorizer
SECRET_NAME := $(APP)-secret
DEV_ENV_FILE := dev.env
PROD_ENV_FILE := prod.env
NAMESPACE := authorizer
OUT_DIR=apps/authorizer/overlays


.PHONY: generate-secret-dev
generate-secret-dev:
	@echo "Generating $(OUTPUT_FILE) from $(DEV_ENV_FILE)..."
	kubectl create secret generic $(SECRET_NAME) \
		--from-env-file=$(DEV_ENV_FILE) \
		--namespace=$(NAMESPACE)-dev \
		--dry-run=client -o yaml | tee $(OUT_DIR)/dev/secret-dev.yaml > /dev/null
	@echo "Secret $(SECRET_NAME) generated in secret-dev.yaml"

.PHONY: encrypt-secret-dev
encrypt-secret-dev:
	sops -e -i $(OUT_DIR)/dev/secret-dev.yaml
	mv $(OUT_DIR)/dev/secret-dev.yaml \
	   $(OUT_DIR)/dev/secret.enc.yaml

.PHONY: generate-secret-prod
generate-secret-prod:
	@echo "Generating $(OUTPUT_FILE) from $(PROD_ENV_FILE)..."
	kubectl create secret generic $(SECRET_NAME) \
		--from-env-file=$(PROD_ENV_FILE) \
		--namespace=$(NAMESPACE)-production \
		--dry-run=client -o yaml | tee $(OUT_DIR)/production/secret-production.yaml > /dev/null
	@echo "Secret $(SECRET_NAME) generated in secret-production.yaml"

.PHONY: encrypt-secret-prod
encrypt-secret-prod:
	sops -e -i $(OUT_DIR)/production/secret-production.yaml
	mv $(OUT_DIR)/production/secret-production.yaml \
	   $(OUT_DIR)/production/secret.enc.yaml