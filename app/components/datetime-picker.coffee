`import Ember from 'ember';`

DatetimePicker = Ember.Component.extend

  hours: [0..24].toArray()
  minutes: (->
    [0..60].toArray().map (h)->
      if h < 10
        [h, "0#{h}"]
      else
        [h, "#{h}"]
  ).property()
  minuteText: (->
    @get('minutes')[@get('minute')].get('lastObject')
  ).property('minute')
  opened: false
  offset: (new Date()).getTimezoneOffset() / 60

  month: moment().utc().month()
  year: moment().utc().year()
  selectedDate: moment.utc().date()

  # options
  minDate: moment().subtract(1, 'days').utc()
  maxDate: moment().add(10, 'days').utc()
  minYear: 2010


  months: [[0, 'January'], [1, 'February'], [2, 'March'], [3, 'April'], [4, 'May'], [5, 'June'], [6, 'Jule'], [7, 'August'], [8, 'September'], [9, 'October'], [10, 'November'], [11, 'December']]
  monthText: (->
    @get('months')[@get('month')].get('lastObject')
  ).property('month')
  years: (->
    [@get('minYear')..moment().year()].toArray()
  ).property()



  monthDays: (->
    component = @
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
          isSelected: @get('date') is @get('components')
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
        isSelected: firstDayOfMonth.date() + d - indexOfFirstDayOfMonth is component.get('selectedDate')
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
    open: ->
      @set("opened", true)
    incMonth: ->
      @incrementProperty('month') unless @get('month') == 11
    decMonth: ->
      @decrementProperty('month') unless @get('month') == 0
    incYear: ->
      @incrementProperty('year') unless @get('year') == moment().year()
    decYear: ->
      @decrementProperty('year') unless @get('year') is @get('minYear')
    pickDate: (day)->
      @set('selectedDate', day.get('date'))
    apply: ->
      @set('date', moment(new Date(@get('year'), @get('month'), @get('selectedDate'), @get('hour'), @get('minute'))).subtract(@get('offset'), 'hours').utc())
      @set('opened', false)
    cancel: ->
      @set('opened', false)

  # Handle closing on click outside of component
  mouseEnter: ->
    @set('mouseOut', false)
  mouseLeave: ->
    @set('mouseOut', true)

  mouseOutChanged: (->
    component = @
    if @get('mouseOut') is true
      $(document).on 'mousedown', ->
        component.set('opened', false)
    else
      $(document).off 'mousedown'
  ).observes('mouseOut')



  # when minDate or MaxDate changes, both selected date
  # and value date have to be checked against new value,
  # as to be repositioned if found to be out of new limits.
  limitsChanged: (->
    # apply new limits to selected date on calendar
    currentSelectedDate = moment(new Date(@get('year'), @get('month'), @get('selectedDate'), @get('hour'), @get('minute'))).subtract(@get('offset'), 'hours').utc()
    before = !Ember.isEmpty(@get('minDate')) && currentSelectedDate.isBefore(@get('minDate'))
    after = !Ember.isEmpty(@get('maxDate')) && currentSelectedDate.isAfter(@get('maxDate').startOf('day'))
    if before or after
      currentSelectedDate = moment(@get('minDate')).add(1, "days") if before
      currentSelectedDate = moment(@get('maxDate')) if after
      @set('selectedDate', currentSelectedDate.date())
    else
    @notifyPropertyChange('selectedDate')

    # apply new limits to value date
    date = @get('date')
    before = !Ember.isEmpty(@get('minDate')) && date.isBefore(@get('minDate'))
    after = !Ember.isEmpty(@get('maxDate')) && date.isAfter(@get('maxDate').startOf('day'))
    if before or after
      @set('date', moment(@get('minDate')).add(1, "days")) if before
      @set('date', moment(@get('maxDate'))) if after

  ).observes('minDate', 'maxDate')




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



`export default DatetimePicker`

