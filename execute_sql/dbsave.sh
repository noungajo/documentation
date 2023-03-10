#!/bin/bash
mysql -h localhost -u root -p< ./db.sql
alembic upgrade head
mysql -h localhost -u root -p musique<./data.sql
exit 0