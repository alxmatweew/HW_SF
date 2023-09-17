#!/bin/bash

# 1. Проверка и установка (если еще не установле) репозитория backports
echo;echo
echo "   [ Проверка и установка (если еще не установле) репозитория backports ... ]"
echo

if grep -qe "^deb.*`lsb_release -a 2>/dev/null|grep Codename|awk '{print $2}'`-backports" /etc/apt/sources.list; then
    echo "Репозиторий backports уже есть в /etc/apt/sources.list"
elif grep -qe "^#.*deb http.*`lsb_release -a 2>/dev/null|grep Codename|awk '{print $2}'`-backports" /etc/apt/sources.list; then
    echo "Этот репозиторий присутствует в /etc/apt/sources.list, но закоментирован, а значит лучше его раскоментировать самостоятельно вручную!"
else
    echo "Репозитория backports нет в /etc/apt/sources.list"
    echo "deb http://ru.archive.ubuntu.com/ubuntu/ `lsb_release -a 2>/dev/null|grep Codename|awk '{print $2}'`-backports main restricted universe multiverse" >> /etc/apt/sources.list
fi


#2. Обновить данные пакетного менеджера
echo;echo
echo "   [ Обновление данные пакетного менеджера ...]"
echo
#apt-get update


#3. Установка Apache2
echo;echo
echo "   [ Установка Apache2 ... ]"
echo
apt-get install apache2 -y
systemctl enable apache2
echo "`systemctl status apache2`"


#4. Проверка и установка python3
echo;echo
echo "   [ Установка python ... ]"
echo
if [[ -n "`python3 --version 2>/dev/null`" ]]; then
echo "python3 уже есть в системе!"
else
echo "python3 нет в системе"
apt-get install python3
fi

#5. Установка ssh-сервера
echo;echo
echo "   [ Установка SSH ... ]"
echo
apt-get install ssh -y
systemctl enable ssh
echo "`systemctl status ssh`"

#6. Установка nano
echo;echo
echo "   [ Установка nano ... ]"
echo
apt-get install nano -y

#7. Настройка nano редактором по-умолчанию для окружения пользователя xal
echo;echo
echo "   [ Настройка nano редактором по-умолчанию для окружения пользователя xal ... ]"
echo
if grep -qi editor= /home/xal/.bashrc; then
    sed -i 's/EDITOR=.*/EDITOR=nano/' /home/xal/.bashrc
else
    echo "EDITOR=nano">>/home/xal/.bashrc
fi

#8. Настройка подсветки nano для пользователя xal
echo;echo
echo "   [ Настройка подсветки nano для пользователя xal ... ]"
echo
find /usr/share/nano/ -iname "*.nanorc" -exec echo include {} \; >> /home/xal/.nanorc

#9. Замена значения клавиши Pause на Insert (у меня на буке нет отдельного Ins)
echo;echo
echo "   [ Замена значения клавиши Pause на Insert ... ]"
echo
echo "keycode 77 = Insert NoSymbol Insert NoSymbol Insert" > /home/xal/.Xmodmap
xmodmap /home/xal/.Xmodmap
chown xal:xal /home/xal/.Xmodmap

#10. Закрепление маппинга клавишь в конфиге .bashrc
if grep -i xmodmap /home/xal/.bashrc; then
    echo "xmodmap +"
else
    echo "xmodmap /home/xal/.Xmodmap">>/home/xal/.bashrc
fi