# MySQL можно запустить как службу, чтобы он работал в фоновом режиме:
- brew services start mysql
- brew services start postgresql
# Чтобы остановить MySQL, выполните:
- brew services stop mysql
- brew services stop postgresql

# Если вы хотите запустить MySQL только для текущей сессии терминала, используйте:
- mysql.server start
# для остановки текущей сессии
- mysql.server stop

# Чтобы проверить, работает ли MySQL, используйте команду:
- brew services list
- mysql.server status

# Для подключения к MySQL используйте команду:
- mysql -u root
# По умолчанию для root пользователя не настроен пароль. Если вы хотите задать пароль для пользователя root, выполните:
- ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_password';


