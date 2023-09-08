import os

from flask_template import create_app

app = create_app()

if __name__ == "__main__":
    if "SETTINGS" not in os.environ:
        os.environ["SETTINGS"] = "settings_dev.py"
    app.run(host="0.0.0.0", debug=app.config["DEBUG"], port=app.config["PORT"])
