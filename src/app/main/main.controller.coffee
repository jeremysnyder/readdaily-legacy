do (ng = angular) ->

  MainController = ['moment', 'ReadingPlanData', (moment, ReadingPlanData) ->
    vm = this

    ReadingPlanData.load().then (data) ->
      vm.loaded = true
      vm.plan = data
      vm.reading = todaysReading()

    vm.actions = [
      {name: 'Mark All Read', icon: ''}
      {name: 'Mark All Unread', icon: ''}
    ]

    todaysReading = () ->
      today = moment()
      vm.dateLabel = today.format('MMM Do')
      fullPlan = ReadingPlanData.dayPlan vm.plan, today.month(), today.date()
      reading = []
      reading.push {name: 'OT1', verses: fullPlan.otReading} if fullPlan.otReading
      reading.push {name: 'OT2', verses: fullPlan.ot2Reading} if fullPlan.ot2Reading
      reading.push {name: 'PS', verses: fullPlan.psalmsReading} if fullPlan.psalmsReading
      reading.push {name: 'PRV', verses: fullPlan.proverbsReading} if fullPlan.proverbsReading
      reading.push {name: 'NT', verses: fullPlan.ntReading} if fullPlan.ntReading
      reading

    return
  ]

  ng.module 'readingPlan'
    .controller 'MainController', MainController
