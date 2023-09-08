from sqlalchemy import Column, String

from flask_template.models.base import Base


class User(Base):
    __tablename__ = "user"

    name = Column(String)
