wget -O shakespeare.json https://download.elastic.co/demos/kibana/gettingstarted/shakespeare_6.0.json
wget -O accounts.zip https://download.elastic.co/demos/kibana/gettingstarted/accounts.zip
wget -O logs.jsonl.gz https://download.elastic.co/demos/kibana/gettingstarted/logs.jsonl.gz
unzip accounts.zip
gunzip logs.jsonl.gz
curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/bank/account/_bulk?pretty' --data-binary @accounts.json
curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/shakespeare/doc/_bulk?pretty' --data-binary @shakespeare_6.0.json
curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/_bulk?pretty' --data-binary @logs.jsonl
