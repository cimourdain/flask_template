from flask import Flask

from flask_template.views import home, user


def init(app: Flask) -> None:
    app.register_blueprint(home.bp)
    app.register_blueprint(user.bp, url_prefix="/user")
