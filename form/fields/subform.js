// Generated by CoffeeScript 1.6.2
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'components/form/field', 'backbone'], function($, Field, Backbone) {
    var Text, _ref;

    return Text = (function(_super) {
      __extends(Text, _super);

      function Text() {
        _ref = Text.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Text.prototype.render = function() {
        var label;

        label = $('<label/>').html(this.options.label).appendTo(this.$el);
        if (this.options.help) {
          $('<p class="help-block"/>').html(this.options.help).insertAfter(label);
        }
        this.postRender();
        return this.$el;
      };

      Text.prototype.postRender = function() {
        var url,
          _this = this;

        Text.__super__.postRender.apply(this, arguments);
        if (this.options.url && typeof this.options.url === 'function') {
          url = _.bind(this.options.url, this.model)();
        } else {
          url = this.options.url;
        }
        this.collection = new Backbone.Collection({
          model: this.options.modelClass,
          url: url
        });
        this.forms = [];
        this.$el.css({
          position: 'relative'
        });
        this.addButton = $('<button class="btn btn-success btn-small pull-right"/>').css({
          position: 'absolute',
          top: '0px',
          right: '0px',
          '-moz-border-radius-bottom-right': '0px',
          '-webkit-border-bottom-right-radius': '0px',
          'border-bottom-right-radius': '0px',
          '-moz-border-radius-top-left': '0px',
          '-webkit-border-top-left-radius': '0px',
          'border-top-left-radius': '0px'
        }).html('<i class="icon-plus"></i>').click(function(e) {
          console.log('clicked on add button');
          e.preventDefault();
          return _this.addNewModel();
        }).prependTo(this.$el);
        this.ul = $('<ul class="list-group"/>').appendTo(this.$el);
        this.listenTo(this.model, 'sync', this.saveModels);
        return this.listenTo(this.collection, 'add', this.showNewModel);
      };

      Text.prototype.populateSelf = function() {
        var obj, property, val, _i, _len, _results;

        if (this.options.getModelsViaAPI === true) {
          return this.collection.fetch();
        } else {
          property = this.options.property;
          val = this.model.get(property);
          if (val instanceof Array) {
            _results = [];
            for (_i = 0, _len = val.length; _i < _len; _i++) {
              obj = val[_i];
              _results.push(this.addNewModel(obj));
            }
            return _results;
          }
        }
      };

      Text.prototype.addNewModel = function(attr) {
        var ModelClass, key, model, val, _i, _len;

        ModelClass = this.options.modelClass;
        if (!(attr instanceof ModelClass)) {
          model = new ModelClass;
          if (attr && typeof attr === 'object') {
            for (val = _i = 0, _len = attr.length; _i < _len; val = ++_i) {
              key = attr[val];
              model.set(key, val);
            }
          }
        } else {
          model = attr;
        }
        return this.collection.add(model);
      };

      Text.prototype.showNewModel = function(model) {
        var form, view,
          _this = this;

        view = $('<li class="list-group-item"/>').css('position', 'relative').appendTo(this.ul);
        form = model.generateForm(view);
        form.saveOnProcess = false;
        form.render(function() {
          var removeButton;

          return removeButton = $('<button class="btn btn-danger btn-small pull-right"/>').css({
            position: 'absolute',
            top: '0px',
            right: '0px',
            '-moz-border-radius-bottom-right': '0px',
            '-webkit-border-bottom-right-radius': '0px',
            'border-bottom-right-radius': '0px',
            '-moz-border-radius-top-left': '0px',
            '-webkit-border-top-left-radius': '0px',
            'border-top-left-radius': '0px'
          }).html('<i class="icon-remove"></i>').data('form', form).click(function(e) {
            var button;

            e.preventDefault();
            button = $(e.currentTarget);
            return _this.removeForm(button.data('form'));
          }).prependTo(form.$el);
        });
        return this.forms.push(form);
      };

      Text.prototype.removeForm = function(form) {
        var model;

        model = form.model;
        form.remove();
        if (this.options.destroyModelOnRemove === true) {
          return model.destroy();
        }
      };

      Text.prototype.validate = function(suppressErrors) {
        var form, validated, _i, _len, _ref1;

        validated = true;
        _ref1 = this.forms;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          form = _ref1[_i];
          if (!this.form.process()) {
            validated = false;
          }
        }
        return validated;
      };

      Text.prototype.saveModels = function() {
        var form, keyFrom, keyTo, _i, _len, _ref1, _results;

        keyFrom = this.options.keyFrom;
        keyTo = this.options.keyTo;
        _ref1 = this.forms;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          form = _ref1[_i];
          form.model.set(keyTo, this.model.get(keyFrom));
          _results.push(form.model.save());
        }
        return _results;
      };

      return Text;

    })(Field);
  });

}).call(this);
