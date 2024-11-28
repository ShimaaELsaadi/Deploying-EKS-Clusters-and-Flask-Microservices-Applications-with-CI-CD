# Use an official Python runtime as a base image
FROM python:3.9-slim
# Set the working directory in the container
WORKDIR /app
# Copy the current directory contents into the container
COPY . /app
# Install any necessary dependencies
RUN pip install --no-cache-dir -r requirements.txt
# Set environment variables for Flask
ENV FLASK_APP=run.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
ENV FLASK_DEBUG=1
# Expose port 5000
EXPOSE 5000
# Command to run the application
CMD ["flask", "run"]