from flask import Blueprint

bp = Blueprint("home_bp", __name__)


@bp.route("/", methods=["GET"])
def hello_route() -> str:
    return "Hello"
