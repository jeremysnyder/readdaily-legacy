describe 'controllers', () ->
  vm = undefined

  beforeEach module 'readingPlan'

  beforeEach inject ($controller) ->
    vm = $controller 'MainController'

  # it 'should define more than 5 awesome things', () ->
  #   expect(angular.isArray(vm.awesomeThings)).toBeTruthy()
