# Back up the CockroachDB database into S3.
# Needs COCKROACH_HOST/PORT/USER/PASSWORD/DATABASE, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
db-backup-s3 s3_bucket="hkssprangers-dbbackup" s3_path="dbbackup":
    PGPASSWORD="$COCKROACH_PASSWORD" cockroach sql -e "BACKUP INTO 's3://{{s3_bucket}}/{{s3_path}}?AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}&AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}' AS OF SYSTEM TIME '-10s';"

# Back up the CockroachDB database into a local directory, via the cluster's userfile storage.
# Restore it into a local node started with --external-io-dir=<dir containing the backup>:
#   RESTORE FROM LATEST IN 'nodelocal://1/dbbackup';
# Needs COCKROACH_HOST/PORT/USER/PASSWORD/DATABASE.
db-backup-local dest="dump":
    #!/usr/bin/env bash
    set -euo pipefail
    export PGPASSWORD="$COCKROACH_PASSWORD"
    # userfile commands ignore COCKROACH_DATABASE, so pass the cluster routing id via options.
    url="postgresql://${COCKROACH_HOST}:${COCKROACH_PORT}?sslmode=verify-full&options=--cluster%3D${COCKROACH_DATABASE%.*}"
    # Echo commands from here on; the password stays out of the trace since it's only in PGPASSWORD.
    set -x
    cockroach sql --url "$url" -e "BACKUP INTO 'userfile:///dbbackup' AS OF SYSTEM TIME '-10s';"
    cockroach userfile get --url "$url" dbbackup "{{dest}}" > /dev/null
    cockroach userfile delete --url "$url" dbbackup > /dev/null
