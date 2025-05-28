# Use a slim base to keep image size down
FROM python:3.10-slim

# Use bash to support scripting features
SHELL ["/bin/bash", "-lc"]

# Install ffmpeg system binary
RUN apt-get update \
 && apt-get install -y ffmpeg \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy your requirements
COPY requirements.txt .

# 1) Extract all requirements except torch
RUN grep -v '^torch==' requirements.txt > req_no_torch.txt

# 2) Install everything but torch
RUN pip install --no-cache-dir -r req_no_torch.txt

# 3) Install CPU-only torch from PyTorch CPU index
RUN pip install --no-cache-dir \
      --index-url https://download.pytorch.org/whl/cpu \
      torch==2.2.0+cpu

# Copy the rest of your app files
COPY . .

# Start Streamlit
CMD ["streamlit", "run", "app.py", "--server.port", "8080", "--server.enableCORS", "false"]
