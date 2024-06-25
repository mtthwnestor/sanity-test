UNAME := $(shell uname)
NODE_IMAGE := node:20.11.1
OLLAMA_IMAGE := ollama/ollama:0.1.42
OPEN-WEBUI_IMAGE := ghcr.io/open-webui/open-webui:git-06976c4

node-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --init --rm -it --name sanity-node -w /app -v "$$PWD":/app $(NODE_IMAGE) /bin/bash

sanity-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --init --rm -it --name sanity-env -w /app -v "$$PWD":/app -p 4321:4321 -p 3333:3333 -e SANITY_STUDIO_SERVER_HOSTNAME="0.0.0.0" $(NODE_IMAGE) /bin/bash

ollama:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --gpus=all -d --init -v ollama:/root/.ollama -p 11434:11434 --name ollama $(OLLAMA_IMAGE)
	@docker run -d --init -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data -v ./public:/app/backend/data/docs -e WEBUI_AUTH=false --name open-webui --restart always $(OPEN-WEBUI_IMAGE)

clean-node:
	if test -d "$$PWD/node_modules"; then rm -r "$$PWD/node_modules"; fi

clean:
	make clean-node
