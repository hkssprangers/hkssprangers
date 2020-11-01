set -ev
mysql --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" hkssprangers < dev/initdb/001_structure.sql
mysql --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" hkssprangers < dev/initdb/002_data_courier.sql
mysql --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" hkssprangers < dev/initdb/003_data.sql
