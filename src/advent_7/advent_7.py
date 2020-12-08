import re
import os
import pathlib

example = [
    "light red bags contain 1 bright white bag, 2 muted yellow bags.",
    "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
    "bright white bags contain 1 shiny gold bag.",
    "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
    "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
    "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
    "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
    "faded blue bags contain no other bags.",
    "dotted black bags contain no other bags.",
]

BAG_TYPE_REGEX = "(.*?) bag"
CONTAIN_DELIM = " contain "
BAG_SEPARATOR = ", "
NO_BAG = "no other bags"

TYPE_TO_CHECK = "shiny gold"
INPUT_FILE = os.path.join(pathlib.Path(__file__).parent.absolute(), "input")

bag_dictionary: dict = {}


def get_missing_items(l1: list, l2: list) -> list:
    return [item for item in l1 if item not in l2]


class InnerBag:
    def __init__(self, bag_type: str, count: int) -> None:
        self.bag_type = bag_type
        self.count = count


class Bag:
    def __init__(self, bag_type: str) -> None:
        self.bag_type: str = bag_type
        self.contents: list = []


class BagDictionary:
    def __init__(self) -> None:
        self._bags: dict = {}

    def add(self, bag: Bag) -> None:
        try:
            stored_bag: Bag = self._bags[bag.bag_type]
            types_missing = get_missing_items(bag.contents, stored_bag.contents)
            stored_bag.contents.extend(types_missing)
        except KeyError:
            self._bags[bag.bag_type] = bag

    def get(self, bag_type) -> Bag:
        return self._bags.get(bag_type, None)

    def get_all_bags(self) -> list:
        return list(self._bags.values())

    def get_count_of_bags_that_can_hold(self, bag_type: str) -> int:
        all_bags = self.get_all_bags()
        count: int = 0
        for bag in all_bags:
            if (self._how_many_can_hold(bag, bag_type)) > 0:
                count += 1

        return count

    def _how_many_can_hold(self, bag: Bag, bag_type: str) -> int:
        count: int = 0
        for inner_bag in bag.contents:
            if inner_bag.bag_type == bag_type:
                count += inner_bag.count
            current_bag = self.get(inner_bag.bag_type)
            if current_bag:
                count += self._how_many_can_hold(current_bag, bag_type)
        return count

    def how_many_bags_are_contained(self, bag_type: str) -> int:
        count: int = 0
        current_bag: Bag = self.get(bag_type)
        if current_bag is None:
            return count
        for inner_bag in current_bag.contents:
            number_of_bags: int = inner_bag.count
            count_for_each: int = self.how_many_bags_are_contained(inner_bag.bag_type)
            count += number_of_bags + number_of_bags * count_for_each
        return count


def without_dot(contents: str) -> str:
    return contents[:-1]


def get_bag_type(bag_string: str) -> str:
    match = re.match(BAG_TYPE_REGEX, bag_string)
    if len(match.groups()) > 0:
        return match.groups()[0]
    else:
        raise Exception("There should always exist a bag type")


def parse_inner_bag(inner_bag: str) -> InnerBag:
    args = inner_bag.split(" ")
    number = int(args[0])
    bag_type = " ".join(args[1:-1])
    return InnerBag(bag_type, number)


def parse_bag(phrase: str) -> Bag:
    container, contents = phrase.split(CONTAIN_DELIM)
    bag = Bag(get_bag_type(container))
    if NO_BAG in contents:
        return bag
    contents = without_dot(contents).split(BAG_SEPARATOR)
    for inner_bag in contents:
        bag.contents.append(parse_inner_bag(inner_bag))
    return bag


def generate_bag(input_file: str):
    with open(input_file) as rules:
        for rule in rules:
            yield parse_bag(rule)


def get_dictionary_from_input(input_file: str) -> BagDictionary:
    dictionary: BagDictionary = BagDictionary()
    bag_generator = generate_bag(input_file)
    for bag in bag_generator:
        dictionary.add(bag)
    return dictionary


def part1():
    bag_dictionary = get_dictionary_from_input(INPUT_FILE)
    count = bag_dictionary.get_count_of_bags_that_can_hold(TYPE_TO_CHECK)
    print("Count of bags that can hold {} bags: {}".format(TYPE_TO_CHECK, count))


def part2():
    bag_dictionary = get_dictionary_from_input(INPUT_FILE)
    count = bag_dictionary.how_many_bags_are_contained(TYPE_TO_CHECK)
    print("Count of bags that {} bags must contain: {}".format(TYPE_TO_CHECK, count))


part2()
