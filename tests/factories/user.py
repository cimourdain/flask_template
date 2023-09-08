import factory
from factory.alchemy import SQLAlchemyModelFactory

from flask_template.models import db_session
from flask_template.models.user import User


class UserConstructor(SQLAlchemyModelFactory):
    class Meta:
        model = User
        sqlalchemy_session = db_session
        sqlalchemy_session_persistence = "flush"

    name = factory.Faker("name")
