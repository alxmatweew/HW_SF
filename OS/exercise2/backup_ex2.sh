#Создание папки для backup, если нет
mkdir -p /archive

#Создание backup
tar cfW /archive/backup-"`date '+%d-%B-%Y'`".tar --directory / /etc/ssh /etc/vsftpd.conf /etc/xrdp /home/xal /var/log

#Проверка backup-а и создание лог-файла этго процесса
tar tf /archive/backup-"`date '+%d-%B-%Y'`".tar > /archive/verify.log
