mkdir firacode
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip
rm FiraCode.zip
cd ..
mv firacode /usr/share/fonts/
fc-cache -f -v
