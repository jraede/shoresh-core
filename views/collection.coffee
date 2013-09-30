define ['backbone', 'core/views/modelRow'], (Backbone, TableRowView) ->
	class CollectionView extends Backbone.View
		initialize: ->
			_log.info @collection
			@listenTo(@collection, 'add', @addNew)
			@listenTo(@collection, 'sync', @synced)
			#@listenTo(@collection, 'remove', @render)
		idPrefix:'obj-'
		modelView:TableRowView
		synced:(obj) ->
			if obj instanceof Backbone.Collection
				_log.info @collection
				@render()
		addNew: (obj) ->
			_log.info 'adding new'
			options = 
				model:obj
				tagName:'div'
				className:'tr'
				id:@idPrefix+obj.get('id')

			if @options.modelViewConfig
				options = _.extend(options, @options.modelViewConfig)
			view = new @modelView options
			
			if !view.template
				view.options.template = @options.modelTemplate

			index = @collection.indexOf(obj)
			before = @$('.tr:eq(' + index.toString() + ')')
			if before.length
				before.before view.render().el
			else
				_log.info @el
				@$el.append view.render().el
		render: ->
			_log.info 'RENDERING collection:', @collection.models
			@$el.empty()
			@collection.each (obj) =>
				@addNew(obj)