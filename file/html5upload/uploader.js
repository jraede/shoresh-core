// Generated by CoffeeScript 1.6.2
(function() {
  define(['jquery', 'core/file/html5upload/fileCollection', 'core/file/html5upload/fileCollectionView', 'backbone'], function($, UploadFileCollection, UploadFileCollectionView, Backbone) {
    var Uploader;

    return Uploader = (function() {
      function Uploader(element, params, uploaderView) {
        this.collection = new UploadFileCollection;
        this.collection.element = element;
        this.collection.params = params;
        this.collection.setup();
        uploaderView.collection = this.collection;
        this.collectionView = uploaderView;
      }

      Uploader.prototype.init = function() {
        return this.collectionView.render();
      };

      return Uploader;

    })();
  });

}).call(this);
