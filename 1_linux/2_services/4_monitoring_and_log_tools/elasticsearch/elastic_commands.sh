#show indeces
# https://stackoverflow.com/questions/17426521/list-all-indexes-on-elasticsearch-server
curl http://10.8.152.114:9200/_aliases?pretty=true
curl http://10.8.152.114:9200/_cat/indices?v
curl http://10.8.152.114:9200/_status?pretty=true

#delete indices
docker exec -it nginx bash
curl -XGET http://elasticsearch:9200/_cat/indices | sort
curl -XDELETE http://elasticsearch:9200/syst-log-20221111
# or all indices(logs) by pattern
curl -XDELETE http://elasticsearch:9200/syst-log-*
