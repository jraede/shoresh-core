define ['jquery', 'core/form/field'], ($, Field) ->
	class Select extends Field
		
		render:->
			label = $('<label/>').html(@options.label).appendTo @$el
			
			if @options.help
				$('<p class="help-block"/>').html(@options.help).insertAfter label

			@postRender()

			return @$el
		postRender:->
			super
			if !@$('select').length
				select = $('<select class="form-control"/>').appendTo @$el
			else
				select = @$('select')
				
			if @options.options and !@$('select option').length
				if @options.options instanceof Array
					for val in @options.options
						$('<option/>').val(val).html(val).appendTo(select)
						
				else if typeof @options.options is 'object'
					for val, label of @options.options
						$('<option/>').val(val).html(label).appendTo(select)
		getValue: ->
			return @$el.find('select').val()
		populateSelf: ->
			property = @options.property
			val = @model.get(property)
			@$('select').val(val)
