.PHONY: help install install-dev test lint format clean run run-dev run-prod docker-build docker-up docker-down migrate-up migrate-down

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dependencies
	poetry install --no-interaction --no-ansi

install-dev: ## Install development dependencies
	poetry install --no-interaction --no-ansi --with dev

test: ## Run tests
	ENV_FILE=.env.dev ENVIRONMENT=TESTING poetry run pytest -v --tb=short

test-cov: ## Run tests with coverage
	ENV_FILE=.env.dev ENVIRONMENT=TESTING poetry run pytest --cov=src --cov-report=html --cov-report=term-missing

lint: ## Run linters
	poetry run ruff check .
	poetry run ruff format --check .

format: ## Format code
	poetry run ruff format .
	poetry run ruff check --fix --unsafe-fixes

clean: ## Clean cache and temporary files
	find . -type d -name __pycache__ -exec rm -r {} +
	find . -type d -name "*.egg-info" -exec rm -r {} +
	find . -type d -name ".pytest_cache" -exec rm -r {} +
	find . -type d -name ".ruff_cache" -exec rm -r {} +
	find . -type d -name ".mypy_cache" -exec rm -r {} +
	rm -rf dist/
	rm -rf build/
	rm -rf htmlcov/
	rm -rf .coverage

run: ## Run application (development)
	ENV_FILE=.env.dev poetry run uvicorn src.main:app --reload

run-dev: ## Run application (development)
	ENV_FILE=.env.dev poetry run uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

run-prod: ## Run application (production)
	ENV_FILE=.env.prod poetry run gunicorn src.main:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind=0.0.0.0:8000

docker-build: ## Build Docker image
	docker-compose build

docker-up: ## Start Docker containers
	docker-compose up -d

docker-down: ## Stop Docker containers
	docker-compose down

docker-logs: ## View Docker logs
	docker-compose logs -f

docker-restart: ## Restart Docker containers
	docker-compose restart

migrate-up: ## Run database migrations
	ENV_FILE=.env.dev poetry run alembic upgrade head

migrate-down: ## Rollback database migrations
	ENV_FILE=.env.dev poetry run alembic downgrade -1

migrate-create: ## Create new migration (use MESSAGE="description")
	ENV_FILE=.env.dev poetry run alembic revision --autogenerate -m "$(MESSAGE)"

migrate-history: ## Show migration history
	ENV_FILE=.env.dev poetry run alembic history

migrate-current: ## Show current migration
	ENV_FILE=.env.dev poetry run alembic current

celery-worker: ## Run Celery worker
	ENV_FILE=.env.dev poetry run celery -A src.celery:celery worker --loglevel=info

celery-beat: ## Run Celery beat scheduler
	ENV_FILE=.env.dev poetry run celery -A src.celery:celery beat --loglevel=info

pre-commit: ## Run pre-commit hooks
	poetry run pre-commit run --all-files

pre-commit-install: ## Install pre-commit hooks
	poetry run pre-commit install

security-scan: ## Run security scan
	poetry add --group dev bandit
	poetry run bandit -r src/

deps-update: ## Update dependencies
	poetry update

deps-check: ## Check for outdated dependencies
	poetry show --outdated

shell: ## Open Python shell
	ENV_FILE=.env.dev poetry run python

db-shell: ## Open database shell
	docker-compose exec postgres psql -U postgres -d fastapi_db

redis-cli: ## Open Redis CLI
	docker-compose exec redis redis-cli

rabbitmq-management: ## Open RabbitMQ management (URL will be printed)
	@echo "RabbitMQ Management: http://localhost:15672"
	@echo "Default credentials: rabbitmq / rabbitmq"

