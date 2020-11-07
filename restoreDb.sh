set -ev
mysql --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" hkssprangers < dev/initdb/001_structure.sql
mysql --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" hkssprangers < dev/initdb/002_flyway_schema_history.sql
mysql --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" hkssprangers < dev/initdb/003_data_courier.sql
mysql --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" hkssprangers < dev/initdb/004_data.sql
