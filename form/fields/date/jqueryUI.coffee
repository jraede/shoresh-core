###
 * This creates a date field using the jQuery UI Datepicker
 *
 * Note that Shoresh uses Moment.js as its core date handler. Moment and jQuery UI's
 * datepicker have different format. So, the displayFormat option uses the jQuery UI format
 * and the apiFormat option uses the Moment format
 *
 * @author  Jason Raede
 * @package  Shoresh
 * @subpackage  Form
###
define ['core/form/fields/text', 'jquery', 'moment', 'core/ui/jqueryui/datepicker'], (Text, $, moment) ->
	class jQueryUIDate extends Text
		postRender:->
			@$('input').datepicker
				format:@options.displayFormat
			super
		populateModel: ->
			date = moment(@$('input').datepicker('getDate'))
			property = @options.property
			if date
				apiFormat = @options.apiFormat
				converted = date.format(apiFormat)
				@model.set(property, converted)
			else
				@model.set(property, null)

		populateSelf: ->
			apiFormat = @options.apiFormat

			property = @options.property
			val = @model.get(property)
			if val
				date = moment(val, apiFormat)
				@$('input').datepicker('setDate', date.toDate())