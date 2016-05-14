describe 'data.service', () ->
  mockService = undefined

  beforeEach angular.mock.module 'readingPlan'
  beforeEach () ->
    angular.mock.inject ($injector) ->
      mockService = $injector.get 'ScripturePassage'

  it 'should have at least one reader', () ->
    mockService.readers.length > 0

  it 'should load open scripture in a window', () ->
    mockService.readers[0].load 'Romans 8'
