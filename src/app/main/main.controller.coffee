do (ng = angular, JSON = JSON) ->

  MainController = ['moment', 'ReadingPlanData', 'localStorageService', (moment, ReadingPlanData, LocalStorage) ->
    LOCAL_STORAGE_KEY = 'readdaily.settings'
    vm = this

    settings = (key, value) ->
      _settings = JSON.parse(LocalStorage.get(LOCAL_STORAGE_KEY)) || {}
      if value?
        _settings[key] = value
        LocalStorage.set(LOCAL_STORAGE_KEY, JSON.stringify(_settings))
        return
      else
        _settings[key]


    selectedPlan = () -> settings('selectedPlan') || '1'

    ReadingPlanData.load().then (data) ->
      vm.loaded = true
      vm.plan = data
      vm.reading = todaysReading(selectedPlan())

    vm.changePlan = (selection) ->
      settings('selectedPlan', selection)
      vm.reading = todaysReading(selection)

    vm.actions = [
      {key: '1', name: 'All In One Year'}
      {key: '2:1', name: 'Two Year Plan - Year 1'}
      {key: '2:2', name: 'Two Year Plan - Year 2'}
    ]

    todaysReading = (format) ->
      today = moment()
      vm.dateLabel = today.format('MMM Do')
      fullPlan = ReadingPlanData.dayPlan vm.plan, today.month(), today.date()
      reading = []

      switch format
        when '1'
          reading.push {name: 'OT1', verses: fullPlan.otReading} if fullPlan.otReading
          reading.push {name: 'OT2', verses: fullPlan.ot2Reading} if fullPlan.ot2Reading
        when '2:1'
          reading.push {name: 'OT', verses: fullPlan.otReading} if fullPlan.otReading
        when '2:2'
          reading.push {name: 'OT', verses: fullPlan.ot2Reading} if fullPlan.ot2Reading

      reading.push {name: 'PS', verses: fullPlan.psalmsReading} if fullPlan.psalmsReading
      reading.push {name: 'PRV', verses: fullPlan.proverbsReading} if fullPlan.proverbsReading
      reading.push {name: 'NT', verses: fullPlan.ntReading} if fullPlan.ntReading
      reading

    return
  ]

  ng.module 'readingPlan'
    .controller 'MainController', MainController
