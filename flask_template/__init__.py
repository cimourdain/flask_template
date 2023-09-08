from flask import Flask

from flask_template import models, views


def create_app(name: str = __name__) -> Flask:
    app = Flask(name, instance_relative_config=True)

    app.config.from_pyfile("settings.py")

    views.init(app)
    models.init_app(app)

    return app
