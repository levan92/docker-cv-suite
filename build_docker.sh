docker build -t levan92/cv-suite:latest . -f Dockerfile
docker build -t levan92/cv-suite:no-trt . -f no-trt.Dockerfile
# docker build --no-cache -t levan92/cv-suite .