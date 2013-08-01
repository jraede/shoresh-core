define [], ->
	class FieldFactory
		@generate: (config, callback) ->
			require ['components/form/fields/' + config.type], (Field) ->
				field = new Field(config)
				callback(field)