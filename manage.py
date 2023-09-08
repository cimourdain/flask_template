import click

from flask_template.models import db_session
from flask_template.models.user import User


@click.group()
def cli():
    pass

@cli.command()
def populate_database():
    new_user = User(
        name="test_user"
    )
    db_session.add(new_user)
    db_session.commit()

@cli.command()
def check_db():
    user_count = User.query.count()
    print(user_count)



if __name__ == "__main__":
    cli()
