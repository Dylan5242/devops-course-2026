Раздел 1 (параметры машины): таблица 2 методички — 2048 МБ, 2 ядра, 25 ГБ.



Раздел 2 (сеть): адаптер 1 — NAT, адрес 10.0.2.15, доступ в интернет; адаптер 2 — Host-only, адрес 192.168.56.101, доступ с хоста. (Уточни свои значения из ip -brief address.)



Раздел 3 (проброс портов): хост-порт 2222 → гостевой порт 2222 (после задания 2).



Раздел 4 (учётки): student — sudo, пароль; devops — sudo, SSH-ключ.



Раздел 5 (SSH): порт 2222, файл /etc/ssh/sshd\_config.d/99-hardening.conf, перечисли директивы, которые ты туда вписал.



Раздел 6 (UFW): default deny incoming / allow outgoing; правила: limit 2222/tcp, allow 80/tcp, allow 443/tcp.



Раздел 7 (снимки): 01-clean-install, 02-keys-configured, 03-ssh-hardened


## 8. Веб-сервер
- Устанавливаемый пакет: nginx
- Путь к конфигурации ресурса: /etc/nginx/sites-available/devops-site
- Каталог ресурса: /var/www/devops-site, владелец devops:devops, права 755 (каталоги) и 644 (файлы)
- Сертификат: /etc/ssl/certs/devops.crt, права 644 (root:root)
- Закрытый ключ: /etc/ssl/private/devops.key, права 600 (root:root)
- Команда формирования сертификата: sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/devops.key -out /etc/ssl/certs/devops.crt -subj "/CN=devops.local" -addext "subjectAltName=DNS:devops.local"
- Срок действия сертификата: 365 дней
