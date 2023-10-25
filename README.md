
# [<b>Notice</b>] We have stopped development of onnx/wheel-builder. This repo won't be updated anymore. Going forward ONNX will directly use GiHub Action in onnx repo to release ONNX packages: [onnx/.github/workflows/release_*.yml](https://github.com/onnx/onnx/tree/main/.github/workflows).

Building and uploading ONNX wheels
===================================

This Git Repository enables automation of wheel building and deploying of **[ONNX](https://github.com/onnx/onnx)** packages.


Using the repository
--------------------

#### To test building wheels:
* Fork the project into own repo
* Set the build commit head of **ONNX** in `appveyor.yml` and `.travis.yml`

#### To test building and publishing to TestPyPi *(Credential needed)*
* Fork the project into own repo
* Set the build commit head of **ONNX** in `appveyor.yml` and `.travis.yml`
* If applicable, set the testing branch name in in `appveyor.yml` and `.travis.yml`

#### To test building and publishing to PyPi *(Credential and Release Permission needed)*
* Set the build commit head of **ONNX** in `appveyor.yml` and `.travis.yml`
* Run test
* Release with tag in WheelBuilder repo

How it works
------------

The wheel-builder repository:

-   build required protobuf libraries and C++ libraries in package;
-   builds a ONNX wheel, linking against the builds;
-   test installation and functionality of the produced wheels
-   deploy the wheel towards PyPI

The resulting wheels are therefore self-contained and do not need any
external dynamic libraries apart from those provided as standard by OSX
/ Linux as defined by the manylinux1 standard.

The `appveyor.yml` and `.travis.yml` in this repository have credentials of packages index repos. 
You may customize or update according to Travis/Appveyor Documentation at:
- <https://docs.travis-ci.com/user/encryption-keys>
- <https://www.appveyor.com/docs/build-configuration/#secure-variables>. 


Built With
----------
**[multibuild](https://github.com/matthew-brett/multibuild)** (master branch)

Developing
----------
For developing purpose, linux/osx build configurations are defined in config.sh
