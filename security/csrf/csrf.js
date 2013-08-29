// Generated by CoffeeScript 1.6.2
/*
 * This class just adds a CSRF token to all AJAX requests to prevent
 * CSRF attacks. The presence of this token means that as long as it 
 * isn't discovered by an attacker (IE, it isn't sniffed somehow), we can 
 * prevent attackers from tricking the user into submitting
 * a form, etc.
 *
 * The only way an attacker can take advantage of the user's session, which 
 * marks them as logged in, is via a form. This prevents that.
 *
 * Your API endpoint needs to provide a JSON response with a "token" property, 
 * which will then be sent along with every subsequent AJAX request as part
 * of the URL query string (http://myapi.com/endpoint/?token=xyz)
 * 
 * @author Jason Raede
*/


(function() {
  define(['jquery'], function($) {
    var CSRF;

    return CSRF = (function() {
      /*
      		 * @var {string} The server URL that handles authorization
      */
      CSRF.prototype.endpoint = null;

      /*
      		 * The authorization token received from the server
      */


      CSRF.prototype.token = null;

      function CSRF(endpoint) {
        this.endpoint = endpoint;
      }

      /*
      		 * Get a CSRF token from a server
      		 *
      */


      CSRF.prototype.request = function(options) {
        var error, invalid, success,
          _this = this;

        success = options.success;
        invalid = options.invalid;
        error = options.error;
        return $.ajax({
          type: 'GET',
          url: this.endpoint,
          dataType: 'json',
          success: function(response) {
            if (response.token) {
              _this.token = response.token;
              _this.bindSubsequentAjaxMethods();
              if (success) {
                return success(response);
              }
            } else if (invalid) {
              _log('Invalid CSRF token request');
              return invalid(response);
            }
          },
          error: function(xhr) {
            if (error) {
              return error(xhr);
            }
          }
        });
      };

      CSRF.prototype.bindSubsequentAjaxMethods = function() {
        var _this = this;

        return $(document).ajaxSend(function(event, jqxhr, settings) {
          if (settings.url.indexOf('?') >= 0) {
            return settings.url += '&token=' + _this.token;
          } else {
            return settings.url += '?token=' + _this.token;
          }
        });
      };

      return CSRF;

    })();
  });

}).call(this);
