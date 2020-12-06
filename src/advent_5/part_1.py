import pathlib
import os

ROWS: int = 128
COLUMNS: int = 8
ROW_MAX_INDEX: int = 6
COLUMN_MAX_INDEX: int = 9
FRONT: str = "F"
BACK: str = "B"
RIGHT: str = "R"
LEFT: str = "L"
INPUT_FILE = os.path.join(pathlib.Path(__file__).parent.absolute(), "input")


def get_range_half(lower_half: int, upper_half: int) -> int:
    difference: int = upper_half - lower_half
    return int(lower_half + difference / 2)


def calculate_in_halves(
    seat_code: str = "",
    upper_limit: int = 0,
    start_index: int = 0,
    end_index: int = 0,
    upper_delimiter: str = "",
) -> int:
    lower_half: int = 0
    upper_half: int = upper_limit - 1
    half: int = 0
    for index in range(start_index, end_index + 1):
        half = get_range_half(lower_half, upper_half)
        if upper_delimiter == seat_code[index]:
            lower_half = half + 1
            half = lower_half
        else:
            upper_half = half
    return half


def get_row(code: str) -> int:
    return calculate_in_halves(
        seat_code=code, upper_limit=ROWS, end_index=ROW_MAX_INDEX, upper_delimiter=BACK
    )


def get_column(code: str) -> int:
    columns_start: int = ROW_MAX_INDEX + 1
    return calculate_in_halves(
        seat_code=code,
        upper_limit=COLUMNS,
        start_index=columns_start,
        end_index=COLUMN_MAX_INDEX,
        upper_delimiter=RIGHT,
    )


class Seat:
    def __init__(self, row: int, column: int) -> None:
        self.row = row
        self.column = column

    def get_id(self) -> int:
        return self.row * 8 + self.column

    @staticmethod
    def of(code: str) -> "Seat":
        row = get_row(code)
        column = get_column(code)
        seat = Seat(row, column)
        return seat


def get_highest_id(input_file: str):
    highest_id: int = 0
    with open(input_file) as codes:
        for code in codes:
            seat_id: int = Seat.of(code).get_id()
            if seat_id > highest_id:
                highest_id = seat_id
    return highest_id


print(get_highest_id(INPUT_FILE))
