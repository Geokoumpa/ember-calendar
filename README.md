# Ember-calendar

This is a datetime picker based on moment.js. It is ready to be used in any Ember.js project
as is.

## Installation

Although one of the goals of this project is to become an ember-cli addon, manual installation
is required at the moment. This is done by copying **datetime-picker.coffee**, **datetime-picker.emblem** and
what is included inside **app.css** to your project.

## Use

The calendar is am Ember.js component, all you have to do to use it is to call it.

`= datetime-picker value=date minDate=minDate maxDate=maxDate`

## Options

At the moment the following options are exposed:

* value: The current value of the datetime picker control
* minDate: Limit of minimum date to be selected (moment object)
* maxDate: Limit of maximum date to be selected (moment object)
* minYear: minimum available year  (number)

all options work both as setter and getters, for example if your controller changes
the property bound to the value property of the picker anyhow, the datetime picker
will also handle everything needed to reflect this change.

## New features

Although the calendar component is straightforward enough that extra features could be easily implemented,
feel free to ask for new features at george.koumparoulis@gmail.com
