GRANT ALL ON *.* TO 'admin'@'%' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'admin'@'127.0.0.1' WITH GRANT OPTION;
SET PASSWORD FOR 'admin'@'%'= PASSWORD('centbox');
SET PASSWORD FOR 'admin'@'127.0.0.1' = PASSWORD('centbox');
FLUSH PRIVILEGES;
