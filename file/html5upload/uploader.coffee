define ['jquery', 'components/file/html5upload/fileCollection', 'components/file/html5upload/fileCollectionView', 'backbone'], ($, UploadFileCollection, UploadFileCollectionView, Backbone) ->
	class Uploader
		constructor: (element, params, uploaderView) ->
			@collection = new UploadFileCollection
			
			@collection.element = element
			@collection.params = params
			@collection.setup()
			uploaderView.collection = @collection

			

			@collectionView = uploaderView

		init: ->
			@collectionView.render()
	
