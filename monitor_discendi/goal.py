import functools

from flask import (
    Blueprint,
    flash,
    g,
    redirect,
    render_template,
    request,
    session,
    url_for,
)
from monitor_discendi.db import get_db

bp = Blueprint("goal", __name__, url_prefix="/goal")


@bp.route("/")
def index():
    db = get_db()
    goals = db.execute("SELECT * FROM goal ORDER BY focus_level ASC").fetchall()
    return render_template("goal/index.html", goals=goals)
