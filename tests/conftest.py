import pytest
from _pytest.fixtures import FixtureRequest
from flask import Flask
from sqlalchemy.orm import Session

from flask_template import create_app
from flask_template.models import db_session as _db_session
from flask_template.models import engine
from flask_template.models.base import Base


@pytest.fixture(scope="session")
def app(request):
    """Session-wide test `Flask` application."""
    app = create_app()
    return app


@pytest.fixture(scope="session")
def client(app):
    """Return a Flask test client.

    An instance of :class:`flask.testing.TestClient` by default.
    """
    with app.test_client() as client:
        yield client


@pytest.fixture(autouse=True)
def requests_mock(mocker):
    """Prevent external calls with requests during tests."""
    restricted_methods = [
        "get",
        "post",
        "put",
        "patch",
        "delete",
    ]
    for method in restricted_methods:
        mocker.patch(
            f"requests.{method}",
            side_effect=NotImplementedError(
                f"external apis {method.upper()} calls should be mocked"
            ),
        )
        mocker.patch(
            f"requests.Session.{method}",
            side_effect=NotImplementedError(
                f"external apis {method.upper()} calls should be mocked"
            ),
        )


def pytest_sessionstart(session):
    # re-create database on test session start
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)


@pytest.fixture(scope="session")
def db_session(request: FixtureRequest, app: Flask):
    with app.app_context():
        yield _db_session


@pytest.fixture(autouse=True)
def transaction_function(request: FixtureRequest, db_session: Session) -> None:
    db_session.begin_nested()

    def rollback():
        db_session.rollback()
        db_session.expire_all()

    request.addfinalizer(rollback)


@pytest.fixture(scope="function", autouse=True)
def disable_session_commit(db_session: Session, mocker) -> None:
    """Replace the commit method by the flush one."""
    mocker.patch.object(db_session, "commit", wraps=db_session.flush)
