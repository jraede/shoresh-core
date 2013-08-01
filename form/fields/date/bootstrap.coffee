###
 * This creates a date field using the Bootstrap Datepicker by Andrew Rowls
 *
 * Note that Shoresh uses Moment.js as its core date handler. Moment and the datepicker
 * datepicker have different format. So, the displayFormat option uses the datepicker format
 * and the apiFormat option uses the Moment format
 *
 * Note this isn't compatible with the jQuery UI datepicker because they have the same
 * method name on the jQuery object. So it's either or (I can't really understand why you
 * would want both anyway...)
 *
 * @author  Jason Raede
 * @package  Shoresh
 * @subpackage  Form
###
define ['core/form/fields/text', 'jquery', 'moment', 'core/date/bootstrap-datepicker/datepicker'], (Text, $, moment) ->
	class BootstrapDate extends Text
		postRender:->
			@$('input').datepicker
				format:@options.displayFormat
				autoclose:true
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