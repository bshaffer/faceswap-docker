FaceSwap for Docker
===================

This library contains a `Dockerfile` for running [matthewearl/faceswap][faceswap_git]
in a Docker container.

## How to Use

Pull the image from Dockerhub:

```bash
docker pull bshaffer/faceswap
```

Place the images you want to use in a directory docker can mount

```bash
mkdir /tmp/faceswap
cp image1.jpg /tmp/faceswap
cp image2.jpg /tmp/faceswap
```

Run the image and mount the directory you created above:

```bash
docker run -v /tmp/faceswap:/tmp/faceswap bshaffer/faceswap \
    /tmp/faceswap/image1.jpg \
    /tmp/faceswap/image2.jpg \
    /tmp/faceswap/output.jpg
```

The faceswapped image will now be in the mounted directory `/tmp/faceswap` with the name `output.jpg`.

[faceswap_git]: https://github.com/matthewearl/faceswap
