#!/bin/bash

#
#   this script demonstrates how to call AWS API using curl
#   and sign the requests with AWS Signature Version 4
#


#domain_url=https://search-example-xl5pyvwuyfo7oraljyjkh5t5pi.us-east-1.es.amazonaws.com
config_api_url="https://es.us-east-1.amazonaws.com/2021-01-01/opensearch/domain/example/config"
request_uri="$domain_url/_cluster/health"
curl --aws-sigv4 "aws:amz:us-east-1:es" -XGET -u $AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY "$request_uri"
