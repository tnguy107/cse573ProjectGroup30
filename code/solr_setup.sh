solr-8.8.1/bin/solr start -c -p 8983 -s solr-8.8.1/example/cloud/node1/solr
solr-8.8.1/bin/solr start -c -p 7574 -s solr-8.8.1/example/cloud/node2/solr -z localhost:9983
solr-8.8.1/bin/solr create -c metamapData -s 2 -rf 2
solr-8.8.1/bin/solr create -c allData -s 2 -rf 2

curl -X POST -H 'Content-type:application/json' --data-binary '{"add-copy-field" : {"source":"*","dest":"_text_"}}' http://localhost:8983/solr/metamapData/schema
curl -X POST -H 'Content-type:application/json' --data-binary '{"add-copy-field" : {"source":"*","dest":"_text_"}}' http://localhost:8983/solr/allData/schema

solr-8.8.1/bin/post -c metamapData solr-8.8.1/example/MetamapResult.csv
solr-8.8.1/bin/post -c allData solr-8.8.1/example/stage1_scrapping.csv