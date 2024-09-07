FROM ubuntu:24.04
SHELL ["/bin/bash", "-lc"]
RUN \
    ##############################
    # basics
    ##############################
    apt-get -y update; \
    apt-get install -y build-essential; \
    apt-get install -y libcurl4-openssl-dev; \
    apt-get install -y libffi-dev; \
    apt-get install -y libreadline-dev; \
    apt-get install -y libsqlite3-dev; \
    apt-get install -y libssl-dev; \
    apt-get install -y libxml2-dev; \
    apt-get install -y libxslt1-dev; \
    apt-get install -y libyaml-dev; \
    apt-get install -y software-properties-common; \
    apt-get install -y sqlite3; \
    apt-get install -y wget; \
    apt-get install -y zlib1g-dev; \
    ##############################
    # git and github-cli (gh)
    ##############################
    apt-get install -y git; \
    mkdir -p -m 755 /etc/apt/keyrings; \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null; \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null; \
    apt-get install -y gh; \
    ##############################
    # ruby on rails
    ##############################
    apt-get install -y ruby-full; \
    gem update --system; \
    gem install rails; \
    ##############################
    ##############################
    ##############################