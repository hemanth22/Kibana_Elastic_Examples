ElasticSearch(ES) is a search engine based on Lucene. It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents. Elasticsearch is developed in Java and is released as open source under the terms of the Apache License.

Just as in my last article, where I gave an equivalent of SQL query in Solr: https://www.linkedin.com/pulse/solr-query-sql-amit-chandak, I will do the same for ES. ES provides a lot of flexibility and has an equivalent for complex SQL; we will try to explore some of those here.

It is assumed that you already have installed Elasticsearch and can run JSON Query using Kibana Dev tools or any other methods(Curl,etc..).

Let us start with a table "transactions" with columns-price (number), color (varchar), make(varchar), sold(date).

Insert the sample Elastic data into "transactions" folder. The command to search data is: GET /transactions/_search

1) Select All

SQL Query: Select * from transactions

ES Query: {  "query": {"match_all": {} } }

2) Select a filter. Color: red. There are simpler versions than this but to keep the queries consistent, I have used the following format. Must is alternate of "and" in SQL and will play a role when we have more than one filter.

SQL Query : Select * from transactions where color = 'red'

ES Query: { "query":{ "constant_score" : {"filter":{ "bool":{"must" :[{ "term": { "color": "red" } } ] }} } }}

3) Select using a filter, with more than one value. Color: red, green.

SQL Query : Select * from transactions where color in ('red','green') and

ES Query: { "query":{ "constant_score" : {"filter":{ "bool":{"must" :[{ "terms": { "color": ["red","green"] } },{ "terms": { "make": ["ford","honda"] } } ] }} } }}

4) Multiple filters Boolean AND: "And" in SQL and "Must" in ES

SQL Query: Select * from transactions where color in ('red','green') and make in ('ford','honda')

ES Query: { "query":{ "constant_score" : {"filter":{ "bool":{"must" :[{ "terms": { "color": ["red","green"] } },{ "terms": { "make": ["ford","honda"] } } ] }} } }}

5) Two filters Boolean OR. "OR" in SQL , "Should" in ES

SQL Query: Select * from transactions where (color in ('red','green') or make in ('ford','honda'))

ES Query: { "query":{ "constant_score" : {"filter":{ "bool":{"should" :[{ "terms": { "color": ["red","green"] } },{ "terms": { "make": ["ford","honda"] } } ] }} } }}

6) Date filter

SQL Query:Select * from transactions where (color in ('red','green') and make in ('ford','honda')) and sold between '2014-01-01' and '2014-12-31'

ES Query: { "query":{ "constant_score" : {"filter":{ "bool":{"must" :[{ "terms": { "color": ["red","green"] } },{ "terms": { "make": ["ford","honda"] } } ] ,"filter" :[{ "range" : { "sold" : { "gte" : "2014-01-01", "lte" : "2014-12-31" } } } ] }} } }}

7) Data Aggregation. size:0 has been used to get only aggreated data.

SQL Query: Select sum(price) single_sum_price":, avg(price) single_avg_price from transactions

ES Query: { "size" : 0,   "aggs" : {"single_avg_price": { "avg" : { "field" : "price" }}, "single_sum_price": {"sum" : { "field" : "price" }}}}

8) Group By

SQL Query: Select color, sum(price) single_sum_price , avg(price) single_avg_price from transactions group by color

ES Query:{ "size": 0,"aggs": {"group_by_color": {"terms": {"field": "color.keyword"},"aggs": {"average_balance": {"avg": {"field": "price"}},"sum_balance": {"sum": {"field": "price"}}}}}}

8) More than one Group By

SQL Query: Select make,color sum(price) single_sum_price , avg(price) single_avg_price from transactions group by make,color

ES Query:{ "size": 0, "aggs": { "group_by_make": {"terms": { "field": "make.keyword" }, "aggs": {"group_by_color": { "terms": {"field": "color.keyword"},"aggs": {"average_price": {"avg": {"field": "price"}}}}}}}}

9) A Complex Query: Here we can use formulas like a/b and sum(a)/sum(b). I am using one measure and a constant in place of the other - hence instead of a/b I shall be using a/2. Using different aggegations I am doing sum(A)/count(A). I am also using period label: MTD. We can take use such labels in muti-period query.

SQL Query:Select color,make sum(price) sprice , count(price) cprice, avg(price/2) avgvalue1, sum(price)/count(price) avgvalue2 from transactions group by color,make

ES Query : {"size": 0 , "aggs": { "filter1" : {"filter":{ "bool":{"must" :[{ "terms": { "color": ["red","green"] } },{ "terms": { "make": ["ford","honda"] } } ] }} , "aggs": { "group_by_make": {"terms": { "field": "make.keyword" },"aggs": { "group_by_color": {"terms": { "field": "color.keyword" } , "aggs": {"MTD" : {"filter" :{ "range" : { "sold" : { "gte" : "2014-01-01", "lte" : "2014-12-31" } } }  , "aggs" : {"cprice" : { "value_count" :{ "field" : "price"} },"sprice" : { "sum" :{ "field" : "price"} },"avgvalue1": {"avg": { "script" : {"inline": "doc['price'].value !=0 ? doc['price'].value/2 : 0" }}}}},"avgvalue2": {"bucket_script": { "buckets_path": {"formula_1_1" : "MTD.sprice","formula_2_1" : "MTD.cprice"},"script" : "params.formula_1_1 != 0 ? params.formula_2_1/params.formula_2_1 :0" }}} }} }}}} }

Caveat - I am not an elasticsearch expert. Elastic has provided a comprehensive document on features. You can get more details from their site. If you would like to download the sample data for these queries, please write a comment.
