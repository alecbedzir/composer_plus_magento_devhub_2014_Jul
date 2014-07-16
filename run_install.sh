#!/bin/sh

########
#
# This script should be run in project root dir
# 
# Things to check before you execute:
#
# 1) for step 4 ensure you've specified your valid user/password for mysql
# 2) for step 4 ensure 'magento_composer' DB is not in your mysql already
# 3) for step 4 ensure 'magento_user' is not in your mysql already
# Note, if you change anything in step 4 - be sure to change it in step 6 as well
# 
# Expected result:
# Magento is deployed and installed with base_url: http://magento-composer.lo
#
########

echo '=====> 1. Disabling my local custom composer config and flushing composer cache'
mv ~/.composer/config.json ~/.composer/_config.json
#rm -rf ~/.composer/cache

echo '=====> 2. Installing of composer'
mkdir bin
curl -s https://getcomposer.org/installer | php -- --install-dir=bin

echo '=====> 3. Installing magento files via composer'
php ./bin/composer.phar -n install

echo '=====> 4. Creating DB, user and granting permissions'
mysql -u root -p123456 -e " \
	CREATE DATABASE magento_composer CHARACTER SET utf8 COLLATE utf8_general_ci; \
	CREATE USER magento_user@127.0.0.1 IDENTIFIED BY '123456'; \
	GRANT ALL ON magento_composer.* TO magento_user@127.0.0.1; \
"

echo '=====> 5. Preprating the file system'
chmod -R 777 ./htdocs/app/etc
chmod -R 777 ./htdocs/var
chmod -R 777 ./htdocs/media

echo '=====> 6. Finalising magento installation: triggering install.php from CLI'
php -f ./htdocs/install.php -- --license_agreement_accepted yes \
   --locale en_US --timezone "America/Los_Angeles" --default_currency USD \
   --db_host 127.0.0.1 --db_name magento_composer --db_user magento_user \
   --db_pass 123456 --db_prefix magento_ \
   --url "http://magento-composer.lo" --use_rewrites yes \
   --use_secure yes --secure_base_url "http://magento-composer.lo" \
   --use_secure_admin yes \
   --admin_lastname Owner --admin_firstname Store \
   --admin_email "admin@example.com" \
   --admin_username admin --admin_password qwerty_123 \
   --encryption_key "Encryption Key"