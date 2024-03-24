# dotfiles

My dotfiles 

```console-session
curl -o- https://raw.githubusercontent.com/sixcare/dotfiles/main/init.sh | bash
```

## Install doas
```console-session
apt-get install doas
echo "permit persist $USER as root" > /etc/doas.conf
echo "permit persist :wheel as root" >> /etc/doas.conf
```
