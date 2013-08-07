define ['jquery', 'core/form/field', 'core/form/maskedInput'], ($, Field) ->
	$.mask.definitions['~']='[\d+]'
	class Mask extends Field
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
