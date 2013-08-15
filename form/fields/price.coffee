
define ['core/form/fields/text', 'jquery','core/form/priceMask'], (Text, $) ->
	class Price extends Text
		postRender:->
			
			super
			@$('input').priceMask()



		getValue: ->		
			price = @$('input').val()

			return price.replace(/[^0-9\.]/g, '')
		populateModel: ->


			property = @options.property

			@model.set(property, @getValue())


		populateSelf: ->
			if @model
				apiFormat = @options.apiFormat

				property = @options.property
				val = @model.get(property)
				if val
					@$('input').val(val)