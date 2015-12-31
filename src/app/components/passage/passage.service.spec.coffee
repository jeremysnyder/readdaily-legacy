describe 'data.service', () ->
  mockService = undefined

  beforeEach angular.mock.module 'readingPlan'
  beforeEach () ->
    angular.mock.inject ($injector) ->
      mockService = $injector.get 'ScripturePassage'

  it 'should load open scripture in a window', () ->
    mockService.load 'Romans 8'
