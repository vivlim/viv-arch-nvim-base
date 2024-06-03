FROM archlinux:latest

RUN pacman -Sy --noconfirm \
  && useradd -U -m -u 1000 vivlim \
# sudo
  && pacman -S sudo --noconfirm \
  && echo 'vivlim ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo \
# delete user's password so sudo won't prompt for it
  && passwd -d vivlim \
# basic tools
  && pacman-key --init \
  && pacman -S neovim git base base-devel iputils inotify-tools man-db tmux vi --noconfirm \
# install an aur helper
  # && cd /tmp \
  # && git clone https://aur.archlinux.org/yay.git \
  # && chown vivlim yay \
  # && cd yay \
  # && sudo -u vivlim makepkg -si --noconfirm \
  # && cd / \
  # && rm -rf /tmp/yay \
# clean cache
  && pacman -Scc --noconfirm

USER vivlim
# it would be better to do this for treesitter https://github.com/nvim-treesitter/nvim-treesitter/issues/2900#issuecomment-2094839493
RUN mkdir -p /home/vivlim/.config \
    && git clone https://github.com/vivlim/vimfiles.git /home/vivlim/.config/nvim -b neovim \
    && nvim --headless "+Lazy! install" +qa \
    && nvim --headless -c "TSInstallSync" -c 'sleep 20' -c 'qa'
CMD ["/usr/sbin/bash"]
