do (ng = angular, moment = moment) ->

  ReadingPlanData = ['$http', '$q', ($http, $q) ->
    padDatePart = (part) -> String("00" + part).slice(-2)
    keyFor = (month, day) -> "#{padDatePart(month)}_#{padDatePart(day)}"

    dayPlan = (type, month, day) ->
      console.log month, day
      fullDay = moment().month(month - 1).date(day)
      # console.log readingDay(moment('2017-01-01'))
      # console.log readingDay(moment('2017-01-02'))
      # console.log readingDay(moment('2017-01-07'))
      # console.log readingDay(moment('2017-01-08'))
      # console.log readingDay(moment('2017-01-09'))
      # console.log readingDay(moment('2017-01-15'))
      # console.log readingDay(moment('2017-01-16'))
      console.log fullDay.format()
      console.log readingDay(fullDay)
      dayKey = keyFor month, day
      dayKey = readingDay(fullDay)
      if dayKey
        $http({method: 'GET', url: "assets/data/#{type}-bible-reading-plan/#{dayKey}.json"}).then (response) ->
          $q.when response.data
      else
        $q.when {}

    readingDay = (value) ->
      asMoment = moment value
      switch asMoment.day()
        when 0 then null # No readings on Sunday
        else asMoment.dayOfYear() - asMoment.week() # 6 reading days in a week

    {} =
      dayPlan: dayPlan
      readingDay: readingDay
  ]

  ng.module 'readingPlan'
    .factory 'ReadingPlanData', ReadingPlanData
