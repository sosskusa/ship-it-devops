# syntax=docker/dockerfile:1

# ===== STAGE 1: "builder" - install the libraries =====
# Start from an official Python image. "slim" = small Debian-based version.
FROM python:3.12-slim AS builder

# Work inside /build in this stage.
WORKDIR /build

# Create a virtual environment at /opt/venv and put it first on the PATH,
# so "pip" and "python" below use it.
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy ONLY the requirements file first (see the caching note below).
COPY requirements.txt .

# Install the packages. --no-cache-dir stops pip saving download files.
RUN pip install --no-cache-dir -r requirements.txt


# ===== STAGE 2: runtime - the image we actually ship =====
# A fresh, clean image. Nothing from stage 1 comes along unless we copy it.
FROM python:3.12-slim

# PYTHONDONTWRITEBYTECODE: don't create .pyc cache files.
# PYTHONUNBUFFERED: print logs immediately (so "docker logs" shows them live).
# PATH: use the venv we are about to copy in.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

# Create a normal user. Running as root inside a container is a security risk.
RUN useradd --create-home --uid 10001 appuser

WORKDIR /app

# Copy the finished venv from stage 1 (this is the multi-stage part).
COPY --from=builder /opt/venv /opt/venv

# Copy ONLY the app code. Nothing else is needed to run it.
COPY app.py .

# From here on, run as the non-root user.
USER appuser

# Documentation: the app listens on 8000. (This does not publish the port.)
EXPOSE 8000

# The command that runs when a container starts: gunicorn, a production server.
# "app:app" = file app.py, variable app inside it.
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]