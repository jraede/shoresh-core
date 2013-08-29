define [], ->
	window._log = 
		microtime: ->
				
			unixtime_ms = new Date().getTime()
			diff = unixtime_ms - @bootTime

			return (diff/1000)

		info: ->
			if shoreshConfig.debug is true
				console.log 'LOG [' + @microtime().toString() + '] ', arguments
		

		error: ->
			if shoresnConfig.debug is true
				console.error 'ERROR [' + @microtime().toString() + '] ', arguments

	window.inflector = 
		camelize: (string) ->
			length = string.length - 1
			returnString = ''
			for i in [0..length] by 1
				if string[i] is string[i].toUpperCase()
					returnString += '_' + string[i].toLowerCase()
				else
					returnString += string[i]
			return returnString
		humanize: (string) ->
			length = string.length - 1
			returnString = string[0].toUpper()
			for i in [1..length] by 1

				if string[i] is '_' or string[i] is '-'
					returnString += ' '
				else
					returnString += string[i]

			return returnString

		ordinalize: (n) ->
			n = n.toString()
			last = n[n.length - 1]
			if !isNaN(parseInt(n)) && isFinite(n)
				if last is '1'
					return n + 'st'
				else if last is '2'
					return n + 'nd'
				else if last is '3'
					return n + 'rd'
				else
					return n + 'th'
			else
				return n

	window.formatString = (string, format) ->
		length = string.length - 1
		for i in [0..length] by 1
			format = format.replace(/X/, string[i])

		return format

	window.roundNumber = (number, decimals = 0) ->
		multiplier = Math.pow(10, decimals);


		number = Math.round(parseFloat(number) * multiplier) / multiplier

		return number

	window.formatNumber = (number, decimals) ->

		if !number
			final = '0'
			if decimals
				final += '.'
				for i in [1..decimals] by 1
					final += '0'
			return final

			
		val = number.toString().replace(/[^0-9\.\-]/g, '')

		if val.substr(0,1) is '-'
			isNegative = true
			val = (parseFloat(val) * -1).toString()
		else
			isNegative = false

		

		
		val = roundNumber(parseFloat(val), decimals).toString()

		index = val.indexOf('.')
		if index >= 0
			if val.length - (index + 1) is 1
				val = val + '0'
		else
			val = val + '.00'

		# Add commas
		split = val.split('.')
		whole = split[0].split('').reverse().join('')
		newVal = ''
		for i in [1..whole.length] by 1
			key = i-1
			
			newVal += whole[key]
			if !(i%3) and i isnt whole.length
				newVal += ','
			
		newVal = newVal.split('').reverse().join('')
		final = newVal
		if split[1]
			final += '.' + split[1]

		if isNegative
			final = '-' + final

		return final
