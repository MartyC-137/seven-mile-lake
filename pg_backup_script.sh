# Container must be running
docker exec -t postgis pg_dump -U postgres -F c -b -v postgres > ~/pg_backup_$(date +%Y_%m_%d).backup