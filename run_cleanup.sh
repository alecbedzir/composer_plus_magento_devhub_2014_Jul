#!/bin/sh

########
# Should be run in project root dir
########

echo '1. Removing composer.phar, folders and composer.lock file'
rm -rf ./bin
rm -rf ./vendor
rm -rf ./htdocs
rm composer.lock

echo '2. Deleting mysql DB and user'
mysql -u root -p123456 -e "DROP DATABASE magento_composer;"
mysql -u root -p123456 -e "DROP USER magento_user@127.0.0.1;"

echo '3. Returning back custom composer config.json if any'
mv ~/.composer/_config.json ~/.composer/config.json