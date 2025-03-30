# FastAPI Chatbot API

Backend API for a modern chatbot application built with FastAPI.

## Tech Stack

- FastAPI, Pydantic V2
- SQLAlchemy 2.0, PostgreSQL
- Redis for caching and job queues
- ARQ for background tasks
- Docker, Docker Compose

## Quick Start

1. Navigate to the API directory:

   ```
   cd apps/api
   ```

1. Create `.env` file in `src` directory:

   ```
   # Create .env file
   cp .env.example src/.env   # Create your own if example doesn't exist
   ```

1. Start development environment using Docker:

   ```
   docker-compose up -d
   ```

1. Create database tables (first time only):

   ```
   docker-compose exec web python -c "import asyncio; from app.core.setup import create_tables; asyncio.run(create_tables())"
   ```

1. Create superuser and default tier:

   ```
   # Uncomment create_superuser and create_tier sections in docker-compose.yml first
   docker-compose up -d create_superuser create_tier
   ```

1. Access API docs at http://localhost:8000/docs

## Development vs Production

**Development mode** (default in docker-compose.yml):

```
command: uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

**Production mode**:

```
command: gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000
```

## Code Quality

The project uses pre-commit hooks for code quality checks. Pre-commit is included in the project dependencies (pyproject.toml), so it's automatically installed when setting up the project.

When you run `pnpm install` in the API directory:

1. A Python virtual environment is created in `venv/` (if it doesn't exist)
1. Poetry dependencies including pre-commit are installed via pyproject.toml

To run linting checks manually:

```
# Using Docker container
pnpm lint
```

The container-based approach is useful for:

- Testing in environments similar to CI pipelines
- Ensuring consistent Python version (3.11)
- Running checks without local Python setup

This will run checks for:

- Code formatting with Ruff
- Python syntax upgrades
- Docstring formatting
- No trailing whitespace
- No large files or private keys committed
- And more

### Troubleshooting Linting Issues

Common linting errors and solutions:

1. **Wildcard Import Warnings (F403)**:

   - This error occurs in files like `src/app/core/setup.py` with imports like `from ..models import *`
   - We've configured Ruff to ignore these warnings in the pre-commit config
   - If you need to fix this properly, replace wildcard imports with explicit imports

1. **Pre-commit Hook Errors**:

   - If you encounter errors with hook language or compatibility:
   - Try running with the manual flag: `pre-commit run --all-files --hook-stage manual`
   - Use the container-based approach: `pnpm lint`

1. **Missing Docstrings/Type Hints**:

   - Follow the FastAPI docstring style when adding new code
   - Include type hints for function parameters and return values

## Root Repository Husky Setup

To configure Husky at the repository root to run Python linting checks, add a pre-commit hook in your root Husky configuration:

```js
// Example .husky/pre-commit script
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# Run standard JS/TS checks first
pnpm lint-staged

# Run Python pre-commit checks when changes are in the API directory
if git diff --cached --name-only | grep -q "^apps/api/"; then
  echo "🐍 Running Python checks for API..."
  cd apps/api && pnpm lint
fi
```

Make sure your root package.json has Husky configured:

## PNPM Integration

The API includes a `package.json` for PNPM support, allowing you to use NPM-style commands with the Python API:

```
# Install dependencies and set up venv
pnpm install

# Run pre-commit checks on all files using Docker
pnpm lint

# Run tests on already running containers
pnpm test

# Run tests in a dedicated container
pnpm test:run

# Start, stop and restart Docker containers
pnpm start
pnpm stop
pnpm restart
```

When using a monorepo, you can run these commands from the root using:

```
pnpm --filter api <command>
```

## Authentication

Authentication uses JWT tokens:

- Login at `/api/v1/login` with username/password
- Refresh tokens at `/api/v1/refresh`
- Logout at `/api/v1/logout`

## API Features

Built on a comprehensive FastAPI boilerplate, this API includes:

- User authentication with JWT
- Rate limiting
- Redis caching
- Background tasks with ARQ
- API versioning
- Pydantic validation
- Fully async database operations

For more detailed documentation on the boilerplate features, visit:
https://github.com/igormagalhaesr/FastAPI-boilerplate
