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


@bp.route("/create", methods=("GET", "POST"))
def create():
    if request.method == "POST":
        title = request.form["title"]
        synopsis = request.form["synopsis"]
        url_address = request.form["url_address"]
        focus_level = request.form["focus_level"]
        due_date = request.form["due_date"]
        notes = request.form["notes"]
        is_complete = request.form.get("is_complete", 0, type=int)
        error = None

        if not title:
            error = "Title is required."
        elif not focus_level:
            error = "Focus level is required."

        if error is None:
            db = get_db()
            db.execute(
                "INSERT INTO goal (title, synopsis, url_address, focus_level, due_date, notes, is_complete)"
                " VALUES (?, ?, ?, ?, ?, ?, ?)",
                (
                    title,
                    synopsis,
                    url_address,
                    focus_level,
                    due_date,
                    notes,
                    is_complete,
                ),
            )
            db.commit()
            return redirect(url_for("goal.index"))

        flash(error)

    return render_template("goal/create.html")


@bp.route("/<int:id>", methods=("GET",))
def read(id):
    db = get_db()
    goal = db.execute("SELECT * FROM goal WHERE id = ?", (id,)).fetchone()
    objectives = db.execute(
        "SELECT * FROM objective WHERE goal_id = ?", (id,)
    ).fetchall()
    if goal is None:
        flash("Goal not found.")
        return redirect(url_for("goal.index"))

    return render_template("goal/read.html", goal=goal, objectives=objectives)


@bp.route("/<int:id>/edit", methods=("GET", "POST"))
def update(id):
    db = get_db()
    goal = db.execute("SELECT * FROM goal WHERE id = ?", (id,)).fetchone()

    if goal is None:
        flash("Goal not found.")
        return redirect(url_for("goal.index"))

    if request.method == "POST":
        title = request.form["title"]
        description = request.form["description"]
        focus_level = request.form["focus_level"]
        error = None

        if not title:
            error = "Title is required."
        elif not description:
            error = "Description is required."
        elif not focus_level:
            error = "Focus level is required."

        if error is None:
            db.execute(
                "UPDATE goal SET title = ?, description = ?, focus_level = ? WHERE id = ?",
                (title, description, focus_level, id),
            )
            db.commit()
            return redirect(url_for("goal.index"))

        flash(error)

    return render_template("goal/edit.html", goal=goal)
