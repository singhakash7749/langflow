FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libffi-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir langflow==0.0.44

EXPOSE 7860

CMD ["langflow", "--host", "0.0.0.0", "--port", "7860"]

