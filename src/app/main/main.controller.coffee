do (ng = angular) ->

  MainController = ['moment', 'ReadingPlanData', (moment, ReadingPlanData) ->
    'ngInject'
    vm = this

    ReadingPlanData.load().then (data) ->
      vm.loaded = true
      vm.plan = data
      vm.reading = todaysReading()

    todaysReading = () ->
      today = moment()
      vm.dateLabel = today.format('LL')
      ReadingPlanData.dayPlan vm.plan, today.month(), today.date()

    return
  ]

  ng.module 'readingPlan'
    .controller 'MainController', MainController
