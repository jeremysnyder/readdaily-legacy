do (ng = angular) ->

  ScripturePassage = () ->
    readers = []
    registerReader = (reader) ->
      readers.push reader

    {} =
      register: registerReader
      readers: readers

  ng.module 'readingPlan'
    .factory 'ScripturePassage', [ScripturePassage]
