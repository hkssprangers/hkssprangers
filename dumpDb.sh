set -ev
mysqldump --host="$MYSQL_ENDPOINT" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --databases hkssprangers --no-data | sed 's/ AUTO_INCREMENT=[0-9]*//g' > dev/initdb/001_structure.sql
mysqldump --host="$MYSQL_ENDPOINT" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --databases hkssprangers --no-create-db --no-create-info > dev/initdb/002_data.sql
