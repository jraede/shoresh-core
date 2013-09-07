define ['core/views/templated', 'core/views/formModal'], (TemplatedView, FormModal) ->
	class ModelRow extends TemplatedView
		tagName:'tr'
		events:
			'click .delete':'delete'
			'click .edit':'edit'
		initialize: ->
			@listenTo(@model, 'sync', @render)
		
		deleteMessage:'Delete this object?'
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
			_log.info 'edit modal with model:', @model
			# Lazy generation of edit modal
			if !@editModal
				@editModal = new FormModal
					model:@model
					template:@options.template.replace('row', 'modal-form')

				@editModal.render =>
					@editModal.show()
				.$el.appendTo($('body'))
			else
				@editModal.show()
