PROJECT_NAME := unispace-landing
IMAGE_TAG := $(PROJECT_NAME):local-scan

.PHONY: trivy-fs trivy-image trivy-fs-critical trivy-image-critical trivy-all trivy-help

trivy-fs:
	trivy fs --severity CRITICAL,HIGH,MEDIUM --exit-code 0 --format table .

trivy-image:
	docker build -t $(IMAGE_TAG) -f Dockerfile .
	trivy image --severity CRITICAL,HIGH,MEDIUM --exit-code 0 --format table $(IMAGE_TAG)

trivy-fs-critical:
	trivy fs --severity CRITICAL --exit-code 1 --format table .

trivy-image-critical:
	docker build -t $(IMAGE_TAG) -f Dockerfile .
	trivy image --severity CRITICAL --exit-code 1 --format table $(IMAGE_TAG)

trivy-all: trivy-fs trivy-image

trivy-help:
	@echo "Available Trivy scanning targets:"
	@echo "  make trivy-fs             - Scan filesystem dependencies (report only)"
	@echo "  make trivy-image          - Build and scan Docker image (report only)"
	@echo "  make trivy-fs-critical    - Scan filesystem - fail on CRITICAL"
	@echo "  make trivy-image-critical - Build and scan image - fail on CRITICAL"
	@echo "  make trivy-all            - Run both fs and image scans"
