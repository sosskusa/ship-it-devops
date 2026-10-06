"""Two Tone intern challenge - DevOps starter app.

A tiny Flask API. Your job is NOT to change what it does, but to
containerise it, run it with PostgreSQL, and automate its build and tests.
"""
import os

from flask import Flask, jsonify

app = Flask(__name__)


def database_url():
    # The database connection string must come from the environment.
    return os.environ.get("DATABASE_URL")


@app.get("/")
def hello():
    return jsonify(message="Hello from Two Tone")


@app.get("/health")
def health():
    """Reports whether the app is up and whether it can reach the database."""
    url = database_url()
    if not url:
        return jsonify(status="ok", database="not configured"), 200
    try:
        import psycopg

        with psycopg.connect(url, connect_timeout=3) as conn:
            conn.execute("SELECT 1")
        return jsonify(status="ok", database="connected"), 200
    except Exception as exc:  # noqa: BLE001
        return jsonify(status="error", database="unreachable", detail=str(exc)), 503


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8000)))
