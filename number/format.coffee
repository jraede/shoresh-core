define ['core/number/helper'], (NumberHelper) ->
	format = (number, decimals) ->
		if !number
			final = '0'
			if decimals
				final += '.'
				for i in [1..decimals] by 1
					final += '0'
			return final

		val = number.toString().replace(/[^0-9\.]/g, '')
		number = NumberHelper.round(parseFloat(val), decimals)
		
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

		return final
