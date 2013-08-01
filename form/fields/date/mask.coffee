define ['components/form/fields/mask', 'moment'], (Mask, moment) ->
	class DateMask extends Mask
		options:
			apiFormat:'YYYY-MM-DD'
			displayFormat:'MM/DD/YYYY'
			mask:'99/99/9999'
		populateModel: ->
			apiFormat = @options.apiFormat
			displayFormat = @options.displayFormat


			# Convert from display format to API format
			val = @getValue()
			date = moment(val, displayFormat)
			converted = date.format(apiFormat)
			property = @options.property


			@model.set(property, converted)

		populateSelf: ->
			apiFormat = @options.apiFormat
			displayFormat = @options.displayFormat

			property = @options.property
			val = @model.get(property)
			date = moment(val, apiFormat)
			converted = date.format(displayFormat)
			
			@$('input').val(converted)