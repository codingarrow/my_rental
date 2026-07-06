# Minimal image for the Flask rental app.
FROM python:3.12-slim

WORKDIR /app

# Install deps first for better layer caching.
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app (app.py, index.html, bookings.json).
COPY . .

EXPOSE 5000

# host 0.0.0.0 is already set in app.py so the port is reachable from outside.
CMD ["python", "app.py"]

