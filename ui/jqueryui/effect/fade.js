/*! jQuery UI - v1.10.3 - 2013-05-03
* http://jqueryui.com
* Copyright 2013 jQuery Foundation and other contributors; Licensed MIT */
define(['jquery', 'components/ui/jqueryui/core', 'components/ui/jqueryui/effect/core'], function(jQuery) {
(function(t){t.effects.effect.fade=function(e,i){var s=t(this),n=t.effects.setMode(s,e.mode||"toggle");s.animate({opacity:n},{queue:!1,duration:e.duration,easing:e.easing,complete:i})}})(jQuery);});