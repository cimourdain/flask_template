from datetime import datetime

from sqlalchemy import TIMESTAMP, Column, Integer
from sqlalchemy.orm import declarative_base
from sqlalchemy.sql.expression import func

from flask_template.models import db_session


class DeclarativeBase(object):
    __tablename__ = None

    id = Column(Integer, primary_key=True, autoincrement=True)
    created = Column(
        TIMESTAMP(timezone=True),
        default=lambda: datetime.now(),
        server_default=func.now(),
        nullable=False,
    )


Base = declarative_base(cls=DeclarativeBase)
Base.query = db_session.query_property()
