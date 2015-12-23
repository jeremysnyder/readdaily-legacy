do (ng = angular) ->

  ReadingPlanData = ['$http', '$q', ($http, $q) ->
    load = () ->
      $http({method: 'GET', url: 'assets/data/bible-reading-plan.json'}).then (response) ->
        $q.when(response.data)

    padDatePart = (part) -> String("00" + part).slice(-2)

    key = (month, day) -> "#{padDatePart(month)}_#{padDatePart(day)}"

    dayPlan = (data, month, day) -> data[key(month, day)]

    {} =
      load: load
      dayPlan: dayPlan
  ]

  ng.module 'readingPlan'
    .factory 'ReadingPlanData', ReadingPlanData
