# based on https://gorails.com/setup/ubuntu/24.04
FROM ubuntu:aoa77-railsdev-base

RUN echo 'asdf plugin add ruby' >> ~/.bashrc
RUN echo 'asdf install ruby 3.3.3' >> ~/.bashrc
RUN echo 'asdf global ruby 3.3.3' >> ~/.bashrc
RUN echo 'gem update --system' >> ~/.bashrc
