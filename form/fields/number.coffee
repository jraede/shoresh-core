define ['jquery', 'core/form/field'], ($, Field) ->
	class Number extends Field
		
		render:->
			label = $('<label/>').html(@options.label).appendTo @$el
			input = $('<input type="number"/>').addClass('form-control').val(@val).appendTo @$el

			if @options.help
				$('<p class="help-block"/>').html(@options.help).insertBefore input

			@postRender()

			return @$el
