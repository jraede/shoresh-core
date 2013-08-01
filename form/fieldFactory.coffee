define [], ->
	class FieldFactory
		@generate: (config, callback) ->
			require ['core/form/fields/' + config.type], (Field) ->
				field = new Field(config)
				callback(field)