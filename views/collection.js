// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'core/views/modelRow'], function(Backbone, TableRowView) {
    var CollectionView, _ref;
    return CollectionView = (function(_super) {
      __extends(CollectionView, _super);

      function CollectionView() {
        _ref = CollectionView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CollectionView.prototype.initialize = function() {
        this.listenTo(this.collection, 'add', this.addNew);
        return this.listenTo(this.collection, 'sync', this.render);
      };

      CollectionView.prototype.idPrefix = 'obj-';

      CollectionView.prototype.modelView = TableRowView;

      CollectionView.prototype.addNew = function(obj) {
        var before, index, view;
        _log.info('adding', obj);
        view = new this.modelView({
          model: obj,
          tagName: 'tr',
          id: this.idPrefix + obj.get('id')
        });
        if (!view.template) {
          view.options.template = this.options.modelTemplate;
        }
        index = this.collection.indexOf(obj);
        before = this.$('tr:eq(' + index.toString() + ')');
        if (before.length) {
          return before.before(view.render().el);
        } else {
          return this.$el.append(view.render().el);
        }
      };

      CollectionView.prototype.render = function() {
        var _this = this;
        this.$el.empty();
        return this.collection.each(function(obj) {
          return _this.addNew(obj);
        });
      };

      return CollectionView;

    })(Backbone.View);
  });

}).call(this);
