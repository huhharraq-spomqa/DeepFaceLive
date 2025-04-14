FROM nvidia/cuda:12.6.1-cudnn-devel-ubuntu22.04
ENV DISPLAY=:0
WORKDIR /app
ARG DEBIAN_FRONTEND=noninteractive
ARG NV_VER

# Add deadsnakes PPA and install dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libgl1-mesa-glx libegl1-mesa libxrandr2 libxss1 libxcb-cursor0 libxcomposite1 \
    sudo libxcb-xinerama0 libasound2 libxi6 libxtst6 curl ffmpeg git nano gnupg2 \
    libsm6 wget unzip libxcb-icccm4 libxkbcommon-x11-0 libxcb-keysyms1 \
    libxcb-render0 libxcb-render-util0 libxcb-image0 python3.9 build-essential python3-dev python3.9-distutils python3-pip \
    python3-distutils-extra && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ensure pip is installed for Python 3.9
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

# Set Python 3.9 as default by updating symlinks
RUN ln -sf /usr/bin/python3.9 /usr/bin/python3 && \
    ln -sf /usr/bin/python3.9 /usr/bin/python && \
    ln -sf /usr/bin/pip3.9 /usr/bin/pip && \
    ln -sf /usr/bin/pip3.9 /usr/bin/pip3

# Upgrade pip for Python 3.9 and install dependencies
RUN python3.9 -m pip install \
    --extra-index-url https://download.pytorch.org/whl/cu126 \
    numpy==1.21.6 h5py numexpr protobuf flatbuffers sympy packaging \
    opencv-python==4.8.0.74 opencv-contrib-python==4.8.0.74 \
    pyqt6==6.9.0 onnx torch==2.6.0+cu126 torchvision==0.21.0+cu126 build onnxruntime-gpu==1.19.0

# Clone DeepFaceLive repo
WORKDIR /app
RUN git clone https://github.com/iperov/DeepFaceLive.git

WORKDIR /app/DeepFaceLive

COPY example.sh example.sh

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

CMD ["./example.sh"]

