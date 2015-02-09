#
DATE=`date +"%Y-%m-%d"`
pg_dump -x -O --exclude-table-data=admin_facebook_applications --exclude-table-data=fb_api_tokens poligaffes_production > poligaffes_production_$DATE.sql
gzip poligaffes_production_$DATE.sql

