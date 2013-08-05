// Generated by CoffeeScript 1.6.2
/*
 * This class creates a bootstrap typeahead element
 * with an AJAX data source for either a has_many or 
 * many_many relationship with the main model.
 *
 * The main model's API should return an array of objects 
 * with properties "id" and "label" so that this field can 
 * be pre-populated, and the data source for this field should 
 * return the same format.
 *
 * E.g,
 *
 * [
 * 	{id:1, label:'Object 1'},
 * 	{id:2, label:'Object 2'}
 * ]
 *
 * The pre-existing and chosen values are shown in a UL with
 * a remove button.
 *
 * The actual API can handle this field either as a has_many 
 * or many_many relationship, it it exactly the same from a 
 * front-end standpoint
 *
 * You optionally can specify a "display" property in the field 
 * config as a function that takes the LI element and the object 
 * label and performs any additional UI process on it.
 * 
 *
 * @package  Shoresh
 * @subpackage  Form
 * @author  Jason Raede <j@jasonraede.com>
 * 
 * -------------
 * Requirements:
 * -------------
 *
 * Twitter Bootstrap Typeahead
 * @url  http://twitter.github.io/bootstrap/javascript.html
 *
 * Twitter Bootstrap CSS
 * @url  http://twitter.github.io/bootstrap/index.html
 *
 * Font Awesome (for default "remove" button icon)
 * @url  http://fortawesome.github.io/Font-Awesome/
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['core/form/field', 'jquery', 'core/ui/bootstrap/typeahead'], function(Field, $) {
    var TypeaheadAjaxSingle;

    return TypeaheadAjaxSingle = (function(_super) {
      __extends(TypeaheadAjaxSingle, _super);

      function TypeaheadAjaxSingle() {
        TypeaheadAjaxSingle.__super__.constructor.apply(this, arguments);
        this.value = null;
      }

      TypeaheadAjaxSingle.prototype.render = function() {
        var input, label;

        label = $('<label/>').html(this.options.label).appendTo(this.$el);
        input = $('<input type="text"/>').appendTo(this.$el);
        if (this.options.help) {
          $('<p class="help-block"/>').html(this.options.help).insertBefore(input);
        }
        this.postRender();
        return this.$el;
      };

      TypeaheadAjaxSingle.prototype.postRender = function() {
        var _this = this;

        this.searchField = this.$('input[type="text"]');
        this.searchField.attr('autocomplete', 'off');
        this.searchField.typeahead({
          source: function(query, process) {
            console.log('typing...');
            if (_this.options.onStartTyping && typeof _this.options.onStartTyping === 'function') {
              _this.options.onStartTyping;
            }
            return $.getJSON(_this.options.dataSourceUrl, {
              q: query
            }, function(response) {
              var result, results, _i, _len;

              results = [];
              console.log('got response:', response);
              for (_i = 0, _len = response.length; _i < _len; _i++) {
                result = response[_i];
                results.push(result.id + '@@@@' + result.label);
              }
              return process(results);
            });
          },
          highlighter: function(item) {
            var parts;

            parts = item.split('@@@@');
            parts.shift();
            return parts.join('@@@@');
          },
          updater: function(item) {
            var id, label, parts;

            parts = item.split('@@@@');
            id = parts.shift();
            label = parts.shift();
            _this.value = {
              id: id,
              label: label
            };
            if (_this.options.onSelect && typeof _this.options.onSelect === 'function') {
              _this.options.onSelect(_this.value);
            }
            return label;
          }
        });
        return TypeaheadAjaxSingle.__super__.postRender.apply(this, arguments);
      };

      TypeaheadAjaxSingle.prototype.getValue = function() {
        return this.value;
      };

      TypeaheadAjaxSingle.prototype.populateSelf = function() {
        var property, val;

        property = this.options.property;
        if (this.model) {
          val = this.model.get(property);
          if (typeof val === 'object') {
            this.value = val;
            return this.searchField.val(val.label);
          }
        }
      };

      return TypeaheadAjaxSingle;

    })(Field);
  });

}).call(this);
