define ['jquery', 'components/form/field', 'components/form/maskedInput'], ($, Field) ->
	class Text extends Field
		tagName:'div'
		
		render:->
			label = $('<label/>').html(@options.label).appendTo @$el
			input = $('<input type="text"/>').val(@val).appendTo @$el
			if @options.help
				$('<p class="help-block"/>').html(@options.help).insertBefore input
			@postRender()

			return @$el
		postRender: ->
			super
			@$('input').mask(@options.mask);
