FROM ubuntu:14.04
MAINTAINER Brent Shaffer <bshafs@gmail.com>

# Get dependencies
RUN apt-get update && apt-get install -y \
        build-essential \
        libboost-python-dev \
        cmake \
        pkg-config \
        curl \
        git \
        zip \
        python-dev \
        python-numpy \
        python-setuptools \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    easy_install pip

# Install OpenCV
RUN cd ~ && \
    mkdir opencv-tmp && \
    cd opencv-tmp && \
    curl -L \
        "http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/3.1.0/opencv-3.1.0.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fopencvlibrary%2F&ts=1478094317&use_mirror=heanet" \
        -o opencv-3.1.0.zip && \
    unzip opencv-3.1.0.zip && \
    cmake opencv-3.1.0 && \
    apt-get update && apt-get install -y python-opencv && \
    rm -Rf ~/opencv-tmp

# Install DLib
RUN cd ~ && \
    mkdir -p dlib-tmp && \
    cd dlib-tmp && \
    curl -L \
         https://github.com/davisking/dlib/archive/v19.0.tar.gz \
         -o dlib.tar.bz2 && \
    tar xf dlib.tar.bz2 && \
    cd dlib-19.0/python_examples && \
    mkdir build && \
    cd build && \
    cmake ../../tools/python && \
    cmake --build . --config Release && \
    cp dlib.so /usr/local/lib/python2.7/dist-packages && \
    pip install dlib && \
    rm -rf ~/dlib-tmp

# Download the library and the trained model and configure faceswap.py
RUN cd ~ && \
    git clone https://github.com/bshaffer/faceswap.git && \
    cd faceswap && \
    curl -L \
        http://sourceforge.net/projects/dclib/files/dlib/v18.10/shape_predictor_68_face_landmarks.dat.bz2 \
        -o shape_predictor_68_face_landmarks.dat.bz2 && \
    bunzip2 shape_predictor_68_face_landmarks.dat.bz2 && \
    mv ~/faceswap /usr/local/lib && \
    ln -s /usr/local/lib/faceswap/faceswap.py /usr/local/bin/ && \
    ln /dev/null /dev/raw1394

ENV FACESWAP_PREDICTOR_PATH "/usr/local/lib/faceswap/shape_predictor_68_face_landmarks.dat"

ENTRYPOINT ["faceswap.py"]
CMD []
