# Use a slim base to keep image size down
FROM python:3.10-slim

# Install ffmpeg system binary
RUN apt-get update \
 && apt-get install -y ffmpeg \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy your requirements
COPY requirements.txt .

# 1. Install everything *except* torch from PyPI
# 2. Then install torch==2.2.0+cpu from the CPU-only index
RUN pip install --no-cache-dir \
      --no-deps \
      -r <(grep -v "^torch==" requirements.txt) \
 && pip install --no-cache-dir \
      --index-url https://download.pytorch.org/whl/cpu \
      torch==2.2.0+cpu

# Copy the rest of your app
COPY . .

# Start Streamlit
CMD ["streamlit", "run", "app.py", "--server.port", "8080", "--server.enableCORS", "false"]
