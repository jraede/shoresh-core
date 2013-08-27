define ['core/views/templated'], (TemplatedView) ->
	class ModelRow extends TemplatedView
		tagName:'tr'
		events:
			'click .delete':'delete'
		initialize: ->
			@listenTo(@model, 'sync', @render)
		
		deleteMessage:'Delete this tenant? This will archive all related payments and notices.'
		delete:(e)->
			e.preventDefault()
			if confirm(@deleteMessage)
				@$el.addClass('danger')
				@$('a, button, input, select, textarea').attr('disabled', 'disabled')
				@model.destroy
					success:=>
						@remove()
