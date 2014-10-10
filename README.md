# Ember-calendar

This is a datetime picker based on moment.js. It is ready to be used in any Ember.js project
as is.

## Installation

Although one of the goals of this project is to become an ember-cli addon, manual installation
is required at the moment. This is done by copying **calendar.coffee**, **calendar.emblem** and
what is included inside **app.css** to your project.

## Use

The calendar is am Ember.js view, all you have to do to use it is to call it.
  = view 'calendar' value=date

## Options

At the moment the following options are exposed:

* minDate: Limit of minimum date to be selected (moment object)
* maxDate: Limit of maximum date to be selected (moment object)
* minYear: minimum available year  (number)

## New features

Although the calendar view is straightforward enough that extra features could be easily implemented,
feel free to ask for new features at george.koumparoulis@gmail.com
