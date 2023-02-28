
"""
    A demo script for making API requests to AWS OpenSearch

    This script uses both opensearch-py - which is a package for making API calls to OpenSearch,
    regardless of AWS, and boto3 which is a package for issuing requests to AWS

    boto3 is used to sign the requests with AWS Signature Version 4

"""


from opensearchpy import OpenSearch, RequestsHttpConnection, AWSV4SignerAuth
import boto3


host = 'search-example-xl5pyvwuyfo7oraljyjkh5t5pi.us-east-1.es.amazonaws.com' # no / in the end, no http://
region = 'us-east-1'

def create_client():
    credentials = boto3.Session().get_credentials()
    auth = AWSV4SignerAuth(credentials, region)

    client = OpenSearch(
        hosts = [{'host': host, 'port': 443}],
        http_auth = auth,
        use_ssl = True,
        verify_certs = True,
        connection_class = RequestsHttpConnection
    )
    return client


def create_index(client, index_name: str, num_shards: int):
    index_body = {
        'settings': {
            'index': {
            'number_of_shards': num_shards
            }
        }
    }

    response = client.indices.create(index_name, body=index_body)
    print('\nCreating index:')
    print(response)

def search_document(client, index_name: str, doc_id):
    q = 'miller'
    query = {
        'size': 5,
        'query': {
        'multi_match': {
            'query': q,
            'fields': ['title^2', 'director']
            }   
        }
    }

    response = client.search(
        body = query,
        index = index_name
    )

    print('\nSearch results:')
    print(response)

def index_document(client, index_name: str):
    document = {
        'title': 'Moneyball',
        'director': 'Bennett Miller',
        'year': '2011'
    }
    response = client.index(index=index_name, body=document, id=1, refresh=True)
    print('\nAdding documnet:')
    print(response)


def run_query(client, index_name: str):
    q = 'miller'
    query = {
         'size': 5,
         'query': {
         'multi_match': {
         'query': q,
         'fields': ['title^2', 'director']
         }
        }
    }

    response = client.search(
        body = query,
        index = index_name
    )

    print('\nSearch results:')
    print(response)

def list_indices(client):
    print(client.indices.get('*'))

if __name__ == "__main__":
    client = create_client()
    #create_index(client, "secret", 3)
    #list_indices(client)
    #index_document(client, 'unclassified')
    #run_query(client, 'secret')
    run_query(client, 'unclassified')
