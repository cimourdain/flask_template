from environs import Env


env = Env()
env.read_env()

DEBUG = env.bool("DEBUG", True)
FLASK_DEBUG = env.bool("FLASK_DEBUG", False)
LOG_LEVEL = env.str("LOG_LEVEL", "DEBUG")
PORT = env.int("PORT", 5000)

SQLALCHEMY_DATABASE_URI = env.str("SQLALCHEMY_DATABASE_URI")
