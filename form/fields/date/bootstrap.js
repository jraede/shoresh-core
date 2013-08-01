// Generated by CoffeeScript 1.6.2
/*
 * This creates a date field using the Bootstrap Datepicker by Andrew Rowls
 *
 * Note that Shoresh uses Moment.js as its core date handler. Moment and the datepicker
 * datepicker have different format. So, the displayFormat option uses the datepicker format
 * and the apiFormat option uses the Moment format
 *
 * Note this isn't compatible with the jQuery UI datepicker because they have the same
 * method name on the jQuery object. So it's either or (I can't really understand why you
 * would want both anyway...)
 *
 * @author  Jason Raede
 * @package  Shoresh
 * @subpackage  Form
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['components/form/fields/text', 'jquery', 'moment', 'components/date/bootstrap-datepicker/datepicker'], function(Text, $, moment) {
    var BootstrapDate, _ref;

    return BootstrapDate = (function(_super) {
      __extends(BootstrapDate, _super);

      function BootstrapDate() {
        _ref = BootstrapDate.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      BootstrapDate.prototype.postRender = function() {
        this.$('input').datepicker({
          format: this.options.displayFormat,
          autoclose: true
        });
        return BootstrapDate.__super__.postRender.apply(this, arguments);
      };

      BootstrapDate.prototype.populateModel = function() {
        var apiFormat, converted, date, property;

        date = moment(this.$('input').datepicker('getDate'));
        property = this.options.property;
        if (date) {
          apiFormat = this.options.apiFormat;
          converted = date.format(apiFormat);
          return this.model.set(property, converted);
        } else {
          return this.model.set(property, null);
        }
      };

      BootstrapDate.prototype.populateSelf = function() {
        var apiFormat, date, property, val;

        apiFormat = this.options.apiFormat;
        property = this.options.property;
        val = this.model.get(property);
        if (val) {
          date = moment(val, apiFormat);
          return this.$('input').datepicker('setDate', date.toDate());
        }
      };

      return BootstrapDate;

    })(Text);
  });

}).call(this);
