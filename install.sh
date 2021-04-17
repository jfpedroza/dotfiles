#!/usr/bin/bash
set -euo pipefail

installUbuntuPackages() {
    echo "==================================="
    echo "Installing Ubuntu packages..."
    echo "==================================="

    # Temporary aliases
    apti='sudo apt --assume-yes install'

    # Updating the index
    sudo apt-get update

    cd ~/ || return

    echo "Installing packages with APT"

    xargs <~/dotfiles/packages/ubuntu.txt $apti

    # NodeJS
    curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
    $apti nodejs

    # Erlang & Elixir
    wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb &&
        sudo apt-get update &&
        $apti esl-erlang &&
        $apti elixir

    # Windscribe
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key FDC247B7
    echo 'deb https://repo.windscribe.com/ubuntu bionic main' | sudo tee /etc/apt/sources.list.d/windscribe-repo.list
    sudo apt-get update && $apti windscribe-cli
}

installManjaroPackages() {
    echo "==================================="
    echo "Installing Manjaro packages..."
    echo "==================================="

    # Temporary aliases
    pmi='sudo pacman -S --noconfirm --needed --quiet'
    yai='yay -S --noconfirm --needed --quiet'

    # Switch to testing branch
    sudo pacman-mirrors --api --set-branch testing
    sudo pacman-mirrors --fasttrack 5

    # Perform a full upgrade
    sudo pacman -Syyu

    echo "Installing packages with Pacman"
    $pmi - <~/dotfiles/packages/pacman.txt

    sudo pacman -S --quiet pulseaudio-modules-bt <<<"y
    y"

    mkdir -p ~/builds
    cd ~/builds
    [ ! -d yay ] && git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm --needed
    cd ~

    # Install packages with Yay
    echo "Installing AUR packages with Yay:"

    $yai - <~/dotfiles/packages/aur.txt

    sudo systemctl enable windscribe &&
        sudo systemctl start windscribe

    systemctl --user enable spotifyd
}

installSnapPackages() {
    echo "==================================="
    echo "Installing Snap packages..."
    echo "==================================="

    case $os in
    Ubuntu*)
        sudo snap install opera
        sudo snap install spotify
        sudo snap install insomnia
        sudo snap install postman
        sudo snap install intellij-idea-community --classic
        sudo snap install discord
        sudo snap install slack --classic
        sudo snap install sublime-text --classic
        sudo snap install --edge uget
        sudo snap install hub --classic
        sudo snap install vlc
        sudo snap install gnome-easytag
        sudo snap install gitkraken
        sudo snap install gimp
        sudo snap install android-studio --classic &&
            $apti libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
        ;;

    Manjaro*) ;;

    \
        *)
        echo "Unknown OS. Exiting..."
        exit 1
        ;;
    esac
}

installAndConfigureDocker() {
    echo "==================================="
    echo "Installing and configuring Docker..."
    echo "==================================="

    case $os in
    Ubuntu*)
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
            sudo add-apt-repository -y \
                "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
                            $(lsb_release -cs) \
                            stable" &&
            sudo apt-get update && $apti docker-ce
        ;;

    Manjaro*)
        sudo systemctl enable docker &&
            sudo systemctl start docker
        ;;

    *)
        echo "Unknown OS. Exiting..."
        exit 1
        ;;
    esac

    sudo docker run hello-world &&
        sudo usermod -aG docker "$USER"
}

installNpmPackages() {
    echo "==================================="
    echo "Installing global npm packages"
    echo "typescript-formatter"
    echo "fixjson"
    printf "\nInstalling global yarn packages\n"
    echo "diagnostic-languageserver"
    echo "==================================="

    cd ~/ || return

    sudo npm i -g typescript-formatter markdownlint-cli fixjson
    yarn global add diagnostic-languageserver
}

installLanguages() {
    echo "==================================="
    echo "Installing python, rust and haskell..."
    echo "==================================="

    # pipi='pip install --upgrade'
    pipu='pip install --user --upgrade'
    pip2u='pip2 install --user --upgrade'

    # Python & PIP

    # pip_packages=''

    # echo "Installing the following PIP packages in the system: $pip_packages"

    # Installing packages
    # sudo $pipi $pip_packages

    pip_user_packages='
    ipython
    pynvim
    vcspull
    autopep8
    pylint
    jedi
    taskwarrior-inthe.am
    git+git://github.com/robgolding/tasklib@develop
    vit'

    echo "Installing the following PIP packages for the current user: $pip_user_packages"

    # Installing packages
    $pipu $pip_user_packages

    pip2_user_packages='
    pynvim'

    echo "Installing the following PIP2 packages for the current user: $pip2_user_packages"

    # Installing packages
    $pip2u $pip2_user_packages

    # Rust & Cargo
    rustup toolchain install nightly
    rustup default nightly
    rustup install nightly-2016-08-01
    rustup run nightly-2016-08-01 cargo install --git https://github.com/murarth/rusti
    rustup component add rustfmt rls rust-analysis rust-src
    cargo install just

    # Haskell & Stack
    stack install hlint apply-refact hindent hoogle
    ~/.local/bin/hoogle generate

    # Go packages
    go get github.com/edi9999/path-extractor/path-extractor

    # Ruby gem
    gem install solargraph irb
}

