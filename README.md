# Two Tone DevOps starter app

A tiny Python (Flask) API with two endpoints:

| Endpoint  | What it returns |
|-----------|-----------------|
| `GET /`       | `{"message": "Hello from Two Tone"}` |
| `GET /health` | App status and whether it can reach the database |

## Run it locally (without Docker)

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python app.py                    # http://localhost:8000
pytest                           # runs the tests
```

To connect a database, set `DATABASE_URL`, e.g.
`postgresql://user:password@localhost:5432/twotone`.

For production, run it with gunicorn: `gunicorn -b 0.0.0.0:8000 app:app`

Your task is described in the challenge brief (PDF) that came with this folder.
