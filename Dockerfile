FROM nixos/nix:latest

## Install some nice things
RUN nix-channel --update && \
    nix-env -iA nixpkgs.zsh \
    nixpkgs.oh-my-zsh \
    nixpkgs.git \
    nixpkgs.gh \
    nixpkgs.pre-commit \
    nixpkgs.circleci-cli \
    nixpkgs.gcc \
    nixpkgs.gnused \
    nixpkgs.gnumake \
    nixpkgs.powerline-fonts && \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv

RUN cd ~/.pyenv && src/configure && make -C src

ADD .dotfiles/ .dotfiles/

RUN chown -R $USER:$USER .dotfiles/ && \
    git clone https://github.com/zsh-users/zsh-autosuggestions $(nix-env -q --out-path oh-my-zsh| cut -d' ' -f3)/share/oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/romkatv/powerlevel10k.git $(nix-env -q --out-path oh-my-zsh| cut -d' ' -f3)/share/oh-my-zsh/custom/themes/powerlevel10k && \
    ln -s /.dotfiles/.zshrc ~/.zshrc && \
    ln -s /.dotfiles/.p10k.zsh ~/.p10k.zsh && \
    zsh -i /dev/null >/dev/null

CMD ["/usr/bin/env", "zsh"]