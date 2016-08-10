do (ng = angular) ->

  EsvBibleOrgReader = ($window) ->
    load = (passage) ->
      $window.open "http://www.esvbible.org/#{$window.encodeURIComponent(passage)}/", '_blank'

    {} =
      load: load
      title: 'esvbible.org'

  ng.module 'readingPlan'
    .factory 'EsvBibleOrgReader', ['$window', EsvBibleOrgReader]
    .run ['ScripturePassage', 'EsvBibleOrgReader', (ScripturePassage, EsvBibleOrgReader) ->
      ScripturePassage.register EsvBibleOrgReader
    ]
