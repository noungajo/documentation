#!/bin/bash
mysql -h 192.168.100.31 -u root -P 3307 < ./db.sql
alembic upgrade head
mysql -h 192.168.100.31 -u root -P 3307 musique<./data.sql
exit 0