define ['backbone', 'core/views/modelRow'], (Backbone, TableRowView) ->
	class CollectionView extends Backbone.View
		initialize: ->
			_log.info 'initializing collection view with collection:', @collection
			@listenTo(@collection, 'add', @addNew)
			@listenTo(@collection, 'sync', @synced)
			#@listenTo(@collection, 'remove', @render)
		idPrefix:'obj-'
		modelView:TableRowView
		synced:(obj) ->
			if obj instanceof Backbone.Collection
				_log.info 'INSTANCE', @collection
				@render()
		addNew: (obj) ->
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
				@$el.append view.render().el
		render: ->
			@$el.empty()
			@collection.each (obj) =>
				@addNew(obj)