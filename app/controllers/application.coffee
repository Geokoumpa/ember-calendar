`import Ember from 'ember';`

Application = Ember.Controller.extend
  date: moment().add(3, 'days').utc()
  minDate: moment().subtract(1, 'days').utc()
  maxDate: moment().add(10, 'days').utc()
  actions:
    reduceMaxDate: ->
      maxDate = moment(@get('maxDate')).subtract(1, "days")
      @set('maxDate', maxDate)
    increaseMinDate: ->
      minDate = moment(@get('minDate')).add(1, "days")
      @set('minDate', minDate)




`export default Application`
