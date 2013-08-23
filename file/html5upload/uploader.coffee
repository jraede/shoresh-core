define ['jquery', 'core/file/html5upload/fileCollection', 'core/file/html5upload/fileCollectionView', 'backbone', 'core/file/html5upload/file'], ($, UploadFileCollection, UploadFileCollectionView, Backbone, FileModel) ->
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


		addFile: (file, status) ->
			console.log 'adding file:', file
			model = new FileModel(file)
			model.set('status', status)
			@collection.add(model)
	
