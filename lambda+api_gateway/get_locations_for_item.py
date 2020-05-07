import json
from items_store import ItemStore


def handler(event, context):
    item_id = event["queryStringParameters"]["id"]
    locations = ItemStore().get_locations_for_item(item_id)
    return {"statusCode": 200, "body": json.dumps([l.json for l in locations])}