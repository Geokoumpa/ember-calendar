`import Ember from 'ember';`

Calendar = Ember.View.extend
  templateName: 'Views/calendar'

  month: moment().utc().month()
  year: moment().utc().year()

  displayMonth: (->
    months = ['January', 'February', 'March', 'April', 'May', 'June', 'Jule', 'August', 'September', 'October', 'November', 'December']
    months[@get('month')]
  ).property('month')

  monthDays: (->
    year = @get('year')
    month = @get('month')
    days = []
    firstDayOfMonth = moment(year, month).utc()
    indexOfFirstDayOfMonth = firstDayOfMonth.isoWeekday()
    firstDayOfFirstWeek = firstDayOfMonth.startOf('week')
    lastDayOfMonth = firstDayOfMonth.endOf('month')
    lastDayofLastWeek = lastDayOfMonth.endOf('week')

    days[indexOfFirstDayOfMonth] = firstDayOfMonth.date()
    # for d in [0..indexOfFirstDayOfMonth]
    #   days[d] = firstDayOfFirstWeek.date() + d


    days
  ).property('month', 'year')



  actions:
    incMonth: ->
      @incrementProperty('month') unless @get('month') == 11
    decMonth: ->
      @decrementProperty('month') unless @get('month') == 0
    incYear: ->
      @incrementProperty('year')
    decYear: ->
      @decrementProperty('year')







`export default Calendar`

