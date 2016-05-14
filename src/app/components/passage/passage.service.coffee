do (ng = angular) ->

  ScripturePassage = ['$window', ($window) ->
    readers = []
    registerReader = (reader) ->
      readers.push reader

    {} =
      register: registerReader
      readers: readers
  ]

  ng.module 'readingPlan'
    .factory 'ScripturePassage', ScripturePassage
