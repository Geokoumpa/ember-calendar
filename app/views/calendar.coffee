`import Ember from 'ember';`

Calendar = Ember.View.extend
  templateName: 'Views/calendar'

  hours: [0..24].toArray()
  minutes: [0..60].toArray()

  month: moment().utc().month()
  year: moment().utc().year()
  selectedDate: moment.utc().date()

  # options
  minDate: moment().subtract(1, 'days').utc()
  maxDate: moment().add(10, 'days').utc()
  minYear: 2010


  months: [[0, 'January'], [1, 'February'], [2, 'March'], [3, 'April'], [4, 'May'], [5, 'June'], [6, 'Jule'], [7, 'August'], [8, 'September'], [9, 'October'], [10, 'November'], [11, 'December']]
  years: (->
    [@get('minYear')..moment().year()].toArray().reverse()
  ).property()


  monthDays: (->
    view = @
    year = @get('year')
    month = @get('month')
    daysArray = []
    firstDayOfMonth = moment(new Date(year, month, 1))
    indexOfFirstDayOfMonth = firstDayOfMonth.day()
    firstDayOfFirstWeek = moment(new Date(year, month, 1)).startOf('week')
    lastDayOfMonth = moment(new Date(year, month, 1)).endOf('month')
    lastDayofLastWeek = moment(new Date(year, month, 1)).endOf('month').endOf('week')

    #  first fill in previous month's dates if available to complete first week
    unless firstDayOfMonth.day() is 0
      for d in [0..indexOfFirstDayOfMonth]
        daysArray[d] = Ember.Object.create
          date: firstDayOfFirstWeek.date() + d
          selectable: false
          isSelected: @get('date') is @get('views')
          greyed: true

    #fill this month's dates
    indexOfLastDayOfMonth = null
    for d in [indexOfFirstDayOfMonth..(indexOfFirstDayOfMonth + lastDayOfMonth.date() - 1)]
      thisDate = firstDayOfMonth.date() + d - indexOfFirstDayOfMonth
      selectable = true
      selectable = false if moment(new Date(year, month, thisDate)).isAfter(@get('maxDate')) || moment(new Date(year, month, thisDate)).isBefore(@get('minDate'))
      daysArray[d] = Ember.Object.create
        date: thisDate
        selectable: selectable
        isSelected: firstDayOfMonth.date() + d - indexOfFirstDayOfMonth is view.get('selectedDate')
        greyed: false

      indexOfLastDayOfMonth = d

    #lastly fill in next month;s dates
    unless lastDayOfMonth.day() is 6
      for d in [(indexOfLastDayOfMonth + 1)..(indexOfLastDayOfMonth + lastDayofLastWeek.date())]
        daysArray[d] = Ember.Object.create
          date: d - indexOfLastDayOfMonth
          selectable: false
          greyed: true

    weeks = @inGroups(daysArray, 7)
    weeks
  ).property('month', 'year', 'selectedDate')


  inGroups: (arr, min, max) ->
    arrs = []
    size = 1
    min = min or 1
    max = max or min or 1
    while arr.length > 0
      size = Math.min(max, Math.floor((Math.random() * max) + min))
      arrs.push arr.splice(0, size)
    arrs



  actions:
    incMonth: ->
      @incrementProperty('month') unless @get('month') == 11
    decMonth: ->
      @decrementProperty('month') unless @get('month') == 0
    incYear: ->
      console.log @get('year') == moment().year()
      @incrementProperty('year') unless @get('year') == moment().year()
    decYear: ->
      @decrementProperty('year')
    pickDate: (day)->
      @set('selectedDate', day.get('date'))
    apply: ->
      offset = (new Date()).getTimezoneOffset() / 60
      @set('date', moment(new Date(@get('year'), @get('month'), @get('selectedDate'), @get('hour'), @get('minute'))).subtract(offset, 'hours').utc())


  value: ((key, value, oldValue)->
    if arguments.length > 1
      @set('date', moment(value).utc())
      @set('year', moment(value).utc().year())
      @set('month', moment(value).utc().month())
      @set('selectedDate', moment(value).utc().date())
      @set('hour', moment(value).utc().hour())
      @set('minute', moment(value).utc().minute())
    else
      @get('date')
  ).property('date')



`export default Calendar`

