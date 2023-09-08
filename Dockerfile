ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim

##################################################
# INSTALL POETRY
##################################################
ARG ENV
ARG POETRY_VERSION
ENV YOUR_ENV=${ENV} \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=$POETRY_VERSION \
  POETRY_VIRTUALENVS_CREATE=0

# Install Poetry
RUN pip install "poetry==$POETRY_VERSION"

##################################################
# Install project packages (no virtualenv)
##################################################
WORKDIR /code
COPY poetry.lock pyproject.toml /code/
RUN poetry config virtualenvs.create false \
  && poetry install $(test "$ENV" == production && echo "--no-dev") --no-interaction --no-ansi


##################################################
# CREATE USER (based on system user uid/gid) and folder to mount code
# this allow to mount code files with the proper rights (cf. docker-compose volume)
##################################################
ARG USER_UID
ARG USER_GID

# Create group if not found in /etc/group
RUN if ! $(awk -F':' '{print $3}' /etc/group |grep -q ${USER_GID}) ; then groupadd -g ${USER_GID} appgroup; fi
# create user
RUN useradd -rm -g ${USER_GID} -G sudo -u ${USER_UID} app

USER app
WORKDIR /home/app