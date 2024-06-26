FROM python:3.10.3-slim-bullseye

LABEL maintainer="https://suk.kr"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

WORKDIR /app
COPY . .

RUN apt update
RUN apt install -y gnupg build-essential cmake wget git libxrender1 fonts-nanum fontconfig libgl1-mesa-glx libglib2.0-0

RUN echo "deb http://security.ubuntu.com/ubuntu bionic-security main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

RUN apt update
RUN apt-cache policy libssl1.0-dev
RUN apt install -y libssl1.0-dev

RUN pip install fastapi uvicorn requests openai pdfkit python-dotenv opencv-python python-multipart cmake moviepy

RUN fc-cache -fv

WORKDIR /app/dlib
RUN git clone -b 'v19.9' --single-branch https://github.com/davisking/dlib.git /app/dlib
RUN python /app/dlib/setup.py install

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb
RUN apt install -y ./wkhtmltox_0.12.6-1.buster_amd64.deb

WORKDIR /app

CMD ["uvicorn", "app:app", "--host", "0.0.0.0"]