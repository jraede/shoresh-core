define(["jquery"],function(a){(function(a){a.fn.priceFormat=function(b){var c={prefix:"US$ ",suffix:"",centsSeparator:".",thousandsSeparator:",",limit:!1,centsLimit:2,clearPrefix:!1,clearSufix:!1,allowNegative:!1,insertPlusSign:!1,clearOnEmpty:!0},b=a.extend(c,b);return this.each(function(){function p(a){for(var b="",c=0;a.length>c;c++)char_=a.charAt(c),0==b.length&&0==char_&&(char_=!1),char_&&char_.match(d)&&(i?i>b.length&&(b+=char_):b+=char_);return b}function q(a){for(;j+1>a.length;)a="0"+a;return a}function r(b,c){if(!c&&(""===b||b==r("0",!0))&&o)return"";var d=q(p(b)),i="",k=0;0==j&&(g="",l="");var l=d.substr(d.length-j,j),s=d.substr(0,d.length-j);if(d=0==j?s:s+g+l,h||""!=a.trim(h)){for(var t=s.length;t>0;t--)char_=s.substr(t-1,1),k++,0==k%3&&(char_=h+char_),i=char_+i;i.substr(0,1)==h&&(i=i.substring(1,i.length)),d=0==j?i:i+g+l}return!m||0==s&&0==l||(d=-1!=b.indexOf("-")&&b.indexOf("+")<b.indexOf("-")?"-"+d:n?"+"+d:""+d),e&&(d=e+d),f&&(d+=f),d}function s(a){var b=a.keyCode?a.keyCode:a.which,d=String.fromCharCode(b),e=!1,f=c.val(),g=r(f+d);(b>=48&&57>=b||b>=96&&105>=b)&&(e=!0),8==b&&(e=!0),9==b&&(e=!0),13==b&&(e=!0),46==b&&(e=!0),37==b&&(e=!0),39==b&&(e=!0),!m||189!=b&&109!=b||(e=!0),!n||187!=b&&107!=b||(e=!0),e||(a.preventDefault(),a.stopPropagation(),f!=g&&c.val(g))}function t(){var a=c.val(),b=r(a);a!=b&&c.val(b)}function u(){var a=c.val();c.val(e+a)}function v(){var a=c.val();c.val(a+f)}function w(){if(""!=a.trim(e)&&k){var b=c.val().split(e);c.val(b[1])}}function x(){if(""!=a.trim(f)&&l){var b=c.val().split(f);c.val(b[0])}}var c=a(this),d=/[0-9]/,e=b.prefix,f=b.suffix,g=b.centsSeparator,h=b.thousandsSeparator,i=b.limit,j=b.centsLimit,k=b.clearPrefix,l=b.clearSuffix,m=b.allowNegative,n=b.insertPlusSign,o=b.clearOnEmpty;n&&(m=!0),a(this).bind("keydown.price_format",s),a(this).bind("keyup.price_format",t),a(this).bind("focusout.price_format",t),k&&(a(this).bind("focusout.price_format",function(){w()}),a(this).bind("focusin.price_format",function(){u()})),l&&(a(this).bind("focusout.price_format",function(){x()}),a(this).bind("focusin.price_format",function(){v()})),a(this).val().length>0&&(t(),w(),x())})},a.fn.unpriceFormat=function(){return a(this).unbind(".price_format")},a.fn.unmask=function(){var b=a(this).val(),c="";for(var d in b)isNaN(b[d])&&"-"!=b[d]||(c+=b[d]);return c}})(a)});