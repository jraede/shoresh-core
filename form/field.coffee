define ['backbone', 'core/form/validator'], (Backbone, Validator)->
	class Field extends Backbone.View
		tagName:'div'
		className:'form-group'
		form:null

		initialize: ->
			super
			@validator = new Validator(@options.rules, @)
		###
		 * Override this method to get the value of the field that will get
		 * set on the model
		###
		getValue: ->
			return @$el.find('input').val()

		postRender: ->
			@populateSelf()
			# add anything you want here
		
		populateModel: ->
			property = @options.property
			@model.set(property, @getValue())

		populateSelf: ->
			if @model
				property = @options.property
				val = @model.get(property)
				@$('input').val(val)

		displayErrors: (errors) ->
			for error in errors
				
				@form.displayError(@options.property, error)
				
		validate: (suppressErrors) ->
			if @validator.run(@getValue())
				return true
			else if !suppressErrors
				@displayErrors(@validator.errors)
			return false


