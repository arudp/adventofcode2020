from advent5.part_1 import INPUT_FILE, Seat


def get_seat_ids(input_file: str) -> list:
    seat_ids: list = []
    with open(input_file) as codes:
        for code in codes:
            seat_ids.append(Seat.of(code).get_id())
    return seat_ids


def get_my_seat_id(seat_ids: list) -> int:
    seat_ids_copy: list = []
    seat_ids_copy.extend(seat_ids)
    seat_ids_copy.sort()
    for position, value in enumerate(seat_ids_copy):
        if position > 0 and position < len(seat_ids_copy) - 1:
            previous_id = seat_ids_copy[position - 1]
            if previous_id == value - 2:
                return value - 1
    return 0


id: int = get_my_seat_id(get_seat_ids(INPUT_FILE))

print("My seat is {}".format(id))
