from dataclasses import dataclass


@dataclass
class Item:
    id: str
    name: str
    price: float
    quantity: float
    unit: str


@dataclass
class Location:
    id: str
    name: str

    @property
    def json(self):
        return {"id": self.id, "name": self.name }


class ItemStore():

    def __init__(self):
        self.locations = [Location("rze1", "Rzeszów"), Location("gda1", "Gdańsk"), Location("krk1", "Kraków")]
        self.items = {
            "rze1": [Item("1", "foo", 5.0, 100, "kg")],
            "gda1": [Item("2", "bar", 15.0, 1000, "l"), Item("3", "foobar", 10.0, 500, "l")],
            "krk1": [Item("3", "foobar", 15.0, 1000, "l"), Item("4", "barfoo", 1.0, 500, "m")]
        }

    # returns list of item id
    def search_items_with_name(self, name):
        item_ids = set([])
        for items_in_warehouse in self.items.values():
            for item in items_in_warehouse:
                if name in item.name:
                    item_ids.add(item.id)
        return list(item_ids)

    # returns list of locations
    def get_locations_for_item(self, item_id):
        found_locations = set([])
        for (k,v) in self.items.items():
            for item in v:
                if item.id == item_id:
                    found_locations.add(k)
        loc_list = []
        for location in self.locations:
            if location.id in found_locations:
                loc_list.append(location)

        return loc_list