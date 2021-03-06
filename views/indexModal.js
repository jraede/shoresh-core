// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'core/views/modal', 'core/views/collection'], function($, ModalView, CollectionView, _, TableRowView, PrivilegeModel, PrivilegeCollection) {
    var IndexModal, _ref;
    return IndexModal = (function(_super) {
      __extends(IndexModal, _super);

      function IndexModal() {
        _ref = IndexModal.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      IndexModal.prototype.setup = function() {
        var collectionView;
        collectionView = new CollectionView({
          collection: this.collection,
          el: this.$('tbody'),
          modelTemplate: this.options.modelTemplate
        });
        if (this.options.modelView) {
          _log.info('setting model view to ', this.options.modelView);
          collectionView.modelView = this.options.modelView;
        }
        return collectionView.render();
      };

      return IndexModal;

    })(ModalView);
  });

}).call(this);
