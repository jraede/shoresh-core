define [], ->
	class Validator
		field:null
		rules:null
		errors:null
		constructor: (rules, field) ->
			@field = field
			@rules = rules
			@errors = []


		run: (value) ->
			#reset the errors
			@errors = []
			for rule, params of @rules
				# if params is a function, it's a custom rule
				if !@runRule(rule, params, value)
					@errors.push(rule)
			if @errors.length
				return false

			return true
				


		runRule: (rule, params, value) ->
			if typeof params is 'function'
				return params(value)
			else if typeof @['_rule_' + rule] is 'function'
				result = @['_rule_' + rule](value, params)
				return result
			
			return false






		# DEFAULT RULES:

		# Required: needs to be defined and non-null
		_rule_required: (value) ->
			if value and value isnt ''?
				return true
			return false

		_rule_minLength: (value, length) ->
			value = value.toString()
			if !value or value.length < length
				return false
			return true

		_rule_maxLength: (value, length) ->
			value = value.toString()
			if value and value.length > length
				return false
			return true

		_rule_matchRegex: (value, regex) ->
			if !(regex instanceof RegExp)
				console.error 'Argument for matchRegex is not a RegExp object'
				return false

			match = value.toString().match(regex);

			if match isnt null and value is match[0]
				return true
			return false

		_rule_validEmail: (value) ->
			regex = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/
			return if value.match(regex) then true else false

		_rule_validUrl: (value) ->
			regex = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi;
			return @_rule_matchRegex(value, regex)

		_rule_matchField: (value, field) ->
			# We need to get the other field's value
			otherField = @field.form.fields[field]

			if otherField
				if otherField.value() == value
					return true
				return false

			console.error 'Other field for _rule_matchField not found!'
			return false







