#!/bin/bash

# Search for the nvidia.ko module in common locations
NV_LIB=$(find /lib/modules/$(uname -r)/kernel/drivers/video/ /usr/lib/modules/$(uname -r)/extramodules/ -name nvidia.ko.zst 2>/dev/null | head -n 1)

# If a module is found, get the version
if [ -n "$NV_LIB" ]; then
  NV_VER=$(modinfo "$NV_LIB" | grep ^version | awk '{print $2}' | awk -F '.' '{print $1}')
  echo "Found Nvidia module: $NV_LIB"
  echo "Nvidia Driver Version: $NV_VER"
else
  echo "Nvidia module not found!"
fi

# Set the default data folder
DATA_FOLDER=$(pwd)/data/
declare CAM0 CAM1 CAM2 CAM3

# Print a new line for clarity
printf "\n"

# Parse command-line options
while getopts 'cd:h' opt; do
    case "$opt" in
        c)
            printf "Starting with camera devices\n"
            # Check if camera devices exist and add them to arguments
            test -e /dev/video0 && CAM0="--device=/dev/video0:/dev/video0"
            test -e /dev/video1 && CAM1="--device=/dev/video1:/dev/video1"
            test -e /dev/video2 && CAM2="--device=/dev/video2:/dev/video2"
            test -e /dev/video3 && CAM3="--device=/dev/video3:/dev/video3"
            echo $CAM0 $CAM1 $CAM2 $CAM3
            ;;
        d)
            DATA_FOLDER="$OPTARG"
            printf "Starting with data folder: %s\n" "$DATA_FOLDER"
            ;;
        ?|h)
            printf "Usage:\n$(basename $0) [-d] /path/to/your/data/folder\n"
            exit 1
            ;;
    esac
done
shift "$(($OPTIND -1))"
printf "\n"

# Build the Docker image with the NVIDIA version argument
DOCKER_BUILDKIT=1 docker build -t deepfacelive . --build-arg NV_VER="$NV_VER"

# Allow X11 access (optional, note the security warning)
xhost +

# Run the Docker container with the specified environment settings
docker run --network host --ipc host --gpus all \
    -e DISPLAY="$DISPLAY" \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$DATA_FOLDER":/data/ \
    $CAM0 $CAM1 $CAM2 $CAM3 \
    --rm -it deepfacelive
