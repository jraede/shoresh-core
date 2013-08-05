define [], ->
	formatString = (string, format) ->
		length = string.length - 1
		for i in [0..length] by 1
			format = format.replace(/X/, string[i])

		return format
