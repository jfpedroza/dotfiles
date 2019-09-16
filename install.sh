set -e

installUbuntuPackages() {
    echo "==================================="
    echo "Installing Ubuntu packages..."
    echo "==================================="

    # Temporary aliases
    apti='sudo apt --assume-yes install'

    # Updating the index
    sudo apt-get update

    cd ~/ || return

    packages='
    git
    wget
    build-essential
    cmake
    libssl-dev
    python-dev
    xclip
    zsh
    vim
    vim-gnome
    neovim
    php
    apt-transport-https
    ca-certificates
    curl
    software-properties-common
    python-pip
    mysql-workbench
    dconf-editor
    net-tools
    ttf-ancient-fonts
    tmux
    the_silver_searcher
    postgresql
    xdotool
    shellcheck
    mc
    ruby
    httpie
    zsh-syntax-highlighting'

    echo "Installing the following packages: $packages"

    # Installing packages
    $apti $packages

    # NodeJS
    curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
    $apti nodejs

    # Erlang & Elixir
    wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb &&
        sudo apt-get update &&
        $apti esl-erlang &&
        $apti elixir
}

installManjaroPackages() {
    echo "==================================="
    echo "Installing Manjaro packages..."
    echo "==================================="

    # Temporary aliases
    pmi='sudo pacman -S --noconfirm --needed --quiet'
    yai='yay -S --noconfirm --needed --quiet'

    # Perform a full upgrade
    sudo pacman -Syyu

    # Install with pacman
    packages='
    base-devel
    unzip
    xclip
    cmake
    zsh
    vim
    neovim
    php
    python-pip
    mysql-workbench
    net-tools
    bat
    nodejs
    npm
    shellcheck
    docker
    postgresql
    postgis
    gimp
    fd
    tmux
    gdb
    gparted
    xdotool
    clang
    cppcheck
    mc
    ruby
    go
    httpie
    zsh-syntax-highlighting
    expac
    xorg-xev
    firefox-developer-edition
    the_silver_searcher
    dos2unix'

    echo "Installing the following packages: $packages"

    # Installing packages
    $pmi $packages

    mkdir -p ~/builds
    cd ~/builds
    [ ! -d yay ] && git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm --needed
    cd ~

    # Install with Yay
    aur_packages='
    spotify
    insomnia
    postman-bin
    dbeaver-ce
    discord
    slack-desktop
    sublime-text-dev
    gitkraken
    pcloud-drive
    ttf-ancient-fonts
    gitflow-avh
    gitflow-zshcompletion-avh
    musixmatch-bin
    franz-bin
    visual-studio-code-insiders
    anydesk
    ngrok'

    echo "Installing the following AUR packages: $aur_packages"

    # Installing packages
    $yai $aur_packages
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
        sudo snap install skype --classic
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

    sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
        sudo chmod +x /usr/local/bin/docker-compose
}

configurePostgres() {
    echo "==================================="
    echo "Installing and configuring Postgresql..."
    echo "==================================="

    case $os in
    Ubuntu*) ;;

    \
        Manjaro*)
        sudo -u postgres initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'
        sudo systemctl enable postgresql &&
            sudo systemctl start postgresql
        ;;

    *)
        echo "Unknown OS. Exiting..."
        exit 1
        ;;
    esac
}

installNpmPackages() {

    echo "==================================="
    echo "Installing global npm packages"
    echo "@vue/cli"
    echo "typescript-formatter"
    echo "==================================="

    cd ~/ || return

    sudo npm i -g @vue/cli
    sudo npm i -g typescript-formatter
}

installLanguages() {
    echo "==================================="
    echo "Installing python, rust and haskell..."
    echo "==================================="

    # Python & PIP
    sudo pip install --upgrade pip
    sudo pip install virtualenv
    pip install --user --upgrade ipython
    pip install --user --upgrade pynvim
    pip install --user --upgrade vcspull
    pip install --user --upgrade autopep8

    # Rust & Cargo
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly
    # shellcheck source=/dev/null
    source ~/.cargo/env
    rustup toolchain install nightly
    rustup install nightly-2016-08-01
    rustup run nightly-2016-08-01 cargo install --git https://github.com/murarth/rusti
    rustup component add rustfmt
    cargo install exa
    cargo install just

    # Haskell & Stack
    curl -sSL https://get.haskellstack.org/ | sh

    # Go packages
    go get github.com/edi9999/path-extractor/path-extractor
    go get -u mvdan.cc/sh/cmd/shfmt
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
}

