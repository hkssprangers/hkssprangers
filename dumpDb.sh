set -ev
mysqldump --host="$MYSQL_ENDPOINT" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --databases hkssprangers --no-data > dev/initdb/001_structure.sql
