define ['jquery', 'core/form/field', 'backbone'], ($, Field, Backbone) ->
	class Text extends Field
		
		render:->
			label = $('<label/>').html(@options.label).appendTo @$el
			
			if @options.help
				$('<p class="help-block"/>').html(@options.help).insertAfter label

			@postRender()

			return @$el
		postRender:->
			super

			if @options.url and typeof @options.url is 'function'
				url = _.bind(@options.url, @model)()
			else 
				url = @options.url
				
			@collection = new Backbone.Collection
				model:@options.modelClass
				url:url

			@forms = []
			@$el.css
				position:'relative'

			@addButton = $('<button class="btn btn-success btn-small pull-right"/>').css
				position:'absolute'
				top:'0px'
				right:'0px'
				'-moz-border-radius-bottom-right':'0px'
				'-webkit-border-bottom-right-radius':'0px'
				'border-bottom-right-radius':'0px'
				'-moz-border-radius-top-left':'0px'
				'-webkit-border-top-left-radius':'0px'
				'border-top-left-radius':'0px'
			.html('<i class="icon-plus"></i>').click (e) =>
				console.log 'clicked on add button'
				e.preventDefault()
				@addNewModel()
			.prependTo @$el 
			@ul = $('<ul class="list-group"/>').appendTo(@$el)


			# Now we want to listen to the model and only update
			# our models after it's saved and we have the ID
			@listenTo @model, 'sync', @saveModels
			@listenTo @collection, 'add', @showNewModel

		populateSelf: ->
			if @options.getModelsViaAPI is true
				@collection.fetch()
			else
				property = @options.property

				val = @model.get(property)
				if val instanceof Array
					for obj in val

						@addNewModel(obj)

		addNewModel: (attr)->

			ModelClass = @options.modelClass
			if !(attr instanceof ModelClass)
				model = new ModelClass

				if attr and typeof attr is 'object'
					for key,val in attr
						model.set(key, val)
			else
				model = attr
			@collection.add(model)
		showNewModel:(model)->
			view = $('<li class="list-group-item"/>').css('position', 'relative').appendTo(@ul)

		
			form = model.generateForm(view)
			form.saveOnProcess = false
			# Add the "remove" button
			

			form.render =>
				removeButton = $('<button class="btn btn-danger btn-small pull-right"/>').css
					position:'absolute'
					top:'0px'
					right:'0px'
					'-moz-border-radius-bottom-right':'0px'
					'-webkit-border-bottom-right-radius':'0px'
					'border-bottom-right-radius':'0px'
					'-moz-border-radius-top-left':'0px'
					'-webkit-border-top-left-radius':'0px'
					'border-top-left-radius':'0px'
				.html('<i class="icon-remove"></i>').data('form', form).click (e) =>
					e.preventDefault()
					button = $(e.currentTarget)

					@removeForm(button.data('form'))
				.prependTo form.$el
			@forms.push(form)

		removeForm: (form) ->
			# Remove the form and check if we should also
			# destroy the model
			model = form.model
			form.remove()

			if @options.destroyModelOnRemove is true
				model.destroy()

		validate: (suppressErrors) ->
			validated = true
			for form in @forms
				if !@form.process()
					validated = false
			return validated

		saveModels:->
			keyFrom = @options.keyFrom
			keyTo = @options.keyTo
			for form in @forms
				form.model.set(keyTo, @model.get(keyFrom))
				form.model.save()


