# Flask application template

## Features
- Poetry dependency manager
- Pre-build Flask API
- Docker build & execution
- database (models in API + factories in tests)
- lint (black & isort) & style check (black, flake8 & mypy)

## Config and init
Update the name of the project folder `flask_template`:
- update folder name (and import paths in folder + in `tests` folder)
- replace `flask-template` in network name in network name in `docker-compose.yml` and `docker-compose-no-data.yml`
- value of project name in `pyproject.toml`
 

Run project initialization.
```bash
$ make init
```

## Run
```bash
$ make run
```
Application is available on http://localhost:5000/


## Update dependancies
1 - Update lockfile
```bash
$ make shell
app@xxx:~$ poetry add <your_dependency>
```

2 - Rebuild application (required?)
```bash
$ make init
```

## Tests
Run tests with the make command (:bulb: use pytest)
```bash
$ make test
```

## Style
Format automatically code (:bulb: use black & isort)
```bash
$ make format
```

Validate automatically code style (:bulb: use flake8 & mypy)
```bash
$ make format
```

# Database
## Config
### Setup your models
In the `<flask_template>/models` directories setup your models
    - :bulb: use (and remove) the existing `<flask_template>/user.py` as an example

## Use local database (database from docker-compose service)
### Autogenerate migrations with alembic
```bash
$ make shell
# auto-generate migrations from your models
app@xxx:~$ poetry run alembic revision --autogenerate -m "first migration" --rev-id=v001
# check the migration file created in `alembic/versions`

# apply migrations to impact database
app@xxx:~$ poetry run alembic upgrade head
```

### Populate database
Use the populate_database method from manage.py file to create your objects
(use existing example as a reference).

Then apply the database population by running:
```bash
$ make shell
# auto-generate migrations from your models
app@xxx:~$ poetry run python manage.py populate-database
```

### Update tests
- Update factories in `tests/factories` to match your models
- Create your tests


## Use remote database
- update the database `SQLALCHEMY_DATABASE_URI` in `.env`
- comment/remove the database service in `docker-compose.yml`


# TODO
- marshmallow/pydantic for serialization/deserialization
- auto openapi generation
- build
- hexagonal architecture



