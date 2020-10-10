set -ev
mysqldump --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --no-data hkssprangers | sed 's/ AUTO_INCREMENT=[0-9]*//g' > dev/initdb/001_structure.sql
mysqldump --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --no-create-db --no-create-info --skip-extended-insert hkssprangers courier > dev/initdb/002_data_courier.sql
mysqldump --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --no-create-db --no-create-info --skip-extended-insert --ignore-table=hkssprangers.courier hkssprangers > dev/initdb/003_data.sql
