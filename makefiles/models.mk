##@ Models

.PHONY: models-download
models-download: ## Download models
	@./scripts/models download

.PHONY: models-link
models-link: ## Link model aliases from .env
	@./scripts/models link

.PHONY: models-list
models-list: ## List available models
	@./scripts/models list

.PHONY: models-chat
models-chat: ## Test chat completion
	@./scripts/models chat

.PHONY: models-audio
models-audio: ## Test audio transcription (AUDIO_FILE=...)
	@./scripts/models audio $(AUDIO_FILE)

.PHONY: models-images
models-images: ## Test image generation
	@./scripts/models images
