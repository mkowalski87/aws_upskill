import json
from items_store import ItemStore


def handler(event, context):
    searchText = event["queryStringParameters"]["search"]
    list_ids = ItemStore().search_items_with_name(searchText)
    return {"statusCode": 200, "body": json.dumps(list_ids)}
