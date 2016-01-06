import csv, json, copy

readers_reading_file = './ReadersBiblePlan-ReadingPlan.csv'
verses_reading_file = './VersesReadingPlan-ReadingPlan.csv'

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
                if row[5]: item["ot2Reading"] = row[5]
                if row[6]: item["ot2VerseCount"] = num(row[6])
                if row[7]: item["ntReading"] = row[7]
                if row[8]: item["ntVerseCount"] = num(row[8])
                if row[9]: item["psalmsReading"] = row[9]
                if row[10]: item["psalmsVerseCount"] = num(row[10])
                if row[11]: item["proverbsReading"] = row[11]
                if row[12]: item["proverbsVerseCount"] = num(row[12])
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

def write_json(filename, readings):
    with open('./{0}.json'.format(filename), 'w') as f:
        print >> f, pretty_readings(readings)

verses_readings = file_to_map(verses_reading_file)
readers_readings = file_to_map(readers_reading_file)
write_json('verse-bible-reading-plan', verses_readings)
write_json('chapter-bible-reading-plan', readers_readings)
