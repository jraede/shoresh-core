// Generated by CoffeeScript 1.6.2
/*
 * Requirements:
 *
 *
 * Twitter Bootstrap CSS
 * @url  http://twitter.github.io/bootstrap/index.html
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['components/ui/bootstrap/bootstrap', 'components/form/fields/text'], function(Text) {
    var BootstrapTypeahead, _ref;

    return BootstrapTypeahead = (function(_super) {
      __extends(BootstrapTypeahead, _super);

      function BootstrapTypeahead() {
        _ref = BootstrapTypeahead.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      BootstrapTypeahead.prototype.postRender = function() {
        BootstrapTypeahead.__super__.postRender.apply(this, arguments);
        return this.$('input').typeahead({
          source: this.options.options
        });
      };

      return BootstrapTypeahead;

    })(Text);
  });

}).call(this);
