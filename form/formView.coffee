define ['jquery', 'backbone', 'components/form/fieldFactory', 'underscore'], ($, Backbone, FieldFactory, _) ->
	class FormView extends Backbone.View
		tagName:'form'
		fields:null
		saveOnProcess:true
		events:
			'click input[type="submit"]':'process'

		# This method handles error message rendering so it can be customized
		# and the field classes do not have to be overrode
		displayError:(field, error) ->
			fieldEl = @fields[field].$el
			fieldEl.addClass('has-error')
			message = @model.getErrorMessage(field, error)
			p = $('<p class="alert alert-danger"/>').html(message).prependTo(fieldEl)
			setTimeout ->
				p.remove()
			, 2000
		



		fieldOrder:null
		formPreRendered:false
		reorderFields:->
			if !@formPreRendered
				@fieldOrder.reverse()
				for field in @fieldOrder
					@fields[field].$el.prependTo(@$el)
		render: (callback) ->
			@fields = {}
			# If options.fields is set, use those. Otherwise use all
			# fields on the model.

			if @options.fields
				fields = @options.fields
			else
				fields = []
				for k, i of @model.fieldConfig
					fields.push(k)

			@fieldOrder = fields

			# Reorder the fields after they've all been loaded, so they're in the correct order
			reorderFields = _.after(_.keys(fields).length, _.bind(@reorderFields, @))
			if callback
				runCallback = _.after(_.keys(fields).length, callback)

			# Now that we have the fields, check if each one exists in the form or not.
			# Ignore this part if there was no $el passed in options
			for field in fields
				config = @model.getFieldConfig(field)
				config.property = field
				if !config
					console.error 'field config not found for ' + field
					break

				FieldFactory.generate config, (FieldView) =>
					FieldView.model = @model
					field = FieldView.options.property
					# If it already is in the dom, no need to append
					if @options.el
						$el = @$el.find('[data-field="' + field + '"]')
						if $el.length
							@formPreRendered = true
							FieldView.$el = $el
							FieldView.el = $el.get(0)
							FieldView.postRender()
							@fields[field] = FieldView
							FieldView.form = @
							reorderFields()
							if runCallback
								runCallback()
							return
					FieldView.render().appendTo(@$el)

					@fields[field] = FieldView
					FieldView.form = @
					reorderFields()
					if runCallback
						runCallback()


		process: (e)->
			if e
				e.preventDefault()
			validated = true
			for name, field of @fields
				if !field.validate()
					validated = false
			if validated
				for name, field of @fields
					field.populateModel()
					field.$el.removeClass('has-error')
				@model.trigger('change')
				
				if @saveOnProcess
					@model.save()

			return validated