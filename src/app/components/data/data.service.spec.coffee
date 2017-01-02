describe 'data.service', () ->
  mockService = undefined
  $httpBackend = undefined

  versePlan =
    "01_01":
      "day": "1"
      "month": "1"
      "ntReading": "Matthew 1:1-17"
      "ntVerseCount": 17
      "otReading": "Genesis 1:1-13"
      "otVerseCount": 13
      "ot2Reading": "Job 1:1-22"
      "ot2VerseCount": 22
      "proverbsReading": "Proverbs 1:1-19"
      "proverbsVerseCount": 19
      "psalmsReading": "Psalm 1:1-6"
      "psalmsVerseCount": 6
      "totalVerseCount": 55
    "02_02":
      "day": "2"
      "month": "2"
      "ntReading": "Matthew 1:18-25"
      "ntVerseCount": 8
      "ot2Reading": "Job 1:1-22"
      "ot2VerseCount": 22
      "otReading": "Genesis 1:14-2:3"
      "otVerseCount": 21
      "proverbsReading": "Proverbs 1:20-33"
      "proverbsVerseCount": 13
      "totalVerseCount": 64

  chapterPlan =
    "01_01":
      "day": "1"
      "month": "1"
      "ntReading": "Matthew 1"
      "ntVerseCount": 0
      "otReading": "Genesis 1"
      "otVerseCount": 0
      "ot2Reading": "Job 1"
      "ot2VerseCount": 0
      "proverbsReading": "Proverbs 1"
      "proverbsVerseCount": 0
      "psalmsReading": "Psalm 1"
      "psalmsVerseCount": 0
      "totalVerseCount": 0
    "02_02":
      "day": "2"
      "month": "2"
      "ntReading": "Matthew 2"
      "ntVerseCount": 0
      "ot2Reading": "Job 2"
      "ot2VerseCount": 0
      "otReading": "Genesis 2"
      "otVerseCount": 0
      "proverbsReading": "Proverbs 2"
      "proverbsVerseCount": 0
      "totalVerseCount": 0

  beforeEach angular.mock.module 'readingPlan'
  beforeEach () ->
    angular.mock.inject ($injector) ->
      $httpBackend = $injector.get '$httpBackend'
      mockService = $injector.get 'ReadingPlanData'

  dayReadings = (day) ->
    [day['ntReading'], day['otReading'], day['ot2Reading'], day['psalmsReading'], day['proverbsReading']].filter (reading) -> reading?

  loadData = (type, month, day) ->
    result = {}
    mockService.dayPlan(type, month, day).then (data) ->
      result = data
    $httpBackend.flush()
    result

  it 'should have 5 verse readings for Jan 1', () ->
    $httpBackend.expectGET 'assets/data/verse-bible-reading-plan/01_01.json'
      .respond versePlan['01_01']
    day = loadData('verse', 1, 1)
    readings = dayReadings day
    expect(readings.length).toBe 5

  it 'should have 4 verse readings for Jan 2', () ->
    $httpBackend.expectGET 'assets/data/verse-bible-reading-plan/02_02.json'
      .respond versePlan['02_02']
    day = loadData('verse', 2, 2)
    readings = dayReadings day
    expect(readings.length).toBe 4

  it 'should have a specific chapter reading for Jan 1', () ->
    $httpBackend.expectGET 'assets/data/chapter-bible-reading-plan/01_01.json'
      .respond chapterPlan['01_01']
    day = loadData('chapter', 1, 1)
    expect(day.proverbsReading).toBe 'Proverbs 1'

  it 'should have a specific chapter reading for Jan 2', () ->
    $httpBackend.expectGET 'assets/data/chapter-bible-reading-plan/02_02.json'
      .respond chapterPlan['02_02']
    day = loadData('chapter', 2, 2)
    expect(day.otReading).toBe 'Genesis 2'

  it 'should find the proper reading days', () ->
    day = moment('1/1/2017')
    expect(mockService.readingDay(day)).toBe 1
