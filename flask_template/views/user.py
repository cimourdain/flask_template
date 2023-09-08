from flask import Blueprint, jsonify

from flask_template.models.user import User

bp = Blueprint("user_bp", __name__)


@bp.route("/", methods=["GET"])
def users() -> str:
    users = User.query
    names = [u.name for u in users]
    return jsonify(names), 200
