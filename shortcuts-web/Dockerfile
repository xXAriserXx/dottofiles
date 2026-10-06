FROM python:3.12-alpine
WORKDIR /app
COPY server.py index.html login.html ./
EXPOSE 8092
CMD ["python", "-u", "server.py"]
