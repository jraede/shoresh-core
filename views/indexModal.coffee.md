	define ['jquery', 'core/views/modal', 'core/views/collection'], ($, ModalView, CollectionView, _, TableRowView, PrivilegeModel, PrivilegeCollection) ->
		class IndexModal extends ModalView
			setup: ->

				collectionView = new CollectionView
					collection:@collection
					el:@$('tbody')
					modelTemplate:@options.modelTemplate

				if @options.modelView
					_log.info 'setting model view to ', @options.modelView
					collectionView.modelView = @options.modelView

				collectionView.render()