cloneDotfiles() {
    echo "==================================="
    echo "Cloning dotfiles"
    echo "==================================="

    cd ~/ || return

    git clone https://github.com/johnf9896/dotfiles.git
    cd dotfiles
    git remote set-url origin git@github.com:johnf9896/dotfiles.git

    # Symlink keyboard modifations
    ln -sf ~/dotfiles/Xmodmap ~/.Xmodmap
}

setupGit() {
    echo "==================================="
    echo "Setting up git"
    echo "==================================="

    ln -sf ~/dotfiles/global.gitignore ~/.gitignore
    git config --global user.name 'Jhon Pedroza'
    git config --global user.email 'jhonfpedroza@gmail.com'
    git config --global core.excludesfile '~/.gitignore'
    ln -sf ~/dotfiles/vcspull.yaml ~/.vcspull.yaml
}

setupVim() {
    echo "==================================="
    echo "Setting up vim and neovim"
    echo "==================================="

    cd ~/ || return

    # Link rc files
    ln -sf ~/dotfiles/vimrc.vim ~/.vimrc
    mkdir -p ~/.config/nvim
    ln -sf ~/dotfiles/neovim.vim ~/.config/nvim/init.vim

    # Let's sneak this in here
    ln -sf ~/dotfiles/tridactylrc ~/.tridactylrc

    # Vim-plug for Vim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Vim-plug for NeoVim
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    nvim +PlugInstall +qall
    vim +PlugInstall +qall
}

setupTmux() {
    echo "==================================="
    echo "Linking tmux config"
    echo "==================================="

    cd ~/ || return

    touch ~/.tmux.conf
    ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
}

installScripts() {
    echo "==================================="
    echo "Installing scripts"
    echo "==================================="

    bin=~/.local/bin
    mkdir -p $bin
    cd ~/dotfiles

    while IFS= read -r -d '' script; do
        ln -fs -- "$(pwd)/$script" "$bin"
    done < <(find bin -type f -perm -+x -print0)
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
    curl -L https://raw.githubusercontent.com/docker/compose/1.23.2/contrib/completion/zsh/_docker-compose >~/.zsh/completion/_docker-compose

    cd ~/.oh-my-zsh
    git remote set-url origin git@github.com:johnf9896/oh-my-zsh.git

    ln -sf ~/dotfiles/zshrc ~/.zshrc
    ln -sf ~/dotfiles/aliases.sh $zsh_custom/aliases.zsh
    ln -sf ~/dotfiles/shortcuts.zsh $zsh_custom/shortcuts.zsh

    # FZF extras
    git clone https://github.com/atweiden/fzf-extras.git ~/.fzf-extras
    cd ~/.fzf-extras || return
    git checkout zsh

    # Forgit
    git clone https://github.com/wfxr/forgit.git $zsh_custom/plugins/forgit
}

setupSsh() {
    echo "==================================="
    echo "Setting SSH key"
    echo "==================================="

    ssh-keygen -t rsa -b 4096
}

createSymlinks() {
    echo "==================================="
    echo "Creating PCloud Symlinks"
    echo "==================================="

    cd ~/ || return

    sudo mkdir /media
    sudo chown "$USER" /media
    mkdir -p Programming
    mkdir -p Work/Peiky
    mkdir -p Work/MMLabs

    # pCloud Symlinks
    ln -sf /media/data/Cloud ~/Cloud
    ln -s ~/Cloud/Documents ~/Documents/Cloud
    ln -s ~/Cloud/Pictures ~/Pictures/Cloud
    ln -s ~/Cloud/Programming ~/Programming/Cloud
    ln -s ~/Cloud/Work/MMLabs ~/Work/MMLabs/Cloud
    ln -s ~/Cloud/Work/Peiky ~/Work/Peiky/Cloud
    ln -s ~/Cloud/Work/Docs ~/Work/Docs
}

install() {
    echo "==================================="
    echo "Beginning Installation..."
    echo "==================================="

    os=$(lsb_release -d | cut -f2)

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

    installSnapPackages
    installAndConfigureDocker
    configurePostgres
    installNpmPackages
    installLanguages
    installFonts
    cloneDotfiles
    setupGit
    setupVim
    setupTmux
    installScripts
    useZsh
    setupSsh
    createSymlinks
}

install

# Changes in sudoers file with sudo -E visudo:
# Defaults passwd_timeout=0
# Defaults timestamp_timeout=30
