# Variables
APP=authorizer
SECRET_NAME := $(APP)-secret
ENV_FILE := dev.env
NAMESPACE := authorizer
OUT_DIR=apps/authorizer/overlays


.PHONY: generate-secret-dev
generate-secret-dev:
	@echo "Generating $(OUTPUT_FILE) from $(ENV_FILE)..."
	kubectl create secret generic $(SECRET_NAME) \
		--from-env-file=$(ENV_FILE) \
		--namespace=$(NAMESPACE)-dev \
		--dry-run=client -o yaml | tee $(OUT_DIR)/dev/secret-dev.yaml > /dev/null
	@echo "Secret $(SECRET_NAME) generated in secret-dev.yaml"

.PHONY: encrypt-secret-dev
encrypt-secret-dev:
	sops -e -i $(OUT_DIR)/dev/secret-dev.yaml
	mv $(OUT_DIR)/dev/secret-dev.yaml \
	   $(OUT_DIR)/dev/secret.enc.yaml