import csv, json, copy, os

readers_reading_file = './ReadersBiblePlan-ReadingPlan.csv'

def file_to_map(file):
    readings = {}
    with open(file, 'r') as f:
        r = csv.reader(f)
        reading_number = 0
        for id, row in enumerate(r):
            if id is 0:
                continue
            print("{0}: {1} [{2}]".format(id, row[2], reading_number + 1))
            if has_readings(row):
                reading_number += 1
                item = {"otReading": row[2]}
                if row[3]: item["ot2Reading"] = row[3]
                if row[4]: item["gapReading"] = row[4]
                if row[5]: item["letterReading"] = row[5]
                if row[6]: item["psalmsReading"] = row[6]

                key = str(reading_number)
                readings[key] = dict((k, v) for k, v in item.items() if not isinstance(v, int))

    print(len(readings))

    return readings

def has_readings(row):
    return row[2] or row[3] or row[4] or row[5]

def num(s):
    try:
        return int(s)
    except ValueError:
        return 0

def combine_readings(year1, year2):
    readings = {}
    for k, v in year1.items():
        reading = copy.copy(v)
        if "otReading" in year2[k]: reading["ot2Reading"] = year2[k]["otReading"]
        readings[k] = reading

    return readings

def pretty_readings(readings):
    return json.dumps(readings, sort_keys=True, indent=2)

def write_json(filename, readings):
    reading_dir = './{0}'.format(filename)
    os.mkdir(reading_dir)
    for k, v in readings.items():
        with open('./{0}/{1}.json'.format(reading_dir, k), 'w') as f:
            print(pretty_readings(v), file = f)

readers_readings = file_to_map(readers_reading_file)
write_json('chapter-bible-reading-plan', readers_readings)
