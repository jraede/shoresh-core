define ['jquery','core/views/templated', 'core/views/formModal','core/ui/bootstrap/tooltip'], ($, TemplatedView, FormModal) ->
	class ModelRow extends TemplatedView
		tagName:'div'
		className:'tr'
		events:
			'click .delete':'delete'
			'click .edit':'edit'
		initialize: ->
			@listenTo(@model, 'sync', @render)
		deleteMessage:'Delete this object?'
		delegateEvents: ->
			# Apply tooltip, then super
			@$('[title]').tooltip()

			super
		delete:(e)->
			e.preventDefault()
			if confirm(@deleteMessage)
				@$el.addClass('danger')
				@$('a, button, input, select, textarea').attr('disabled', 'disabled')
				@model.destroy
					success:=>
						@remove()

		edit:(e) ->
			if e then e.preventDefault()
			# Lazy generation of edit modal
			if !@editModal
				@editModal = new FormModal
					model:@model
					template:@options.template.replace('row', 'modal-form')
				if @formFields
					@editModal.options.formFields = @formFields

				@editModal.render =>
					@editModal.show()
				.$el.appendTo($('body'))
			else
				@editModal.show()
