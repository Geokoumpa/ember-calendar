`import Ember from 'ember';`

Application = Ember.Controller.extend
  date: moment().add(3, 'days').utc()

`export default Application`
