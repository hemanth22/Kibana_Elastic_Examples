__New Version SQL Example__

```
POST /_sql?format=txt
{
  "query":""" 
  select "field", "field", "field", "field"  from "index-2019.05.20" where "field.keyword"='value' 
  or  "field"='value' or field = 'value'
  """
}
```


__SQL Sample__

```

GET /_xpack/sql?format=txt
{
  "query":""" 
  select "field", "field", "field", "field"  from "index-2019.05.20" where "field.keyword"='value' 
  or  "field"='value' or field = 'value'
  """
}

```

__FULL SQL:__

```
GET /_xpack/sql?format=txt
{
  "query":""" 
  select "field", "field", "field", "field"  from "index-2019.05.21" where field='value' or
  "field" = 'value' or
  field = 'value' or
  "field" = 'value' or
  "field"= 'value' or
  "field"= 'value' or
  "field"= 'value' or
  "field"= 'value'
  """
}
```

__FULL JSON__:

```
GET index-*/_search
{
    "from" : 0, "size" : 100,

    "query": {
        "bool": {
            "must": [
                {
                    "match_all": {}
                },
                {
                    "range": {
                        "@timestamp": {
                            "gte": "now/d",
                            "lte": "now",
                            "format": "epoch_millis"
                        }
                    }
                }
          ],
          "should": [
                {"match_phrase": {"field.keyword": {"query": "value"}}},
                {"match_phrase": {"field.keyword": {"query": "value"}}},
               {"match_phrase": {"field.keyword": {"query": "value"}}}, 
               {"match_phrase": {"field.keyword": {"query": "value"}}},
               {"match_phrase": {"field.keyword": {"query": "value"}}},
               {"match_phrase": {"field.keyword": {"query": "value"}}},
               {"match_phrase": {"field.keyword": {"query": "value"}}},
               {"match_phrase": {"field.keyword": {"query": "value"}}}
          ],
          "minimum_should_match" : 1,
          "boost" : 1.0
        }
    },
  "_source": ["field","field","field"]
}
```
