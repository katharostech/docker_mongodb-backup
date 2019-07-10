#!/bin/bash

backup_cmd="mongodump --host $MONGO_HOST --port $MONGO_PORT --archive=/backup/db-backup.archive.gz --gzip || $FAILURE_HOOK"

echo "#!/bin/bash" > /run-backup.sh
echo "$backup_cmd" > /run-backup.sh

if [ "$INIT_BACKUP" = "true" ]; then
    echo "Running Init Backup"
    bash /run-backup.sh
fi

# Create cron job
echo "$CRON_SCHEDULE bash /run-backup.sh" > /cron-jobs.txt

# Start Cron
exec supercronic /cron-jobs.txt

