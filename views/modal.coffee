define ['jquery', 'core/views/templated', 'core/ui/bootstrap/modal'], ($, TemplatedView) ->
	class ModalView extends TemplatedView
		tagName:'div'
		className:'modal fade'

		show: ->
			@$el.modal('show')

		hide: ->
			@$el.modal('hide')

		