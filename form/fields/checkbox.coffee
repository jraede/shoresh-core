define ['jquery', 'components/form/field'], ($, Field) ->
	class Checkbox extends Field
		tagName:'div'
		
		render:->
			label = $('<label/>').html(@options.label).appendTo @$el
			
			if @options.help
				$('<p class="help-block"/>').html(@options.help).insertAfter label
			@postRender()

			return @$el
		postRender:->
			super
			if !@$('input[type="checkbox"]').length
				if @options.options instanceof Array
					for val in @options.options
						div = $('<div class="checkbox"/>').appendTo(@$el)
						labelEl = $('<label class="checkbox"/>').html(val).appendTo(div)
						$('<input type="checkbox"/>').val(val).attr('name', @options.property + '[]').prependTo(labelEl)
				else if typeof @options.options is 'object'
					for val, label of @options.options

						div = $('<div class="checkbox"/>').appendTo(@$el)
						labelEl = $('<label class="checkbox"/>').html(label).appendTo(div)
						$('<input type="checkbox"/>').val(val).attr('name', @options.property + '[]').prependTo(labelEl)
		getValue: ->
			value = []

			
				
			@$('input:checked').each ->
				value.push $(@).val()

			return value
		populateSelf: ->
			property = @options.property

			val = @model.get(property)
			if val instanceof Array
				for value in val
					@$('input[value="' + value + '"]').attr('checked', 'checked')
			else
				@$('input[value="' + val + '"]').attr('checked', 'checked')
