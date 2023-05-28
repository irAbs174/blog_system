# Use an official Python runtime as a parent image
FROM python:3.8
LABEL maintainer="hello@wagtail.io"

# Set environment varibles
ENV PYTHONUNBUFFERED 1
ENV DJANGO_ENV dev

# Copy the current directory contents into the container at /code/
COPY . .

RUN pip install --upgrade pip
# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt
RUN pip install gunicorn

RUN python manage.py migrate

RUN useradd ADMIN
RUN chown -R ADMIN
USER ADMIN

EXPOSE 8000
CMD exec gunicorn mysite.wsgi:application --bind 0.0.0.0:8000 --workers 3
