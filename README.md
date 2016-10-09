# rpi-onos
Open Network Operating System (ONOS) v1.8 on Raspberry Pi 2 (arm-v7l, raspbian 8.0)

# About the version and base images
This version of ONOS was built and runs on Raspberry pi 2 (arm-v7l architecture). The build was done over dockerized Raspbian 8.0/Linux 4.1.19-v7+. The docker image used is `sdhibit/rpi-raspbian`. You will find that version in the [raspbian Dockerfile](./Dockerfile). The image used to deploy on the dockerhub is not automatically built as docker cloud only supports builds on AMD64 architectures. All the information and guidance to build your own image from scrtach are in my [repo](.). I am currently looking for a convenient way to trigger the builds automatically.

The result of the build (onos 1.8.0) was tested successfully on Raspberry pi 2. If any users are on RPi 1 or RPi 3, your feedback is welcome. When you run your docker, wait about 3 minutes before trying commands or using the UI (time to load the apps and the rest of the system, proper to onos)

I choose to package it and run it in Docker for my convenience, but there is nothing holding you back from running it on bare Raspberry pi metal. Other armv7 ou armv8 architectures may be tested as well (no guaranty there). If you want direct links to the packaged (tarball) onos to install on bare arm metal (or out of curiosity), have a look at the Dockerfile, you will find the download links there. 

# Rebuild from scratch
The build takes a long time on Raspberry pi 2, especially if any errors occur. If you still want to go down the rabbit hole, here is some precious advice I gathered (feel free to propose update or feedback):
 - You can find the list of [detailed commands](./third-party/commands.txt) I used in the [third-party folder](./third-party). Update for your environment if needed.
 - I had to download the `java jdk 8u101 for Linux ARM 32` from the [oracle website](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and accept the License agreement by click. This is the tarball in the google drive downloaded at build time (github would not accept it, file size issue). The problem may occur when you want to download it in a non interactive mode (like in a docker build). The `AuthParam` number is what will be missing (it expires after some time). My best guesses are that it may be linked to a cookie or generated randomly after you accept the License. But I could not figure out a pattern or any hack/fix to this. Hence the use of a tarball in my google drive. I also tried to install the java package as done in the x86 version of the official onos Dockerfile, but it was not working (targetted to x86 I guess). Any enhancement for this part is welcome :)
 - The other problems I had encountered in the onos building phase had to do with finding ARM32 versions of some compilers. 
	- The first one is `thrift` for the `onos-bmv2-protocol-thrift-api` module. I fixed it by installing the `thrift-compiler` package and copying it to the folder where maven expects to find it.
 	- The second one was `protobuf` for the `onos-incubator-protobuf` module. I fixed it by downloading protoc-linux-arm32.exe from [here](https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/third_party/protobuf/protoc-linux-arm32.exe) and installing [protobuf](https://github.com/google/protobuf.git).
 	- Last is [grpc](https://github.com/grpc/grpc-java) for java on arm32. This one is tricky because grpc does not include ARM32 architectures in the gradle build. You have to [patch](https://raw.githubusercontent.com/neo-titans/odroid/master/build_tensorflow/grpc-java.v0.15.0.patch) the build.gradle file in the compiler folder for the java plugin. Thanks to authors of the patch and explanations on the issue (ejona86 and alexryan [here](https://github.com/grpc/grpc-java/issues/2202#issuecomment-250764314)).
 - For the `tools/build/onos-package` command I had to update the `tools/test/bin/onos-stage-apps` script, where I changed the `jar -xf` by `unzip` for the .oar archive (no idea how come this error was there in the first place).

# DISCLAIMER
This is not an official ONOS version. I am not a developper of the ONOS community nor affiliated to Open Networking Lab (ON.Lab). Use as you please but with no waranty.

# License
[MIT](./LICENSE)
