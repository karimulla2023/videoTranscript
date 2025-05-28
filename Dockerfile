FROM python:3.10-slim

# Install ffmpeg  
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .

# Pull only CPU-only PyTorch wheels  
RUN pip install --no-cache-dir \
    --index-url https://download.pytorch.org/whl/cpu \
    -r requirements.txt

COPY . .

CMD ["streamlit", "run", "app.py", "--server.port", "8080", "--server.enableCORS", "false"]
