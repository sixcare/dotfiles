# dotfiles

My dotfiles 

```console-session
curl -o- https://raw.githubusercontent.com/sixcare/dotfiles/main/init.sh | bash
```

## Install doas
```console-session
su
apt-get install doas
```
### Configure
```
echo 'permit persist sixcare as root' >> /etc/doas.conf
echo "permit persist :wheel as root" >> /etc/doas.conf
```
