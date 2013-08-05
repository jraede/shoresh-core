# Utility methods for strings
define [], ->
	class Inflector
		@camelize: (string) ->
			length = string.length - 1
			returnString = ''
			for i in [0..length] by 1
				if string[i] is string[i].toUpperCase()
					returnString += '_' + string[i].toLowerCase()
				else
					returnString += string[i]
			return returnString
		@humanize: (string) ->
			length = string.length - 1
			returnString = string[0].toUpper()
			for i in [1..length] by 1

				if string[i] is '_' or string[i] is '-'
					returnString += ' '
				else
					returnString += string[i]

			return returnString

		@nth: (n) ->
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