installFonts() {
    echo "==================================="
    echo "Installing fonts..."
    echo "==================================="

    cd ~/ || return

    # Console fonts
    git clone https://github.com/powerline/fonts.git &&
        cd fonts &&
        ./install.sh &&
        cd .. &&
        rm -rf fonts

    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts && curl -fLo "Noto Mono Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Noto/Mono/complete/Noto%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
}

cloneDotfiles() {
    echo "==================================="
    echo "Cloning dotfiles"
    echo "==================================="

    cd ~/ || return

    if [[ ! -f ~/.ssh/id_rsa ]]; then
        echo "SSH key not found"
        exit 1
    fi

    git clone --recurse-submodule git@github.com:johnf9896/dotfiles.git
    cd dotfiles
    ./dotfiles.sh
}

setupVim() {
    echo "==================================="
    echo "Setting up vim and neovim"
    echo "==================================="

    cd ~/ || return

    # Vim-plug for Vim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Vim-plug for NeoVim
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    nvim +PlugInstall +qall
    vim +PlugInstall +qall

    ln -sf ~/Cloud/vimwiki ~/vimwiki
}

useZsh() {
    echo "==================================="
    echo "Setting ZSH as default shell"
    echo "==================================="

    cd ~/ || return

    chsh -s "$(command -v zsh)"
    REPO=johnf9896/oh-my-zsh sh -c "$(curl -fsSL https://raw.github.com/johnf9896/oh-my-zsh/master/tools/install.sh)"

    zsh_custom=~/.oh-my-zsh/custom

    mkdir -p ~/.zsh/completion
    curl -L https://raw.githubusercontent.com/docker/compose/1.29.1/contrib/completion/zsh/_docker-compose >~/.zsh/completion/_docker-compose
    curl -L https://raw.githubusercontent.com/github/hub/master/etc/hub.zsh_completion >~/.zsh/completion/_hub

    cd ~/.oh-my-zsh
    git remote set-url origin git@github.com:johnf9896/oh-my-zsh.git

    # FZF extras
    git clone https://github.com/atweiden/fzf-extras.git ~/.fzf-extras
    cd ~/.fzf-extras || return
    git checkout zsh

    # Forgit
    git clone https://github.com/wfxr/forgit.git $zsh_custom/plugins/forgit

    cd ~/dotfiles
    ./dotfiles.sh
}

setupScriptfs() {
    echo "==================================="
    echo "Cloning and building scriptfs"
    echo "==================================="

    mkdir -p ~/code/lib
    git clone git@github.com:johnf9896/scriptfs.git ~/code/lib/scriptfs
    cd ~/code/lib/scriptfs
    make
    sudo cp scriptfs /usr/bin/scriptfs
}

createSymlinks() {
    echo "==================================="
    echo "Creating PCloud Symlinks"
    echo "==================================="

    cd ~/ || return

    sudo mkdir /media
    sudo chown "$USER" /media
    mkdir -p Programming

    # pCloud Symlinks
    ln -s ~/Cloud/Documents ~/Documents/Cloud
    ln -s ~/Cloud/Pictures ~/Pictures/Cloud
    ln -s ~/Cloud/Programming ~/Programming/Cloud
}

install() {
    echo "==================================="
    echo "Beginning Installation..."
    echo "==================================="

    os=$(lsb_release -d | cut -f2)

    cloneDotfiles

    case $os in
    Ubuntu*)
        installUbuntuPackages
        ;;

    Manjaro*)
        installManjaroPackages
        ;;

    *)
        echo "Unknown OS. Exiting..."
        exit 1
        ;;
    esac

    sudo mv /usr/bin/ksplashqml /usr/bin/ksplashqml.old

    installSnapPackages
    installAndConfigureDocker
    installNpmPackages
    installLanguages
    installFonts
    setupVim
    useZsh
    setupScriptfs
    createSymlinks
}

install

# Changes in sudoers file with sudo -E visudo:
# Defaults passwd_timeout=0
# Defaults timestamp_timeout=30
