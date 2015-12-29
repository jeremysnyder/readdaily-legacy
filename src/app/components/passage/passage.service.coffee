do (ng = angular) ->

  ScripturePassage = ['$window', ($window) ->
    load = (passage) ->
      $window.open "http://www.esvbible.org/#{$window.encodeURIComponent(passage)}/", '_blank'

    {load: load}
  ]

  ng.module 'readingPlan'
    .factory 'ScripturePassage', ScripturePassage
