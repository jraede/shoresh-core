// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['core/form/fields/text', 'jquery', 'core/form/priceMask'], function(Text, $) {
    var Price;
    return Price = (function(_super) {

      __extends(Price, _super);

      function Price() {
        return Price.__super__.constructor.apply(this, arguments);
      }

      Price.prototype.postRender = function() {
        Price.__super__.postRender.apply(this, arguments);
        return this.$('input').priceMask();
      };

      Price.prototype.getValue = function() {
        var price;
        price = this.$('input').val();
        return price.replace(/[^0-9\.]/g, '');
      };

      Price.prototype.populateModel = function() {
        var property;
        property = this.options.property;
        return this.model.set(property, this.getValue());
      };

      Price.prototype.populateSelf = function() {
        var apiFormat, property, val;
        if (this.model) {
          apiFormat = this.options.apiFormat;
          property = this.options.property;
          val = this.model.get(property);
          if (val) {
            return this.$('input').val(val);
          }
        }
      };

      return Price;

    })(Text);
  });

}).call(this);
