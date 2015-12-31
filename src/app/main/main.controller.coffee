do (ng = angular, JSON = JSON) ->

  MainController = ['moment', 'ReadingPlanData', 'localStorageService', 'ScripturePassage', '$mdDialog', (moment, ReadingPlanData, LocalStorage, ScripturePassage, $mdDialog) ->
    LOCAL_STORAGE_KEY = 'readdaily.settings'
    vm = this

    vm.showAbout = (ev) ->
      alert = $mdDialog.alert()
        .clickOutsideToClose true
        .title 'Read Daily'
        .htmlContent 'Daily readings from the Two-Year Bible Reading Plan, produced jointly by<br>
                      Reformation OPC (Queens, NYC) and Resurrection OPC (State College, PA).<br>
                      For more resources, visit <a href="http://resurrectionopc.org/resources" target="_blank">resurrectionopc.org/resources</a>'
        .ariaLabel('Read Daily')
        .ok('OK')
        .targetEvent(ev)
      $mdDialog.show alert

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

    vm.loadScripture = ScripturePassage.load

    vm.actions = [
      {key: '1', name: 'All In One Year'}
      {key: '2:1', name: 'Two Year Plan - Year 1'}
      {key: '2:2', name: 'Two Year Plan - Year 2'}
    ]

    todaysReading = (format) ->
      today = moment()
      # today = moment('2016-02-28')
      vm.dateLabel = today.format('MMM Do')
      fullPlan = ReadingPlanData.dayPlan vm.plan, today.month() + 1, today.date()
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
