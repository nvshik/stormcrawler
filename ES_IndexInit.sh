ESHOST="http://localhost:9200"
ESCREDENTIALS="-u elastic:passwordhere"

# deletes and recreates a status index with a bespoke schema

curl $ESCREDENTIALS -s -XDELETE "$ESHOST/status/" >  /dev/null

echo "Deleted status index"

# http://localhost:9200/status/_mapping/status?pretty

echo "Creating status index with mapping"

curl $ESCREDENTIALS -s -XPUT $ESHOST/status -H 'Content-Type: application/json' -d '
{
	"settings": {
		"index": {
			"number_of_shards": 10,
			"number_of_replicas": 1,
			"refresh_interval": "5s"
		}
	},
	"mappings": {
			"dynamic_templates": [{
				"metadata": {
					"path_match": "metadata.*",
					"match_mapping_type": "string",
					"mapping": {
						"type": "keyword"
					}
				}
			}],
			"_source": {
				"enabled": true
			},
			"properties": {
				"key": {
					"type": "keyword",
					"index": true
				},
				"nextFetchDate": {
					"type": "date",
					"format": "dateOptionalTime"
				},
				"status": {
					"type": "keyword"
				},
				"url": {
					"type": "keyword"
				}
			}
	}
}'


# deletes and recreates a doc index with a bespoke schema

curl $ESCREDENTIALS -s -XDELETE "$ESHOST/content*/" >  /dev/null

echo ""
echo "Deleted content index"

echo "Creating content index with mapping"

curl $ESCREDENTIALS -s -XPUT $ESHOST/content -H 'Content-Type: application/json' -d '
{
	"settings": {
		"index": {
			"number_of_shards": 5,
			"number_of_replicas": 1,
			"refresh_interval": "60s"
		}
	},
	"mappings": {
			"_source": {
				"enabled": true
			},
			"properties": {
				"content": {
					"type": "text",
					"index": "true",
					"store": true
				},
				"host": {
					"type": "keyword",
					"index": "true",
					"store": true
				},
				"title": {
					"type": "text",
					"index": "true",
					"store": true
				},
				"url": {
					"type": "keyword",
					"index": "false",
					"store": true
				}
			}
	}
}'
