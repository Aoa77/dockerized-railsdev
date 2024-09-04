clear
docker rm railsdev --force
docker image rm ubuntu:aoa77-rails-dev
docker build -t ubuntu:aoa77-rails-dev .
docker run --name railsdev -it ubuntu:aoa77-rails-dev