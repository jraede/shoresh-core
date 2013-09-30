// Generated by CoffeeScript 1.6.3
/*
 * This class is for a collection that extends the Backbone.Paginator
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'backbone'], function($, Backbone) {
    var PaginationView, _ref;
    return PaginationView = (function(_super) {
      __extends(PaginationView, _super);

      function PaginationView() {
        _ref = PaginationView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PaginationView.prototype.tagName = 'div';

      PaginationView.prototype.className = 'btn-group paginated';

      PaginationView.prototype.events = {
        'click a': 'goToPage'
      };

      PaginationView.prototype.initialize = function() {
        return this.listenTo(this.collection, 'sync', this.render);
      };

      PaginationView.prototype.goToPage = function(e) {
        var page;
        page = $(e.currentTarget).data('page');
        return this.collection.goTo(page);
      };

      PaginationView.prototype.render = function() {
        var currentPage, diff, i, li, max, min, nextPageButton, pagesOnEachSideOfCurrent, pagesToShow, prevPageButton, totalPages, _i;
        this.$el.empty();
        this.container = $('<ul class="pagination hidden-print"/>').appendTo(this.$el);
        totalPages = this.collection.info().totalPages;
        _log.info(this.collection.info());
        currentPage = this.collection.currentPage;
        if (totalPages < 2) {
          return;
        }
        if (this.options.prevPageButton) {
          li = $('<li/>').appendTo(this.container);
          prevPageButton = $('<a href="#"/>').data('page', currentPage - 1).html("&laquo;").appendTo(li);
          if (currentPage < 2) {
            prevPageButton.attr('disabled', 'disabled');
          }
        }
        pagesToShow = this.options.pagesToShow > 0 ? this.options.pagesToShow : 5;
        if (!pagesToShow % 2) {
          pagesToShow++;
        }
        if (totalPages < pagesToShow) {
          min = 1;
          max = totalPages;
        } else {
          pagesOnEachSideOfCurrent = (pagesToShow - 1) / 2;
          min = currentPage - pagesOnEachSideOfCurrent;
          max = currentPage + pagesOnEachSideOfCurrent;
          if (min < 1) {
            diff = 1 - min;
            min = 1;
            max = max + diff;
          } else if (max > totalPages) {
            diff = max - totalPages;
            min = min - diff;
            max = totalPages;
          }
        }
        for (i = _i = min; _i <= max; i = _i += 1) {
          li = $('<li/>').appendTo(this.container);
          if (i === currentPage) {
            li.addClass('active');
          }
          $('<a href="#"/>').data('page', i).html(i.toString()).appendTo(li);
        }
        if (this.options.nextPageButton) {
          li = $('<li/>').appendTo(this.container);
          nextPageButton = $('<a href="#"/>').data('page', currentPage + 1).html("&raquo;").appendTo(li);
          if (currentPage >= totalPages) {
            nextPageButton.attr('disabled', 'disabled');
          }
        }
        $('<h2 class="visible-print"/>').html('Page ' + currentPage.toString()).appendTo(this.$el);
        return this.delegateEvents();
      };

      return PaginationView;

    })(Backbone.View);
  });

}).call(this);
