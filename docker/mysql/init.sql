CREATE DATABASE IF NOT EXISTS redvillage_test;
GRANT ALL PRIVILEGES ON redvillage_development.* TO 'redvillage'@'%';
GRANT ALL PRIVILEGES ON redvillage_test.* TO 'redvillage'@'%';
FLUSH PRIVILEGES; 