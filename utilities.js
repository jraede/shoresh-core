// Generated by CoffeeScript 1.6.3
(function() {
  define([], function() {
    window._log = {
      microtime: function() {
        var diff, unixtime_ms;
        unixtime_ms = new Date().getTime();
        diff = unixtime_ms - this.bootTime;
        return diff / 1000;
      },
      info: function() {
        if (shoreshConfig.debug === true) {
          return console.log('LOG [' + this.microtime().toString() + '] ', arguments);
        }
      },
      error: function() {
        if (shoreshConfig.debug === true) {
          return console.error('ERROR [' + this.microtime().toString() + '] ', arguments);
        }
      }
    };
    window.inflector = {
      camelize: function(string) {
        var i, length, returnString, _i;
        length = string.length - 1;
        returnString = '';
        for (i = _i = 0; _i <= length; i = _i += 1) {
          if (string[i] === string[i].toUpperCase()) {
            returnString += '_' + string[i].toLowerCase();
          } else {
            returnString += string[i];
          }
        }
        return returnString;
      },
      humanize: function(string) {
        var i, length, returnString, _i;
        length = string.length - 1;
        returnString = string[0].toUpper();
        for (i = _i = 1; _i <= length; i = _i += 1) {
          if (string[i] === '_' || string[i] === '-') {
            returnString += ' ';
          } else {
            returnString += string[i];
          }
        }
        return returnString;
      },
      ordinalize: function(n) {
        var last;
        n = n.toString();
        last = n[n.length - 1];
        if (!isNaN(parseInt(n)) && isFinite(n)) {
          if (last === '1') {
            return n + 'st';
          } else if (last === '2') {
            return n + 'nd';
          } else if (last === '3') {
            return n + 'rd';
          } else {
            return n + 'th';
          }
        } else {
          return n;
        }
      }
    };
    window.formatString = function(string, format) {
      var i, length, match, _i;
      string = string.toString();
      match = format.match(/X/g);
      if (string.length !== match.length) {
        return '';
      }
      length = string.length - 1;
      for (i = _i = 0; _i <= length; i = _i += 1) {
        format = format.replace(/X/, string[i]);
      }
      return format;
    };
    window.roundNumber = function(number, decimals) {
      var multiplier;
      if (decimals == null) {
        decimals = 0;
      }
      multiplier = Math.pow(10, decimals);
      number = Math.round(parseFloat(number) * multiplier) / multiplier;
      return number;
    };
    return window.formatNumber = function(number, decimals) {
      var final, i, index, isNegative, key, newVal, split, val, whole, _i, _j, _ref;
      if (!number) {
        final = '0';
        if (decimals) {
          final += '.';
          for (i = _i = 1; _i <= decimals; i = _i += 1) {
            final += '0';
          }
        }
        return final;
      }
      val = number.toString().replace(/[^0-9\.\-]/g, '');
      if (val.substr(0, 1) === '-') {
        isNegative = true;
        val = (parseFloat(val) * -1).toString();
      } else {
        isNegative = false;
      }
      val = roundNumber(parseFloat(val), decimals).toString();
      index = val.indexOf('.');
      if (index >= 0) {
        if (val.length - (index + 1) === 1) {
          val = val + '0';
        }
      } else {
        val = val + '.00';
      }
      split = val.split('.');
      whole = split[0].split('').reverse().join('');
      newVal = '';
      for (i = _j = 1, _ref = whole.length; _j <= _ref; i = _j += 1) {
        key = i - 1;
        newVal += whole[key];
        if (!(i % 3) && i !== whole.length) {
          newVal += ',';
        }
      }
      newVal = newVal.split('').reverse().join('');
      final = newVal;
      if (split[1]) {
        final += '.' + split[1];
      }
      if (isNegative) {
        final = '-' + final;
      }
      return final;
    };
  });

}).call(this);
