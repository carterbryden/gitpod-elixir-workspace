FROM gitpod/workspace-postgresql

# for building erlang - not really needed using pre-compile erlang binaries (see below)
ENV KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"

# Install general deps and clean up a few things
RUN set -ex; \
    sudo apt-get update; \
    sudo apt-get -y install curl build-essential autoconf m4 inotify-tools gpg dirmngr gawk; \
    sudo apt-get clean; \
    sudo rm -rf /var/cache/apt/*; \
    sudo rm -rf /var/lib/apt/lists/*; \
    sudo rm -rf /tmp/*

# remove nvm and manage node via asdf - it's just nicer
RUN set -ex; \
    rm -rf ~/.nvm; \
    rm ~/.bashrc.d/50-node; \
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1; \
    echo ". $HOME/.asdf/asdf.sh" >> $HOME/.bashrc; \
    echo ". $HOME/.asdf/completions/asdf.bash"  >> $HOME/.bashrc; \
    mkdir -p $HOME/.config/fish && echo "source ~/.asdf/asdf.fish" >> ~/.config/fish/config.fish; \
    mkdir -p $HOME/.config/fish/completions && ln -s $HOME/.asdf/completions/asdf.fish ~/.config/fish/completions; \
    echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrc; \
    echo "fpath=(${ASDF_DIR}/completions $fpath)" >> ~/.zshrc; \
    echo "autoload -Uz compinit && compinit" >> ~/.zshrc;



# use erlang plugin fork to get pre-compiled binaries
#   - see: https://github.com/michallepicki/asdf-erlang-prebuilt-ubuntu-20.04
# install plugins and latest major version of erlang and elixir to save time in before stage of gitpod.yml
#   - these may be overruled by .tool-versions in before step of gitpod.yml
# run this inside of bash to make asdf available
# Note: adjust the versions below for whatever you need, or add other langs
# You'll have asdf available in your workspace too so you can change version on the fly.
RUN set -ex; \
    bash -c "set -ex; \
    . $HOME/.asdf/asdf.sh; \
    asdf plugin-add erlang https://github.com/michallepicki/asdf-erlang-prebuilt-ubuntu-20.04.git; \
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git; \
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git; \
    asdf install erlang 25.0.4; \
    asdf install elixir 1.13.4-otp-25; \
    asdf install nodejs 14.17.6; \
    asdf global erlang 25.0.4; \
    asdf global elixir 1.13.4-otp-25; \
    asdf global nodejs 14.17.6;"

# Optional, you can delete this is if you want but I like it for testing with Wallaby
# Install Chrome WebDriver
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    sudo mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    sudo curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    sudo unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    sudo rm /tmp/chromedriver_linux64.zip && \
    sudo chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    sudo ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Again, optional, the second step of the chrome stuff for wallaby testing
# Install Google Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/google-chrome.list && \
    sudo apt-get -yqq update && \
    sudo apt-get -yqq install google-chrome-stable && \
    sudo rm -rf /var/lib/apt/lists/*
    
# Feel free to set some ENV variables if you'd like them available, or you can set them in gitpod itself a few different ways. 
# See https://www.gitpod.io/docs/environment-variables

# An example env, no need to keep this
ENV ORIGINAL_AUTHOR_OF_THIS_DOCKERFILE="Carter Bryden"
