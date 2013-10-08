core/utilities
===

**Package**: Shoresh

**Subpackage**: Core

This file contains all global utility methods used throughout Shoresh and its packages.

---

	define [], ->

_log
---

You can log output to the console with `_log.info` or `_log.error` and not have to worry about commenting it all out when you push your app to production. Just set `debug` to `false` in the configuration and nothing will be logged.

		window._log = 

### _log.microtime

Get the # of seconds + milliseconds since page load

			microtime: ->
					
				unixtime_ms = new Date().getTime()
				diff = unixtime_ms - @bootTime

				return (diff/1000)
### _log.info
Log a variable number of arguments to the console

			info: ->
				if shoreshConfig.debug is true
					arguments.unshift('LOG [' + @microtime().toString() + ']')
					console.log.apply arguments
			
### _log.error
Log a variable number of arguments to the console as errors

			error: ->
				if shoreshConfig.debug is true
					arguments.unshift('ERROR [' + @microtime().toString() + ']')
					console.error.apply arguments

inflector
---
This is based on FuelPHP's awesome `Inflector` class and is used to manipulate strings and convert them between formats.

		window.inflector = 

### inflector.camelize

Convert a snake_case string to CamelCase

			camelize: (string) ->
				length = string.length - 1
				returnString = ''
				for i in [0..length] by 1
					if string[i] is string[i].toUpperCase()
						returnString += '_' + string[i].toLowerCase()
					else
						returnString += string[i]
				return returnString

### inflector.humanize

Convert a snake_case string to human-readable, with spaces and capital letters

			humanize: (string) ->
				length = string.length - 1
				returnString = string[0].toUpper()
				for i in [1..length] by 1

					if string[i] is '_' or string[i] is '-'
						returnString += ' '
					else
						returnString += string[i]

				return returnString

### inflector.ordinalize

Add a suffix to a number

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

formatString
---

Takes a format and runs a string through it to create a formatted string. 
E.g. `formatString('5551234567', '(XXX) XXX-XXXX')` will yield `'(555) 123-4567'`

		window.formatString = (string, format) ->
			string = string.toString()
			match = format.match(/X/g);  
			if string.length != match.length
				return ''
			length = string.length - 1
			for i in [0..length] by 1
				format = format.replace(/X/, string[i])

			return format

roundNumber
---

Round a number to the desired number of decimal places

		window.roundNumber = (number, decimals = 0) ->
			multiplier = Math.pow(10, decimals);


			number = Math.round(parseFloat(number) * multiplier) / multiplier

			return number

formatNumber
---

Format a number by rounding to specified decimal places and adding commas for the thousands.

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
