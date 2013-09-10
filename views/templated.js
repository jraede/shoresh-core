// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'core/ui/template'], function(Backbone, Template) {
    var TemplatedView, _ref;
    return TemplatedView = (function(_super) {
      __extends(TemplatedView, _super);

      function TemplatedView() {
        _ref = TemplatedView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      TemplatedView.prototype.setup = function() {};

      TemplatedView.prototype.render = function(callback) {
        var _this = this;
        this.$el.empty();
        Template.load(this.options.template, function(view) {
          if (_this.model) {
            _this.$el.html(_.template(view, _this.model.toTemplate()));
          } else {
            _this.$el.html(_.template(view, _this.options.templateAttributes));
          }
          _this.delegateEvents();
          _this.setup();
          if (callback && typeof callback === 'function') {
            return callback();
          }
        });
        return this;
      };

      return TemplatedView;

    })(Backbone.View);
  });

}).call(this);
