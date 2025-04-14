# DeepFaceLive Docker

### Requirements

* system nvidia driver (current)
* cuda 12.6.1
* cuddn 9
* Docker
* nvidia-container-toolkit

# The improved docker file will take care of all of the python depends for you

### Setup

```
Install nvidia container toolkit via instructions required for your distro.
Configure for docker: sudo nvidia-ctk runtime configure --runtime=docker
Restart docker service. If not already set up.

git clone https://github.com/huhharraq-spomqa/DeepFaceLive/
cd DeepFaceLive/build/linux/
# add permissiveness to x11.
xhost +
# updated docker file will properly install and run DeepFaceLive properly on linux with full gpu support and running with -c allows camera access. Invoke bash script each time you want to run DeepFaceLive.
./start.sh -c

Usage of ./start.sh
# -d specify a folder for DeepFaceLive data (videos, models, etc. Note: not necessary with improvements)
-d /home/user/DeepFaceLive_data
# -c will pass through existing video devices such as /dev/video0 and /dev/video1, etc
```
