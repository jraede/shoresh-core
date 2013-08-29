define ['jquery', 'core/views/templated', 'core/ui/bootstrap/modal'], ($, TemplatedView) ->
	class ModalView extends TemplatedView
		tagName:'div'
		className:'modal fade'

		setup: ->
			@formView = @model.generateForm(@$('.modal-content'), ['name', 'move_in_date', 'rent', 'due', 'phone_home', 'phone_work', 'additional_tenants'])
			@formView.render()
		show: ->
			@$el.modal('show')

		hide: ->
			@$el.modal('hide')

		