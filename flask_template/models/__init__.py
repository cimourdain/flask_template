import typing

from flask import Flask
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, scoped_session, sessionmaker

from instance import settings

engine = create_engine(
    settings.SQLALCHEMY_DATABASE_URI,
    connect_args={
        "connect_timeout": 2,
    },
    pool_pre_ping=True,
    pool_size=20,
)

db_session = scoped_session(sessionmaker(autocommit=False, autoflush=True, bind=engine))


def init_app(app: Flask) -> None:
    #
    @app.teardown_appcontext
    def shutdown_session(response_or_exc: typing.Any) -> typing.Any:
        db_session.remove()
        return response_or_exc

    @app.teardown_request
    def teardown_request_func(error: typing.Any = None) -> typing.Any:
        if error:
            db_session.rollback()
