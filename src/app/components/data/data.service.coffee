do (ng = angular, moment = moment) ->

  ReadingPlanData = ['$http', '$q', ($http, $q) ->
    dayPlan = (type, date) ->
      dayKey = readingDay(date)
      if dayKey
        success = (response) -> $q.when response.data
        error = (response) -> $q.when {} # 404 on the file request
        $http(method: 'GET', url: "assets/data/#{type}-bible-reading-plan/#{dayKey}.json").then success, error
      else
        $q.when {}

    readingDay = (value) ->
      asMoment = moment value
      week = asMoment.week()
      # In Moment, the week with Jan1 is week 1, so the last days can fall on that week
      # Also, week should be zero based for math
      week = (if asMoment.month() == 11 && week == 1 then 53 else week) - 1 
      switch asMoment.day()
        when 0 then null # No readings on Sunday
        else asMoment.dayOfYear() - week # 6 reading days in a week

    {} =
      dayPlan: dayPlan
      readingDay: readingDay
  ]

  ng.module 'readingPlan'
    .factory 'ReadingPlanData', ReadingPlanData
