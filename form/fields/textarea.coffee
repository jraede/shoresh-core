define ['jquery', 'core/form/field'], ($, Field) ->
	class TextArea extends Field
		
		render:->
			label = $('<label/>').html(@options.label).appendTo @$el
			input = $('<textarea/>').addClass('form-control').val(@val).appendTo @$el

			if @options.help
				$('<p class="help-block"/>').html(@options.help).insertBefore input

			@postRender()

			return @$el
		getValue: ->
			return @$('textarea').val()
		populateSelf: ->
			property = @options.property
			val = @model.get(property)
			@$('textarea').val(val)
