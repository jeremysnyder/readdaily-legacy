import csv, json, copy

year1_reading_file = '/Users/jeremy/Downloads/RefRes-ReadingPlan-Final/ReadingPlan2016-Table1.csv'
year2_reading_file = '/Users/jeremy/Downloads/RefRes-ReadingPlan-Final/ReadingPlan2017-Table1.csv'

def file_to_map(file):
    readings = {}
    with open(file, 'rb') as f:
        r = csv.reader(f)
        for row in r:
            item = {}
            day = row[0]
            if day:
                date = row[1].split('/')
                key = "{0}_{1}".format(date[0].zfill(2), date[1].zfill(2))
                item["month"] = date[0]
                item["day"] = date[1]
                item["totalVerseCount"] = num(row[2])
                if row[3]: item["otReading"] = row[3]
                if row[4]: item["otVerseCount"] = num(row[4])
                if row[5]: item["ntReading"] = row[5]
                if row[6]: item["ntVerseCount"] = num(row[6])
                if row[7]: item["psalmsReading"] = row[7]
                if row[8]: item["psalmsVerseCount"] = num(row[8])
                if row[9]: item["proverbsReading"] = row[9]
                if row[10]: item["proverbsVerseCount"] = num(row[10])
                readings[key] = item

    return readings

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
        if "otVerseCount" in year2[k]: reading["ot2VerseCount"] = year2[k]["otVerseCount"]

        if "ot2VerseCount" in reading:
            reading["totalVerseCount"] = v["totalVerseCount"] + reading["ot2VerseCount"]
        else:
            reading["totalVerseCount"] = v["totalVerseCount"]
        readings[k] = reading

    return readings

def pretty_readings(readings):
    return json.dumps(readings, sort_keys=True, indent=2)

def write_json(readings):
    with open('./bible-reading-plan.json','w') as f:
        print >> f, pretty_readings(readings)

year1_readings = file_to_map(year1_reading_file)
year2_readings = file_to_map(year2_reading_file)
all_readings = combine_readings(year1_readings, year2_readings)
write_json(all_readings)
