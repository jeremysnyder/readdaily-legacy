do (ng = angular) ->

  YouVersionBibleReader = ['$window', 'osisCodes', ($window, osisCodes) ->

    toYouVersionFormat = (passage) ->
      details = startToEnd passage
      if 'end' of details
        "#{detailsToFormat(details, 'start')}+#{detailsToFormat(details, 'end')}"
      else
        "#{detailsToFormat(details, 'start')}"

    detailsToFormat = (details, key) ->
      chapterVerse = details[key]
      if 'verse' of chapterVerse
        "#{details.book}.#{chapterVerse.chapter}.#{chapterVerse.verse}"
      else
        "#{details.book}.#{chapterVerse.chapter}"

    startToEnd = (passage) ->
      details = {}
      if passage
        parts = passage.split ' '
        details.book = osisCodes[parts[0]]

        if parts.length > 1
          verses = parts[1]
          if verses.indexOf('-') >= 0
            verseTokenz = verses.split '-'
            details.start = parseChapterVerse verseTokenz[0]

            if verseTokenz.length > 1
              details.end = parseChapterVerse verseTokenz[1], true
              details.end.chapter = details.end.chapter || details.start.chapter
          else
            details.start = parseChapterVerse verses

      details

    parseChapterVerse = (cv, isEnd) ->
      if cv.indexOf(':') >= 0
        tokenz = cv.split ':'
        {chapter: tokenz[0], verse: tokenz[1]}
      else
        if isEnd then {verse: cv} else {chapter: cv}

    load = (passage) ->
      youVersionFormat = toYouVersionFormat passage
      console.log("Loading YouVersion Link: #{youVersionFormat}")
      $window.open "youversion://bible?reference=#{youVersionFormat}", '_blank'

    {} =
      load: load
      title: 'YouVersion Bible App'
  ]

  ng.module 'readingPlan'
    .factory 'YouVersionBibleReader', YouVersionBibleReader
    .run ['ScripturePassage', 'YouVersionBibleReader', (ScripturePassage, YouVersionBibleReader) ->
      ScripturePassage.register YouVersionBibleReader
    ]
