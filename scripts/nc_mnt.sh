#! /usr/bin/bash

set -euo pipefail

log() {
    printf "\(°^°)/ $(date -Ins) » %s\n" "$1"
}

MNT_PATH=/mnt/nextcloud
BACKUP_PATH=$HOME/backups/nextcloud
BACKUP_FILE=$MNT_PATH/Tech/Sec/passwords.kdbx
BACKUP_NUMBERS=10

log "Check if $MNT_PATH is mounted"
if mount | grep -q $MNT_PATH; then
    log "$MNT_PATH is mounted, will not mount"
else
    log "It is not mounted. Mounting it. We might need your password"
    doas mount /mnt/nextcloud 
fi

log "Check if $BACKUP_PATH exists"
if [ ! -d "$BACKUP_PATH" ]; then
    log "$BACKUP_PATH does not exists. Creating it."
    mkdir -p "$BACKUP_PATH"
else
    log "It does exist. Proceeding"
fi

log "Checking number of backups"
if [ "$(find "$BACKUP_PATH" -name "*-passwords.kdbx.xz" -type f | wc -l)" -gt $BACKUP_NUMBERS ]; then
    log "There are more than $BACKUP_NUMBERS backup files. Removing excess."
    find "$BACKUP_PATH" -name "*-passwords.kdbx.xz" -type f -printf "%T@ %p\n" | sort -n | head -n -$BACKUP_NUMBERS | cut -d' ' -f2- | xargs -I {} rm -- "{}"
else
    log "Number of backups are less than $BACKUP_NUMBERS. We're good to go"
fi

log "Taking a backup"
TIMESTAMP=$(date +%Y%m%dT%H%M)
xz --compress --keep --check=crc64 --stdout "$BACKUP_FILE" > "$BACKUP_PATH/$TIMESTAMP-passwords.kdbx.xz"

log "Backup complete. $BACKUP_PATH/$TIMESTAMP-passwords.kdbx.xz created"

