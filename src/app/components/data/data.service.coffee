do (ng = angular) ->

  ReadingPlanData = ['$http', '$q', ($http, $q) ->
    padDatePart = (part) -> String("00" + part).slice(-2)
    keyFor = (month, day) -> "#{padDatePart(month)}_#{padDatePart(day)}"

    dayPlan = (type, month, day) ->
      dayKey = keyFor month, day
      $http({method: 'GET', url: "assets/data/#{type}-bible-reading-plan/#{dayKey}.json"}).then (response) ->
        $q.when(response.data)

    {} =
      dayPlan: dayPlan
  ]

  ng.module 'readingPlan'
    .factory 'ReadingPlanData', ReadingPlanData
