from app import app


def test_hello_returns_message():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.get_json()["message"] == "Hello from Two Tone"


def test_health_without_database():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json()["status"] == "ok"
