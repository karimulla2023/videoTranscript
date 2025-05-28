# ─── STAGE 1: Build ─────────────────────────────────────
FROM python:3.10-slim AS builder

# Install ffmpeg, pip-compile tool, etc.
RUN apt-get update \
 && apt-get install -y ffmpeg gcc build-essential \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .

# Install all deps into /deps
RUN pip install --no-cache-dir --prefix=/deps \
      torch==2.2.0+cpu \
      openai-whisper \
      ffmpeg-python \
      streamlit==1.35.0

# Copy your app files
COPY app.py .

# ─── STAGE 2: Runtime ────────────────────────────────────
FROM python:3.10-slim

# Copy ffmpeg binary
RUN apt-get update \
 && apt-get install -y ffmpeg \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
# Pull in only the installed site-packages
COPY --from=builder /deps /usr/local

# Copy app
COPY --from=builder /app/app.py ./app.py

# Start
CMD ["streamlit", "run", "app.py", "--server.port", "8080", "--server.enableCORS", "false"]
