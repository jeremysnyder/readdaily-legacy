describe 'data.service', () ->
  mockService = undefined
  $httpBackend = undefined

  plan =
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

  beforeEach angular.mock.module 'readingPlan'
  beforeEach () ->
    angular.mock.inject ($injector) ->
      $httpBackend = $injector.get '$httpBackend'
      mockService = $injector.get 'ReadingPlanData'
      $httpBackend.expectGET 'assets/data/bible-reading-plan.json'
        .respond plan

  dayReadings = (day) ->
    [day['ntReading'], day['otReading'], day['ot2Reading'], day['psalmsReading'], day['proverbsReading']].filter (reading) -> reading?

  loadData = () ->
    result = {}
    mockService.load().then (data) ->
      result = data
    $httpBackend.flush()
    result

  it 'should load plan', () ->
    data = loadData()
    expect angular.isObject(data).toBeTruthy

  it 'should have proper day and month for key', () ->
    data = loadData()
    day1 = data['01_01']
    expect(day1.day).toBe '1'
    expect(day1.month).toBe '1'

    day2 = data['02_02']
    expect(day2.day).toBe '2'
    expect(day2.month).toBe '2'

  it 'should have 5 readings for Jan 1', () ->
    day = loadData()['01_01']
    readings = dayReadings day
    expect(readings.length).toBe 5

  it 'should have 4 readings for Jan 2', () ->
    day = loadData()['02_02']
    readings = dayReadings day
    expect(readings.length).toBe 4

  it 'should load a day play', () ->
    data = loadData()
    day1 = mockService.dayPlan data, 1, 1
    expect(day1.day).toBe '1'
    expect(day1.month).toBe '1'

    day2 = mockService.dayPlan data, 2, 2
    expect(day2.day).toBe '2'
    expect(day2.month).toBe '2'
