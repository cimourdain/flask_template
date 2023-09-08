RUN_ENV_VARS=$(shell cat .env | xargs)
TEST_ENV_VARS=$(shell cat .env | xargs)
BUILD_ENV_VARS=$(shell cat .env.build | xargs)

DOCKER_COMPOSE_RUN=$(RUN_ENV_VARS) docker-compose up
DOCKER_COMPOSE_STOP=$(RUN_ENV_VARS) docker-compose down --remove-orphans
DOCKER_COMPOSE_RUN_SHELL=docker-compose run --rm application bash
DOCKER_COMPOSE_STOP=docker-compose down --remove-orphans
DOCKER_COMPOSE_RUN_CMD=$(TEST_ENV_VARS) docker-compose -f docker-compose-no-data.yml run --rm -d application bash -c
DOCKER_COMPOSE_STOP_CMD=$(TEST_ENV_VARS) docker-compose -f docker-compose-no-data.yml down --remove-orphans

POETRY_RUN_CMD=poetry run
FORMAT_BLACK_CMD='${POETRY_RUN_CMD} black $${PROJECT_FOLDER_NAME}/ tests/'
FORMAT_ISORT_CMD='${POETRY_RUN_CMD} isort $${PROJECT_FOLDER_NAME} tests'

STYLE_FLAKE8_CMD='${POETRY_RUN_CMD} flake8 $${PROJECT_FOLDER_NAME} tests'
STYLE_BLACK_CHECK_CMD='${POETRY_RUN_CMD} black --check $${PROJECT_FOLDER_NAME} tests'
STYLE_MYPY_CMD='${POETRY_RUN_CMD} mypy $${PROJECT_FOLDER_NAME} --disallow-untyped-defs  --disallow-incomplete-defs --ignore-missing-imports'

TESTS_PYTEST_CMD='${POETRY_RUN_CMD} pytest tests/ -x'

COMPLEXITY_RADON_CC='${POETRY_RUN_CMD} radon cc -s -n B $${PROJECT_FOLDER_NAME} | tee /tmp/cc.txt && if [ -s /tmp/cc.txt ]; then exit 1; fi'
COMPLEXITY_RADON_MI='${POETRY_RUN_CMD} radon mi -n B $${PROJECT_FOLDER_NAME} | tee /tmp/mi.txt && if [ -s /tmp/mi.txt ]; then exit 1; fi'

init:  ## build application
	# create network for docker-compose.yml
	docker network inspect flask-template >/dev/null 2>&1 || \
		docker network create --driver bridge flask-template
	# create network for docker-compose-test.yml
	docker network inspect flask-template-test >/dev/null 2>&1 || \
		docker network create --driver bridge flask-template-test

	env $(BUILD_ENV_VARS) USER_UID=$(shell id -u $$USER) USER_GID=$(shell id -g $$USER) bash -c 'docker-compose build \
	--no-cache \
	--pull \
	--build-arg PYTHON_VERSION=$$PYTHON_VERSION \
	--build-arg POETRY_VERSION=$$POETRY_VERSION \
	--build-arg USER_UID=$$USER_UID \
	--build-arg USER_GID=$$USER_GID'

run:
	$(DOCKER_COMPOSE_RUN)
	$(DOCKER_COMPOSE_STOP)

shell:  ## Run interactive shell
	$(DOCKER_COMPOSE_RUN_SHELL)
	$(DOCKER_COMPOSE_STOP)

test:  ## test code
	$(DOCKER_COMPOSE_RUN_CMD) $(TESTS_PYTEST_CMD)
	$(DOCKER_COMPOSE_STOP_CMD)


format:  ## format code
	$(DOCKER_COMPOSE_RUN_CMD) $(FORMAT_BLACK_CMD)
	$(DOCKER_COMPOSE_RUN_CMD) $(FORMAT_ISORT_CMD)
	$(DOCKER_COMPOSE_STOP_CMD)

style:  ## check style
	$(DOCKER_COMPOSE_RUN_CMD) $(STYLE_FLAKE8_CMD)
	$(DOCKER_COMPOSE_RUN_CMD) $(STYLE_BLACK_CHECK_CMD)
	$(DOCKER_COMPOSE_RUN_CMD) $(STYLE_MYPY_CMD)
	$(DOCKER_COMPOSE_STOP_CMD)

## CI checks before pushing code
ci: test style

clean:
	bash scripts/docker stop_running_containers $(PROJECT_FOLDER_NAME)*
	bash scripts/docker remove_containers $(PROJECT_FOLDER_NAME)*
	bash scripts/docker clean_images $(PROJECT_FOLDER_NAME)*

.PHONY: shell init format style