FROM python:3.12-alpine
RUN pip install --no-cache-dir boto3
WORKDIR /app
COPY server.py index.html login.html ./
EXPOSE 8094
HEALTHCHECK --interval=60s --timeout=5s CMD wget -qO- http://127.0.0.1:8094/healthz || exit 1
CMD ["python", "-u", "server.py"]
