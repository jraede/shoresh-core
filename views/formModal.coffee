define ['core/views/modal'], (ModalView) ->
	class FormModal extends ModalView
		events:
			'click .save':'save'
		initialize: ->
			@listenTo @model, 'sync', @hide
			super
		setup: ->
			@formView = @model.generateForm(@$('.modal-body'))
			@formView.render()
			_log.info @formView
		save: (e) ->
			@formView.process e,
				btn:@$('.save')


