# FastAPI Production Template

[![CI](https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE/workflows/CI/badge.svg)](https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE/actions)
[![CD](https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE/workflows/CD/badge.svg)](https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE/actions)
[![CodeQL](https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE/workflows/CodeQL%20Analysis/badge.svg)](https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE/security/code-scanning)
[![Python 3.11](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/downloads/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-green.svg)](https://fastapi.tiangolo.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Code style: Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)

## Table of Contents

- [Overview & Purpose](#overview--purpose)
- [Architecture & Design](#architecture--design)
- [Deployment & Operations](#deployment--operations)
- [Local Development](#local-development)
- [Contribution & Standards](#contribution--standards)
- [Support & Contacts](#support--contacts)

---

## Overview & Purpose

### Strategic Context

This FastAPI Production Template serves as a **production-ready foundation** for building enterprise-grade RESTful APIs and microservices. It addresses the critical need for rapid development of scalable backend services while maintaining high standards for code quality, security, and operational excellence.

**Business Value:**
- **Reduced Time-to-Market**: Pre-configured architecture and tooling reduce initial setup time by ~80%
- **Operational Excellence**: Built-in monitoring, logging, and error tracking enable proactive issue resolution
- **Scalability**: Designed to handle high-throughput workloads (10,000+ concurrent requests) with horizontal scaling capabilities
- **Developer Productivity**: Standardized patterns and tooling reduce onboarding time for new team members

### Success Metrics & KPIs

The project tracks the following key performance indicators:

| Metric | Target | Current | Measurement |
|--------|--------|---------|-------------|
| **API Response Time (p95)** | < 200ms | TBD | Prometheus metrics |
| **Uptime SLA** | 99.9% | TBD | Uptime monitoring |
| **Test Coverage** | > 80% | TBD | Coverage reports |
| **Deployment Frequency** | Daily | TBD | CI/CD metrics |
| **Mean Time to Recovery (MTTR)** | < 30 min | TBD | Incident tracking |
| **Security Vulnerabilities** | 0 Critical | TBD | Dependabot + CodeQL |

### Problem Statement

**Instead of:** "This is a FastAPI backend"

**We provide:** "A production-ready RESTful API framework leveraging asynchronous I/O for high-concurrency request handling (10,000+ concurrent connections), integrated with PostgreSQL for transactional data persistence, RabbitMQ for event-driven asynchronous processing, Redis for sub-millisecond caching, and Celery for distributed background task execution. This architecture enables horizontal scaling and supports microservices patterns while maintaining data consistency and operational observability."

---

## Architecture & Design

### High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client Applications                      │
│              (Web, Mobile, Third-party Integrations)           │
└────────────────────────────┬────────────────────────────────────┘
                             │ HTTPS/REST + WebSocket
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                    FastAPI Application Layer                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Auth API   │  │  User API    │  │  Org API     │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │Notification  │  │  WebSocket   │  │  Settings    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└────────────┬───────────────┬───────────────┬────────────────────┘
             │               │               │
    ┌────────▼────┐  ┌──────▼──────┐  ┌───▼────────┐
    │ PostgreSQL   │  │   Redis    │  │  RabbitMQ  │
    │  (Primary)   │  │  (Cache)   │  │  (Queue)   │
    └──────────────┘  └────────────┘  └────────────┘
             │
    ┌────────▼────────────────────────┐
    │      Celery Workers             │
    │  (Background Task Processing)   │
    └─────────────────────────────────┘
             │
    ┌────────▼────────────────────────┐
    │   External Services              │
    │  • SMTP (Email)                 │
    │  • S3 (File Storage)            │
    │  • Sentry (Error Tracking)      │
    └─────────────────────────────────┘
```

### Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Request Flow                             │
│                                                             │
│  Client Request                                            │
│       │                                                     │
│       ▼                                                     │
│  ┌──────────────┐                                          │
│  │   Router     │  ← HTTP endpoint definitions             │
│  └──────┬───────┘                                          │
│         │                                                   │
│         ▼                                                   │
│  ┌──────────────┐                                          │
│  │   Service    │  ← Business logic layer                 │
│  └──────┬───────┘                                          │
│         │                                                   │
│         ▼                                                   │
│  ┌──────────────┐                                          │
│  │  Repository  │  ← Data access abstraction               │
│  └──────┬───────┘                                          │
│         │                                                   │
│         ▼                                                   │
│  ┌──────────────┐                                          │
│  │   Database   │  ← PostgreSQL via SQLAlchemy             │
│  └──────────────┘                                          │
└─────────────────────────────────────────────────────────────┘
```

### Technology Stack & Rationale

#### Core Framework
- **FastAPI 0.100+**: Chosen for its automatic OpenAPI documentation, async/await support, and performance comparable to Node.js/Go. Provides type safety through Pydantic validation and enables rapid API development.

#### Data Layer
- **PostgreSQL 15+**: ACID-compliant relational database selected for transactional integrity, JSON support, and mature ecosystem. AsyncPG driver enables non-blocking database operations.
- **SQLAlchemy 2.0+**: ORM providing database abstraction, migration support via Alembic, and type-safe query construction.

#### Caching & Session Storage
- **Redis 7+**: In-memory data store for sub-millisecond cache lookups, session management, and Celery result backend. Enables horizontal scaling of stateless application instances.

#### Message Queue
- **RabbitMQ 3+**: AMQP broker for reliable asynchronous message processing, event-driven architecture, and decoupling of services. Supports complex routing patterns and message durability.

#### Background Processing
- **Celery 5.3+**: Distributed task queue enabling offloading of CPU-intensive or long-running operations (email sending, file processing, data aggregation) from request-response cycle.

#### File Storage
- **AWS S3 / S3-compatible**: Object storage for user-uploaded files, media assets, and backups. Provides durability, scalability, and CDN integration capabilities.

#### Monitoring & Observability
- **Sentry**: Real-time error tracking and performance monitoring. Provides stack traces, release tracking, and alerting for production issues.

#### Development Tools
- **Poetry**: Dependency management with lock file support, ensuring reproducible builds across environments.
- **Ruff**: Fast Python linter and formatter, replacing Black + isort + flake8 with 10-100x faster execution.
- **Pytest**: Testing framework with async support, fixtures, and comprehensive plugin ecosystem.

### Architectural Decisions

For detailed architectural decision records (ADRs), see:
- [Architecture Documentation](./docs/architecture/) (if available)
- [ADRs](./docs/adr/) (if available)
- [Confluence/Wiki Link](https://your-wiki.com/project/architecture) (update with your link)

**Key Design Principles:**
1. **Separation of Concerns**: Clear boundaries between Router → Service → Repository layers
2. **Dependency Injection**: Services receive dependencies via constructor injection for testability
3. **Async-First**: All I/O operations use async/await for optimal concurrency
4. **Type Safety**: Full type hints with Pydantic models for runtime validation
5. **Fail-Fast**: Input validation at API boundary prevents invalid data propagation

---

## Deployment & Operations

### Health Checks & Monitoring

#### Application Health Endpoints

```bash
# Basic health check
curl http://localhost:8000/health

# Detailed health check (includes dependencies)
curl http://localhost:8000/health/detailed

# Readiness probe (for Kubernetes)
curl http://localhost:8000/ready

# Liveness probe
curl http://localhost:8000/live
```

**Expected Response:**
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2024-01-15T10:30:00Z",
  "checks": {
    "database": "ok",
    "redis": "ok",
    "rabbitmq": "ok"
  }
}
```

#### Monitoring Dashboards

- **Application Metrics**: [Grafana Dashboard](https://your-grafana.com/d/fastapi-app) (update with your link)
  - Request rate, latency (p50, p95, p99)
  - Error rate by endpoint
  - Database connection pool usage
  - Celery task queue depth

- **Infrastructure Metrics**: [Infrastructure Dashboard](https://your-grafana.com/d/infrastructure)
  - CPU, memory, disk usage
  - Network I/O
  - Container/pod metrics

- **Error Tracking**: [Sentry Dashboard](https://sentry.io/organizations/your-org/projects/fastapi-app/)
  - Error frequency and trends
  - Affected users
  - Release health scores

#### Key Metrics to Monitor

| Metric | Alert Threshold | Action |
|--------|----------------|--------|
| **p95 Latency** | > 500ms | Investigate slow queries, check database indexes |
| **Error Rate** | > 1% | Check Sentry for error details, review recent deployments |
| **Database Connections** | > 80% pool | Scale database or increase pool size |
| **Celery Queue Depth** | > 1000 tasks | Scale workers or optimize task processing |
| **Memory Usage** | > 85% | Check for memory leaks, consider scaling |

### CI/CD Pipeline

#### Pipeline Location
- **GitHub Actions**: `.github/workflows/ci.yml` and `.github/workflows/cd.yml`
- **Pipeline Status**: [View Workflows](https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE/actions)

#### Pipeline Stages

1. **Lint Stage**
   - Ruff formatting check
   - Ruff linting
   - Runs on: every push and PR

2. **Test Stage**
   - Unit tests (`tests/unit/`)
   - Integration tests (`tests/integration/`)
   - E2E tests (`tests/e2e/`)
   - Coverage reporting
   - Runs on: every push and PR

3. **Security Scan**
   - Bandit security analysis
   - CodeQL analysis
   - Dependency vulnerability scanning (Dependabot)
   - Runs on: every push, PR, and weekly schedule

4. **Docker Build**
   - Multi-stage Docker build test
   - Image size optimization verification
   - Runs on: every push and PR

5. **Deployment**
   - **Staging**: Auto-deploy on merge to `develop` branch
   - **Production**: Manual approval required, deploys on tag push (`v*.*.*`)

#### Modifying the Pipeline

To modify CI/CD configuration:

1. Edit `.github/workflows/ci.yml` for CI changes
2. Edit `.github/workflows/cd.yml` for deployment changes
3. Test locally using [act](https://github.com/nektos/act) or push to feature branch
4. Create PR with pipeline changes
5. Get approval from DevOps team (see CODEOWNERS)

### Fault Tolerance & Scalability

#### Fault Tolerance Strategies

1. **Database Connection Pooling**
   - Connection pool size: 10 (configurable via `DATABASE_POOL_SIZE`)
   - Max overflow: 20 connections
   - Pre-ping enabled to detect stale connections
   - Automatic retry on connection failures

2. **Circuit Breaker Pattern**
   - External service calls (SMTP, S3) implement circuit breakers
   - Fail-fast on repeated failures
   - Automatic recovery after cooldown period

3. **Graceful Degradation**
   - Cache failures don't block requests (fallback to database)
   - Email sending failures logged but don't fail user operations
   - Non-critical features can be disabled via feature flags

4. **Retry Logic**
   - Celery tasks implement exponential backoff retries
   - Database transactions retry on deadlock detection
   - Message queue consumers handle transient failures

#### Scalability Strategies

**Horizontal Scaling:**
- Stateless application design enables multiple instances behind load balancer
- Session data stored in Redis (shared across instances)
- Database read replicas for read-heavy workloads
- Celery workers scale independently based on queue depth

**Vertical Scaling:**
- Gunicorn workers: 4 workers per instance (configurable)
- Database connection pool tuned for instance capacity
- Worker concurrency: 4 tasks per Celery worker

**Scaling Guidelines:**
- **API Instances**: Scale based on CPU (target: 70% utilization)
- **Celery Workers**: Scale based on queue depth (target: < 100 pending tasks)
- **Database**: Monitor connection count, query performance, and replication lag

#### Disaster Recovery

- **Database Backups**: Daily automated backups with 30-day retention
- **Backup Location**: S3-compatible storage
- **Recovery Time Objective (RTO)**: 4 hours
- **Recovery Point Objective (RPO)**: 24 hours
- **Runbook**: [Disaster Recovery Runbook](./docs/runbooks/disaster-recovery.md) (create if needed)

---

## Local Development

### Prerequisites

Ensure you have the following installed:

- **Python 3.11+**: [Download](https://www.python.org/downloads/)
- **Poetry 1.8.3+**: [Installation Guide](https://python-poetry.org/docs/#installation)
- **Docker & Docker Compose**: [Installation Guide](https://docs.docker.com/get-docker/)
- **PostgreSQL 15+** (optional, if not using Docker)
- **Redis 7+** (optional, if not using Docker)
- **RabbitMQ 3+** (optional, if not using Docker)

**Verify installations:**
```bash
python --version  # Should be 3.11+
poetry --version  # Should be 1.8.3+
docker --version
docker-compose --version
```

### Quick Start (Docker - Recommended)

The fastest way to get started is using Docker Compose, which provides a fully reproducible environment:

```bash
# Clone the repository
git clone https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE.git
cd PYTHON-FASTAPI-PRODUCTION-TEMPLATE

# Copy environment file
cp .env.example .env
# Edit .env with your configuration (optional for local dev)

# Start all services (PostgreSQL, Redis, RabbitMQ, Backend, Celery)
docker-compose up -d

# View logs
docker-compose logs -f backend

# Access the API
curl http://localhost:8000/docs
```

**Services will be available at:**
- API: http://localhost:8000
- API Docs: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- RabbitMQ Management: http://localhost:15672 (guest/guest)

### Manual Setup (Without Docker)

For developers who prefer local installation:

#### 1. Clone and Setup Virtual Environment

```bash
git clone https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE.git
cd PYTHON-FASTAPI-PRODUCTION-TEMPLATE

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install Poetry (if not installed)
curl -sSL https://install.python-poetry.org | python3 -

# Install dependencies
poetry install
```

#### 2. Configure Environment Variables

```bash
# Copy example file
cp .env.example .env

# Edit .env with your local configuration
# Minimum required for local development:
# - POSTGRES_HOST=localhost
# - POSTGRES_PORT=5432
# - POSTGRES_DB=fastapi_db
# - POSTGRES_USER=postgres
# - POSTGRES_PASSWORD=postgres
# - REDIS_URL=redis://localhost:6379/0
# - RABBITMQ_HOST=localhost
# - RABBITMQ_USER=rabbitmq
# - RABBITMQ_PASSWORD=rabbitmq
```

#### 3. Setup Local Services

**PostgreSQL:**
```bash
# Using Homebrew (macOS)
brew install postgresql@15
brew services start postgresql@15

# Create database
createdb fastapi_db

# Or using Docker
docker run -d --name postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=fastapi_db \
  -p 5432:5432 \
  postgres:15-alpine
```

**Redis:**
```bash
# Using Homebrew (macOS)
brew install redis
brew services start redis

# Or using Docker
docker run -d --name redis -p 6379:6379 redis:7-alpine
```

**RabbitMQ:**
```bash
# Using Docker (recommended)
docker run -d --name rabbitmq \
  -p 5672:5672 -p 15672:15672 \
  -e RABBITMQ_DEFAULT_USER=rabbitmq \
  -e RABBITMQ_DEFAULT_PASS=rabbitmq \
  rabbitmq:3-management-alpine
```

#### 4. Run Database Migrations

```bash
# Set environment file
export ENV_FILE=.env.dev

# Run migrations
poetry run alembic upgrade head

# Or using Makefile
make migrate-up
```

#### 5. Start Development Server

```bash
# Using Makefile (recommended)
make run-dev

# Or using justfile
just run-dev

# Or directly
ENV_FILE=.env.dev poetry run uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

#### 6. Start Background Workers (Optional)

In separate terminals:

```bash
# Celery worker
make celery-worker

# Celery beat scheduler
make celery-beat
```

### Running Tests

#### Test Structure

- **Unit Tests** (`tests/unit/`): Test individual functions and classes in isolation
- **Integration Tests** (`tests/integration/`): Test component interactions (database, external services)
- **E2E Tests** (`tests/e2e/`): Test complete user workflows via HTTP

#### Running Tests

```bash
# Run all tests
make test

# Run with coverage report
make test-cov
# Coverage report will be in htmlcov/index.html

# Run specific test type
poetry run pytest tests/unit -v
poetry run pytest tests/integration -v
poetry run pytest tests/e2e -v

# Run specific test file
poetry run pytest tests/unit/test_users.py -v

# Run tests matching pattern
poetry run pytest -k "test_user" -v

# Run tests with markers
poetry run pytest -m "not slow" -v  # Skip slow tests
```

#### Test Database Setup

Tests use a separate database (`POSTGRES_DB_TEST`) and automatically:
- Create test database schema before tests
- Rollback transactions after each test
- Clean up test data

**Important**: Never run tests against production database. Always use `ENVIRONMENT=TESTING`.

### Debugging

#### VS Code Debugging Configuration

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: FastAPI",
      "type": "python",
      "request": "launch",
      "module": "uvicorn",
      "args": [
        "src.main:app",
        "--reload",
        "--host",
        "0.0.0.0",
        "--port",
        "8000"
      ],
      "jinja": true,
      "justMyCode": false,
      "env": {
        "ENV_FILE": ".env.dev"
      }
    },
    {
      "name": "Python: Pytest",
      "type": "python",
      "request": "launch",
      "module": "pytest",
      "args": [
        "-v",
        "--tb=short"
      ],
      "env": {
        "ENV_FILE": ".env.dev",
        "ENVIRONMENT": "TESTING"
      }
    }
  ]
}
```

#### Debugging Tips

1. **Use Logging**: Add strategic log statements:
   ```python
   import logging
   logger = logging.getLogger(__name__)
   logger.debug(f"Processing user_id={user_id}")
   ```

2. **Interactive Debugger**: Use `pdb` or `ipdb`:
   ```python
   import ipdb; ipdb.set_trace()
   ```

3. **Database Query Logging**: Enable SQLAlchemy echo:
   ```python
   # In database.py, set echo=True for engine
   engine = create_async_engine(url, echo=True)
   ```

4. **API Testing**: Use the interactive docs at http://localhost:8000/docs

5. **Celery Task Debugging**: Use Flower (Celery monitoring):
   ```bash
   poetry run celery -A src.celery:celery flower
   # Access at http://localhost:5555
   ```

### Code Quality Tools

```bash
# Format code
make format

# Run linters
make lint

# Run all pre-commit hooks
make pre-commit

# Install pre-commit hooks (runs automatically on git commit)
make pre-commit-install
```

---

## Contribution & Standards

### Git Workflow

We follow **Git Flow** with the following branch structure:

- **`main`** / **`master`**: Production-ready code. Protected branch, requires PR approval.
- **`develop`**: Integration branch for features. All feature branches merge here.
- **`feature/*`**: New features (e.g., `feature/user-authentication`)
- **`bugfix/*`**: Bug fixes (e.g., `bugfix/email-validation`)
- **`hotfix/*`**: Urgent production fixes (e.g., `hotfix/security-patch`)
- **`release/*`**: Release preparation branches

#### Branch Naming Convention

```
feature/<short-description>
bugfix/<short-description>
hotfix/<short-description>
release/<version>
```

Examples:
- `feature/add-oauth-providers`
- `bugfix/fix-memory-leak`
- `hotfix/critical-security-patch`

#### Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, config)

**Examples:**
```
feat(auth): add OAuth2 provider support

Implement Google and GitHub OAuth2 providers with JWT token generation.
Includes user creation flow and token refresh mechanism.

Closes #123
```

```
fix(api): resolve memory leak in WebSocket handler

Fix connection cleanup in WebSocket handler that was causing memory
leakage after client disconnections.

Fixes #456
```

### Code Style Guide

#### Python Style

- **Formatter**: Ruff (replaces Black)
- **Linter**: Ruff (replaces Flake8)
- **Import Sorting**: Ruff (replaces isort)
- **Type Hints**: Required for all function signatures
- **Docstrings**: Google-style docstrings for public APIs

**Run style checks:**
```bash
make format  # Auto-fix formatting issues
make lint    # Check for style violations
```

#### Code Review Checklist

Before submitting a PR, ensure:

- [ ] Code follows project style guidelines (run `make format`)
- [ ] All tests pass (`make test`)
- [ ] Test coverage maintained or improved
- [ ] Type hints added for new functions
- [ ] Docstrings added for public APIs
- [ ] No hardcoded secrets or credentials
- [ ] Environment variables documented in `.env.example`
- [ ] Database migrations tested (if applicable)
- [ ] Breaking changes documented in CHANGELOG.md
- [ ] PR description includes context and testing instructions

### Security Best Practices

#### Secrets Management

- **Never commit secrets** to version control
- Use environment variables for all sensitive data
- `.env` files are gitignored
- Use secret management services (AWS Secrets Manager, HashiCorp Vault) in production

#### Input Validation

- All API inputs validated via Pydantic models
- SQL injection prevention: Use SQLAlchemy ORM (never raw SQL with user input)
- XSS prevention: Sanitize user-generated content
- CSRF protection: Use CSRF tokens for state-changing operations

#### Authentication & Authorization

- JWT tokens with secure secret keys
- Token expiration: 14 days (configurable)
- Password hashing: bcrypt with salt rounds
- Role-based access control (RBAC) implemented

#### Dependency Management

- Regular dependency updates via Dependabot
- Security vulnerability scanning via CodeQL
- Review and test dependency updates before merging

**Check for vulnerabilities:**
```bash
poetry audit
```

### Pull Request Process

#### Creating a Pull Request

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes & Commit**
   ```bash
   git add .
   git commit -m "feat(scope): your commit message"
   ```

3. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   # Create PR via GitHub UI
   ```

4. **PR Description Template**

   Fill out the PR template with:
   - **Description**: What changed and why
   - **Type of Change**: Bug fix, feature, etc.
   - **Testing**: How to test the changes
   - **Checklist**: Confirm all items checked

#### PR Review Process

1. **Automated Checks**: CI pipeline runs automatically
   - All checks must pass before merge
   - Code coverage must not decrease

2. **Code Review**: 
   - Minimum 1 approval required (see CODEOWNERS)
   - Address review comments
   - Update PR with requested changes

3. **Merge**:
   - Squash and merge (preferred) or rebase and merge
   - Delete feature branch after merge

#### PR Review Guidelines for Reviewers

- **Be constructive**: Provide specific, actionable feedback
- **Explain why**: Help author understand the reasoning
- **Be timely**: Respond within 24 hours
- **Approve when ready**: Don't request unnecessary changes

### Documentation Standards

- **API Documentation**: Auto-generated via FastAPI/OpenAPI
- **Code Comments**: Explain "why", not "what"
- **README Updates**: Update README for user-facing changes
- **CHANGELOG**: Document breaking changes and new features
- **ADRs**: Document significant architectural decisions

---
#### For Questions & Support

- **Slack Channel**: [#fastapi-template](https://your-slack.slack.com/channels/fastapi-template)
  - General questions, discussions, quick help
  - Response time: Within business hours

- **GitHub Discussions**: [Discussions](https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE/discussions)
  - Feature discussions, Q&A, announcements

- **Email**: [team@example.com](mailto:team@example.com)
  - Formal requests, escalations

#### For Issues & Bugs

- **GitHub Issues**: [Issue Tracker](https://github.com/your-org/PYTHON-FASTAPI-PRODUCTION-TEMPLATE/issues)
  - Bug reports, feature requests
  - Use issue templates for structured reporting

#### For Security Issues

- **Security Email**: [security@example.com](mailto:security@example.com)
  - **Do not** use public issue tracker for security vulnerabilities
  - See [SECURITY.md](./SECURITY.md) for details

#### For Incidents & Production Issues

- **PagerDuty**: [On-call Schedule](https://your-pagerduty.com/schedules)
- **Incident Response**: Follow [Incident Runbook](./docs/runbooks/incident-response.md) (create if needed)

### Office Hours

- **Tech Lead Office Hours**: Tuesdays 2-3 PM EST
- **Architecture Review**: Thursdays 10-11 AM EST
- **Sprint Planning**: Every Monday 9-10 AM EST

### Additional Resources

- **Internal Wiki**: [Confluence/Wiki Link](https://your-wiki.com/project/fastapi-template)
- **Architecture Documentation**: [Architecture Docs](./docs/architecture/)
- **API Documentation**: http://localhost:8000/docs (local) or [Production API Docs](https://api.example.com/docs)
- **Monitoring Dashboards**: [Grafana](https://your-grafana.com)
- **Error Tracking**: [Sentry](https://sentry.io/organizations/your-org/projects/fastapi-app/)

---

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---

## Acknowledgments

Built with:
- [FastAPI](https://fastapi.tiangolo.com/) - Modern, fast web framework
- [SQLAlchemy](https://www.sqlalchemy.org/) - SQL toolkit and ORM
- [Celery](https://docs.celeryq.dev/) - Distributed task queue
- [Poetry](https://python-poetry.org/) - Dependency management
