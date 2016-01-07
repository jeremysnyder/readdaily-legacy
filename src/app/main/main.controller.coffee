do (ng = angular, JSON = JSON) ->

  DialogController = ['$scope', '$mdDialog', 'settings', ($scope, $mdDialog, settings) ->
    ng.extend $scope, settings
    $scope.handleAction = (action) -> $mdDialog.hide($scope)
  ]

  MainController = ['moment', 'ReadingPlanData', 'localStorageService', 'ScripturePassage', '$mdDialog', (moment, ReadingPlanData, LocalStorage, ScripturePassage, $mdDialog) ->
    LOCAL_STORAGE_KEY = 'readdaily.settings'
    vm = this
    vm.version = '1.1.0'

    load = () ->
      vm.selectedPlanType = selectedPlanType()
      vm.selectedPlanTimeframe = selectedPlanTimeframe()
      vm.selectedPlanTypeLabel = vm.planTypeOptions[vm.selectedPlanType]
      vm.selectedPlanTimeframeLabel = vm.planTimeframeOptions[vm.selectedPlanTimeframe]
      vm.loaded = false
      ReadingPlanData.load(vm.selectedPlanType).then (data) ->
        vm.loaded = true
        vm.plan = data
        updateTodaysReading()

    vm.showAbout = (ev) ->
      updateSettings = (config) ->
        console.log config.selectedPlanType, config.selectedPlanTimeframe
        settings('selectedPlanType', config.selectedPlanType)
        settings('selectedPlanTimeframe', config.selectedPlanTimeframe)
        load()

      $mdDialog.show
        controller: DialogController
        templateUrl: 'app/main/dialog-template.html'
        locals:
           settings: vm
        parent: angular.element(document.body)
        targetEvent: ev
        clickOutsideToClose: true
      .then updateSettings

    settings = (key, value) ->
      _settings = JSON.parse(LocalStorage.get(LOCAL_STORAGE_KEY)) || {}
      if value?
        _settings[key] = value
        LocalStorage.set(LOCAL_STORAGE_KEY, JSON.stringify(_settings))
        return
      else
        _settings[key]

    vm.planTimeframeOptions =
      '1': 'All In 1 Year'
      '2:1': '2yr Plan - Year 1'
      '2:2': '2yr Plan - Year 2'

    vm.planTypeOptions =
      'chapter': 'Chapter Based'
      'verse': 'Verse Based'

    selectedPlanType = () -> settings('selectedPlanType') || 'verse'
    selectedPlanTimeframe = () -> settings('selectedPlanTimeframe') || '2:1'
    load()

    vm.loadScripture = ScripturePassage.load

    vm.currentDate = moment()

    updateTodaysReading = () ->
      format = selectedPlanTimeframe()
      today = vm.currentDate
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

      vm.reading = reading

    vm.today = () ->
      vm.currentDate = moment()
      updateTodaysReading()
      
    vm.previousDay = () ->
      moveCurrentDate -1
      updateTodaysReading()

    vm.nextDay = () ->
      moveCurrentDate 1
      updateTodaysReading()

    moveCurrentDate = (direction) ->
      vm.currentDate = vm.currentDate.add direction, 'd'

    return
  ]

  ng.module 'readingPlan'
    .controller 'MainController', MainController
