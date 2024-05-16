#!/usr/bin/bash

# sudo gpasswd --add $USER input

mkdir -p $HOME/.config/systemd/user
mkdir -p $HOME/.local/bin

cp ./watch_tablet "$HOME/.local/bin/"
cp ./watch_tablet.yml "$HOME/.config/"

WATCH_TABLET_SCRIPT="$HOME/.local/bin/watch_tablet"

chmod +x $WATCH_TABLET_SCRIPT

# handle for SE linux on Bazzite
sudo chcon -u system_u -r object_r --type=bin_t $WATCH_TABLET_SCRIPT

systemctl --user disable --now watch-tablet

cat << EOF >> "./watch-tablet.service"
[Unit]
Description=watch for tablet mode + game mode changes

[Service]
Type=oneshot
WorkingDirectory=/var/home/$USER/.local/bin/
ExecStart=$WATCH_TABLET_SCRIPT

[Install]
WantedBy=default.target
EOF

mv ./watch-tablet.service $HOME/.config/systemd/user

systemctl --user daemon-reload
systemctl --user enable watch-tablet.service