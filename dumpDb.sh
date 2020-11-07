set -ev
mysqldump --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --no-data --databases hkssprangers --add-drop-database | sed 's/ AUTO_INCREMENT=[0-9]*//g' > dev/initdb/001_structure.sql
mysqldump --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --no-create-db --no-create-info --skip-extended-insert hkssprangers flyway_schema_history > dev/initdb/002_flyway_schema_history.sql
mysqldump --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --no-create-db --no-create-info --skip-extended-insert hkssprangers courier > dev/initdb/003_data_courier.sql
mysqldump --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --no-create-db --no-create-info --skip-extended-insert hkssprangers --ignore-table=hkssprangers.flyway_schema_history --ignore-table=hkssprangers.courier > dev/initdb/004_data.sql
