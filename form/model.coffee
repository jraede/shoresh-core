define ['backbone', 'components/form/formView'], (Backbone, FormView) ->
	class FormModel extends Backbone.Model
		fieldConfig:null	
		formViewClass:FormView

		getFieldConfig: (field) ->
			return @fieldConfig[field]

		getErrorMessage:(fieldName, rule) ->
			return "Validation rule " + rule + " failed!"



		###
		 * This returns a Form form View object that is either rendered
		 * completely by itself OR taken from an already generated form (el).
		 *
		 * If el is a legit DOM element, we check to see if it contains elements
		 * with data-field=XXX. Those are assumed to be the container elements
		 * for each form field. If those do not exist, they are generated
		 * and appended to the end of el.
		 *
		 * If el is not provided, then the form will be generated completely with
		 * JavaScript and be returned as a subclass of Backbone.View. Then that view's
		 * element can be placed wherever you need it and the form will be there.
		 *
		 * @param { jQuery Object} el The existing element you want to render the form inside
		 * @param { array} fields The fields you want to include in the form. Leave blank for all 
		 *                 			fields (except hidden/system ones obviously)
		###
		generateForm: (el, fields) ->
			if el and el.jquery and el.length
				console.log 'generated with el'

				form = new @formViewClass
					el:el.get(0)
					model:@
					fields:fields
			else
				form = new @formViewClass
					model:@
					fields:fields
			return form


