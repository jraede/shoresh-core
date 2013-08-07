
define ['core/form/fields/text', 'jquery','core/form/priceMask'], (Text, $) ->
	class Price extends Text
		postRender:->
			
			super
			@$('input').priceMask()


		populateModel: ->
			price = @$('input').val()


			property = @options.property

			@model.set(property, price.replace(/[^0-9\.]/g, ''))


		populateSelf: ->
			apiFormat = @options.apiFormat

			property = @options.property
			val = @model.get(property)
			if val
				@$('input').val(val)