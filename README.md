# dotfiles

My dotfiles 


## Prerequisite 
### Install doas
```console-session
su
apt-get install doas
```
### Configure doas
```console-session
echo 'permit persist sixcare as root' >> /etc/doas.conf
echo "permit persist :wheel as root" >> /etc/doas.conf
```

## Run it
```console-session
git clone https://github.com/sixcare/dotfiles.git
cd dotfiles 
./init.sh
```
