# Variables
DOCKER_COMPOSE = docker-compose
NODE = node
NPM = npm

# Default environment
ENV ?= development

# Colors for terminal output
GREEN = \033[0;32m
NC = \033[0m # No Color

.PHONY: help install start stop restart dev test lint lint-fix clean backup seed migrate migrate-undo docker-build docker-up docker-down docker-logs

help: ## Show this help message
	@echo 'Usage:'
	@echo '  make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${GREEN}%-15s${NC} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Development Commands

install: ## Install all dependencies
	@echo "Installing dependencies..."
	$(NPM) run install:all

start: ## Start the application
	@echo "Starting application..."
	$(NPM) start

dev: ## Start the application in development mode
	@echo "Starting application in development mode..."
	$(NPM) run dev

test: ## Run tests
	@echo "Running tests..."
	$(NPM) test

lint: ## Run linter
	@echo "Running linter..."
	$(NPM) run lint

lint-fix: ## Fix linting issues
	@echo "Fixing linting issues..."
	$(NPM) run lint:fix

clean: ## Clean up generated files
	@echo "Cleaning up..."
	rm -rf node_modules
	rm -rf backend/node_modules
	rm -rf coverage
	rm -rf dist
	rm -rf uploads/*
	rm -rf logs/*
	rm -rf backups/*

## Database Commands

seed: ## Seed the database
	@echo "Seeding database..."
	$(NPM) run seed

migrate: ## Run database migrations
	@echo "Running migrations..."
	$(NPM) run db:migrate

migrate-undo: ## Undo last database migration
	@echo "Undoing last migration..."
	$(NPM) run db:migrate:undo

backup: ## Create database backup
	@echo "Creating database backup..."
	docker-compose exec backup /bin/sh /backup.sh

## Docker Commands

docker-build: ## Build Docker images
	@echo "Building Docker images..."
	$(DOCKER_COMPOSE) build

docker-up: ## Start Docker containers
	@echo "Starting Docker containers..."
	$(DOCKER_COMPOSE) up -d

docker-down: ## Stop Docker containers
	@echo "Stopping Docker containers..."
	$(DOCKER_COMPOSE) down

docker-logs: ## View Docker container logs
	@echo "Viewing Docker logs..."
	$(DOCKER_COMPOSE) logs -f

## Environment Setup

setup-dev: ## Setup development environment
	@echo "Setting up development environment..."
	cp backend/.env.example backend/.env
	make install
	make migrate
	make seed

setup-prod: ## Setup production environment
	@echo "Setting up production environment..."
	cp backend/.env.example backend/.env
	make install
	make migrate
	make docker-build
	make docker-up

## Utility Commands

logs: ## View application logs
	@echo "Viewing application logs..."
	tail -f logs/app.log

monitor: ## Monitor application
	@echo "Monitoring application..."
	docker stats

prune: ## Prune Docker resources
	@echo "Pruning Docker resources..."
	docker system prune -f
	docker volume prune -f

## Default target
.DEFAULT_GOAL := help