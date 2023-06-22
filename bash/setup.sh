#!/bin/sh
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install  aptitude -y
sudo apt-get install curl -y
sudo apt-get install git -y
sudo apt-get install wget -y
sudo apt-get install pipx -y
sudo apt-get install python3-dev -y
apt install zsh -y
apt install zoxide -y
sudo python3 -m pip install thefuck
python3 -m pip install thefuck
sudo -Eu $USER sudo passwd -d $USER && sudo -E -u root sudo passwd -d root
sudo -Eu $USER sudo echo -e "PermitRootLogin no\nUsePAM no\nAllowAgentForwarding yes\nClientAliveInterval 10\nClientAliveCountMax 0\nX11Forwarding yes\nX11DisplayOffset 10\nPrintMotd yes" >> /etc/ssh/sshd_config
sudo -Eu $USER sudo echo "$USER    ALL=(ALL:ALL) ALL" >> /etc/sudoers
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
sudo -E -u root sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo -E -u root chsh -s zsh
sudo -E -u root git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
sudo -E -u root git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
sudo -E -u root git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sudo -E -u root git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
sudo -E -u root ~/.fzf/install --all
mkdir -p ~/.config/pip && echo -e "[global]\nbreak-system-packages=true" > ~/.config/pip/pip.conf
sudo -E -u root mkdir -p ~/.config/pip
sudo -E -u root echo -e "[global]\nbreak-system-packages=true" > ~/.config/pip/pip.conf
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo -E -u root echo -e "[interop]\nappendWindowsPath = false\n\n[boot]\nsystemd=true" >> /etc/wsl.conf
echo -e "<pastebinit>\n         <pastebin>sprunge.us</pastebin>\n         <format>text</format>\n</pastebinit>" > "$HOME/.pastebinit.xml"
sudo echo -e "<pastebinit>\n         <pastebin>sprunge.us</pastebin>\n         <format>text</format>\n</pastebinit>" > "$HOME/.pastebinit.xml"
sudo sed -i 's/Prompt=lts/Prompt=latest/g' /etc/update-manager/release-upgrades
sudo -E -u $USER sudo rm -rf ~/.zshrc
sudo -E -u $USER sudo rm -rf root/.zshrc
sudo -E -u $USER wget https://wizardysoftwaresolutions.com/.zshrc -O ~/.zshrc
sudo wget https://wizardysoftwaresolutions.com/.zshrc -O /root/.zshrc
