/*
 * mechanic.js UIAutomation Library
 * http://cozykozy.com/pages/mechanicjs
 *
 * version e9320027e6b5250ef72990b314238a62a1c2db0a (master build)
 *
 * Copyright (c) 2012 Jason Kozemczak
 * mechanic.js may be freely distributed under the MIT license.
 *
 * Includes parts of Zepto.js
 * Copyright 2010-2012, Thomas Fuchs
 * Zepto.js may be freely distributed under the MIT license.
 */

var mechanic = (function() {
    // Save a reference to the local target for convenience
    var target = UIATarget.localTarget();

    // Set the default timeout value to 0 to avoid making walking the object tree incredibly slow.
    // Developers can adjust this value by calling $.timeout(duration)
    target.setTimeout(0);

    var app = target.frontMostApp(),
        window = app.mainWindow(),
        emptyArray = [],
        slice = emptyArray.slice

    // Setup a map of UIAElement types to their "shortcut" selectors.
    var typeShortcuts = {
        'UIAActionSheet' : ['actionsheet'],
        'UIAActivityIndicator' : ['activityIndicator'],
        'UIAAlert' : ['alert'],
        'UIAButton' : ['button'],
        'UIACollectionCell' : ['collectionCell'],
        'UIACollectionView' : ['collection'],
        'UIAEditingMenu': ['editingMenu'],
        'UIAElement' : ['\\*'], // TODO: sort of a hack
        'UIAImage' : ['image'],
        'UIAKey' : ['key'],
        'UIAKeyboard' : ['keyboard'],
        'UIALink' : ['link'],
        'UIAPageIndicator' : ['pageIndicator'],
        'UIAPicker' : ['picker'],
        'UIAPickerWheel' : ['pickerwheel'],
        'UIAPopover' : ['popover'],
        'UIAProgressIndicator' : ['progress'],
        'UIAScrollView' : ['scrollview'],
        'UIASearchBar' : ['searchbar'],
        'UIASecureTextField' : ['secure'],
        'UIASegmentedControl' : ['segmented'],
        'UIASlider' : ['slider'],
        'UIAStaticText' : ['text'],
        'UIAStatusBar' : ['statusbar'],
        'UIASwitch' : ['switch'],
        'UIATabBar' : ['tabbar'],
        'UIATableView' : ['tableview'],
        'UIATableCell' : ['cell', 'tableCell'],
        'UIATableGroup' : ['group'],
        'UIATextField' : ['textfield'],
        'UIATextView' : ['textview'],
        'UIAToolbar' : ['toolbar'],
        'UIAWebView' : ['webview'],
        'UIAWindow' : ['window'],
        'UIANavigationBar': ['navigationBar']
    };

    // Build a RegExp for picking out type selectors.
    var typeSelectorREString = (function() {
        var key;
        var typeSelectorREString = "\\";
        for (key in typeShortcuts) {
            typeSelectorREString += key + "|";
            typeShortcuts[key].forEach(function(shortcut) { typeSelectorREString += shortcut + "|"; });
        }
        return typeSelectorREString.substr(1, typeSelectorREString.length - 2);
    })();

    var patternName = "[^,\\[\\]]+"

    var selectorPatterns = {
      simple:          (new RegExp("^#("+patternName+")$"))
     ,byType:          (new RegExp("^("+typeSelectorREString+")$"))
     ,byAttr:          (new RegExp("^\\[(\\w+)=("+patternName+")\\]$"))
     ,byTypeAndAttr:   (new RegExp("^("+typeSelectorREString+")\\[(\\w+)=("+patternName+")\\]$"))
     ,children:        (new RegExp("^(.*) > (.*)$"))
     ,descendents:     (new RegExp("^(.+) +(.+)$"))
    }

    var searches = {
      simple:          function(name)         { return this.getElementsByName(name)          }
     ,byType:          function(type)         { return this.getElementsByType(type)          }
     ,byAttr:          function(attr,value)   { return this.getElementsByAttr(attr,value)    }
     ,byTypeAndAttr:   function(type,a,v)     { return $(type, this).filter('['+a+'='+v+']') }
     ,children:        function(parent,child) { return $(parent, this).children().filter(child) }
     ,descendents:     function(parent,child) { return $(child, $(parent, this))             }
    }

    var filters = {
       simple:        function(name)      { return this.name() == name                       }
      ,byType:        function(type)      { return this.isType(type)                         }
      ,byAttr:        function(attr,value){ return this[attr] && this[attr]() == value       }
      ,byTypeAndAttr: function(type,a,v ) { return this.isType(type) && this[a]() == v  }
    }


    function Z(dom, selector){
        dom = dom || emptyArray;
        dom.__proto__ = Z.prototype;
        dom.selector = selector || '';
        if (dom === emptyArray) {
            UIALogger.logWarning("element " + selector + " have not been found");
        }
        return dom;
    }

    function $(selector, context) {
        if (!selector) return Z();
        if (context !== undefined) return $(context).find(selector);
        else if (selector instanceof Z) return selector;
        else {
            var dom;
            if (isA(selector)) dom = compact(selector);
            else if (selector instanceof UIAElement) dom = [selector];
            else dom = $$(app, selector);
            return Z(dom, selector);
        }
    }

    $.qsa = $$ = function(element, selector) {
        var ret = [],
            groups = selector.split(/ *, */),
            matches
        $.each(groups, function() {
          for (type in searches) {
            if (matches = this.match(selectorPatterns[type])) {
              matches.shift()
              ret = ret.concat($(searches[type].apply(element, matches)))
              break
            }
          }
        })
        return $(ret)
    };

    // Add functions to UIAElement to make object graph searching easier.
    UIAElement.prototype.getElementsByName = function(name) {
        return this.getElementsByAttr('name', name)
    };

    UIAElement.prototype.getElementsByAttr = function(attr, value) {
        return $.map(this.elements(), function(el) {
            var matches = el.getElementsByAttr(attr, value),
                val = el[attr]
            if (typeof val == 'function') val = val.apply(el)
            if (typeof val != 'undefined' && val == value)
              matches.push(el)
            return matches
        })
    }
    UIAElement.prototype.getElementsByType = function(type) {
        return $.map(this.elements(), function(el) {
            var matches = el.getElementsByType(type);
            if (el.isType(type)) matches.unshift(el);
            return matches;
        });
    };
    UIAElement.prototype.isType = function(type) {
        var thisType = this.toString().split(" ")[1];
        thisType = thisType.substr(0, thisType.length - 1);
        if (type === thisType) return true;
        else if (typeShortcuts[thisType] !== undefined && typeShortcuts[thisType].indexOf(type) >= 0) return true;
        else if (type === '*' || type === 'UIAElement') return true;
        else return false;
    };

    function isF(value) { return ({}).toString.call(value) == "[object Function]"; }
    function isO(value) { return value instanceof Object; }
    function isA(value) { return value instanceof Array; }
    function likeArray(obj) { return typeof obj.length == 'number'; }

    function compact(array) { return array.filter(function(item){ return item !== undefined && item !== null; }); }
    function flatten(array) { return array.length > 0 ? [].concat.apply([], array) : array; }

    function uniq(array) { return array.filter(function(item,index,array){ return array.indexOf(item) == index; }); }

    function filtered(elements, selector) {
        return selector === undefined ? $(elements) : $(elements).filter(selector);
    }

    $.extend = function(target){
        var key;
        slice.call(arguments, 1).forEach(function(source) {
            for (key in source) target[key] = source[key];
        });
        return target;
    };

    $.inArray = function(elem, array, i) {
        return emptyArray.indexOf.call(array, elem, i);
    };

    $.map = function(elements, callback) {
        var value, values = [], i, key;
        if (likeArray(elements)) {
            for (i = 0; i < elements.length; i++) {
                value = callback(elements[i], i);
                if (value != null) values.push(value);
            }
        } else {
            for (key in elements) {
                value = callback(elements[key], key);
                if (value != null) values.push(value);
            }
        }
        return flatten(values);
    };

    $.each = function(elements, callback) {
        var i, key;
        if (likeArray(elements)) {
            for(i = 0; i < elements.length; i++) {
                if(callback.call(elements[i], i, elements[i]) === false) return elements;
            }
        } else {
            for(key in elements) {
                if(callback.call(elements[key], key, elements[key]) === false) return elements;
            }
        }
        return elements;
    };

    $.fn = {
        forEach: emptyArray.forEach,
        reduce: emptyArray.reduce,
        push: emptyArray.push,
        indexOf: emptyArray.indexOf,
        concat: emptyArray.concat,
        map: function(fn){
            return $.map(this, function(el, i){ return fn.call(el, i, el); });
        },
        slice: function(){
            return $(slice.apply(this, arguments));
        },
        get: function(idx){ return idx === undefined ? slice.call(this) : this[idx]; },
        size: function(){ return this.length; },
        each: function(callback) {
            this.forEach(function(el, idx){ callback.call(el, idx, el); });
            return this;
        },
        filter: function(selector) {
          var matches
          for (type in filters) {
            if (matches = selector.match(selectorPatterns[type])) {
              matches.shift() // remove the original string, we only want the capture groups
              return $.map(this, function(e) {
                return filters[type].apply(e, matches) ? e : null
              })
            }
          }
        },
        end: function(){
            return this.prevObject || $();
        },
        andSelf:function(){
            return this.add(this.prevObject || $());
        },
        add:function(selector,context){
            return $(uniq(this.concat($(selector,context))));
        },
        is: function(selector){
            return this.length > 0 && $(this[0]).filter(selector).length > 0;
        },
        not: function(selector){
            var nodes=[];
            if (isF(selector) && selector.call !== undefined)
                this.each(function(idx){
                    if (!selector.call(this,idx)) nodes.push(this);
                });
            else {
                var excludes = typeof selector == 'string' ? this.filter(selector) :
                        (likeArray(selector) && isF(selector.item)) ? slice.call(selector) : $(selector);
                this.forEach(function(el){
                    if (excludes.indexOf(el) < 0) nodes.push(el);
                });
            }
            return $(nodes);
        },
        eq: function(idx){
            return idx === -1 ? this.slice(idx) : this.slice(idx, + idx + 1);
        },
        first: function(){ var el = this[0]; return el && !isO(el) ? el : $(el); },
        last: function(){ var el = this[this.length - 1]; return el && !isO(el) ? el : $(el); },
        find: function(selector) {
            var result;
            if (this.length == 1) result = $$(this[0], selector);
            else result = this.map(function(){ return $$(this, selector); });
            return $(result);
        },
        predicate: function(predicate) {
            return this.map(function(el, idx) {
                if (typeof predicate == 'string') return el.withPredicate(predicate);
                else return null;
            });
        },
        valueForKey: function(key, value) {
            var result = this.map(function(idx, el) {
                if (key in el && el[key]() == value) {
                    return el;
                }
                return null;
            });
            return $(result);
        },
        valueInKey: function(key, val) {
            var result = this.map(function(idx, el) {
                if (key in el) {
                    var elKey = el[key]();
                    if (elKey === null) {
                        return null;
                    }
                    // make this a case insensitive search
                    elKey = elKey.toString().toLowerCase();
                    val = val.toString().toLowerCase();

                    if (elKey.indexOf(val) !== -1) {
                        return el;
                    }
                }
                return null;
            });
            return $(result);
        },
        closest: function(selector, context) {
            var el = this[0], candidates = $$(context || app, selector);
            if (!candidates.length) el = null;
            while (el && candidates.indexOf(el) < 0)
                el = el !== context && el !== app && el.parent();
            return $(el);
        },
        ancestry: function(selector) {
            var ancestors = [], elements = this;
            while (elements.length > 0)
                elements = $.map(elements, function(node){
                    if ((node = node.parent()) && !node.isType('UIAApplication') && ancestors.indexOf(node) < 0) {
                        ancestors.push(node);
                        return node;
                    }
                });
            return filtered(ancestors, selector);
        },
        parent: function(selector) {
            return filtered(uniq(this.map(function() { return this.parent(); })), selector);
        },
        children: function(selector) {
            return filtered(this.map(function(){ return slice.call(this.elements()); }), selector);
        },
        siblings: function(selector) {
            return filtered(this.map(function(i, el) {
                return slice.call(el.parent().elements()).filter(function(child){ return child!==el; });
            }), selector);
        },
        next: function(selector) {
            return filtered(this.map(function() {
                var els = this.parent().elements().toArray();
                return els[els.indexOf(this) + 1];
            }), selector);
        },
        prev: function(selector) {
            return filtered(this.map(function() {
                var els = this.parent().elements().toArray();
                return els[els.indexOf(this) - 1];
            }), selector);
        },
        index: function(element) {
            return element ? this.indexOf($(element)[0]) : this.parent().elements().toArray().indexOf(this[0]);
        },
        pluck: function(property) {
            return this.map(function() {
                if (typeof this[property] == 'function') return this[property]();
                else return this[property];
            });
        }
    };

    'filter,add,not,eq,first,last,find,closest,parents,parent,children,siblings'.split(',').forEach(function(property) {
        var fn = $.fn[property];
        $.fn[property] = function() {
            var ret = fn.apply(this, arguments);
            ret.prevObject = this;
            return ret;
        };
    });

    Z.prototype = $.fn;
    return $;
})();

var $ = $ || mechanic;  // expose $ shortcut
//     mechanic.js
//     Copyright (c) 2012 Jason Kozemczak
//     mechanic.js may be freely distributed under the MIT license.

(function($) {
    $.extend($, {
        log: function(s, level) {
            level = level || 'message';
            if (level === 'error') $.error(s);
            else if (level === 'warn') $.warn(s);
            else if (level === 'debug') $.debug(s);
            else $.message(s);
        },
        error: function(s) { UIALogger.logError(s); },
        warn: function(s) { UIALogger.logWarning(s); },
        debug: function(s) { UIALogger.logDebug(s); },
        message: function(s) { UIALogger.logMessage(s); },
        capture: function(imageName, rect) {
			var target = UIATarget.localTarget();
            imageName = imageName || new Date().toString();
            if (rect) target.captureRectWithName(rect, imageName);
            else target.captureScreenWithName(imageName);
        }
    });

    $.extend($.fn, {
        log: function() { return this.each(function() { this.logElement(); }); },
        logTree: function () { return this.each(function() { this.logElementTree(); }); },
        capture: function(imageName) {
            imageName = imageName || new Date().toString();
            return this.each(function() { $.capture(imageName + '-' + this.name(), this.rect()); });
        }
    });
})(mechanic);
//     mechanic.js
//     Copyright (c) 2012 Jason Kozemczak
//     mechanic.js may be freely distributed under the MIT license.

(function($) {
    var app = UIATarget.localTarget().frontMostApp();
    $.extend($.fn, {
        name: function() { return (this.length > 0) ? this[0].name() : null; },
        label: function() { return (this.length > 0) ? this[0].label() : null; },
        value: function() { return (this.length > 0) ? this[0].value() : null; },
        isFocused: function() { return (this.length > 0) ? this[0].hasKeyboardFocus() : false; },
        isEnabled: function() { return (this.length > 0) ? this[0].isEnabled() : false; },
        isVisible: function() { return (this.length > 0) ? this[0].isVisible() : false; },
        isValid: function(certain) {
            if (this.length != 1) return false;
            else if (certain) return this[0].checkIsValid();
            else return this[0].isValid();
        }
    });

    $.extend($, {
        version: function() {
            return app.version();
        },
        bundleID: function()  {
            return app.bundleID();
        },
        prefs: function(prefsOrKey) {
            // TODO: should we handle no-arg version that returns all prefs???
            if (typeof prefsOrKey == 'string') return app.preferencesValueForKey(prefsOrKey);
            else {
                $.each(prefsOrKey, function(key, val) {
                    app.setPreferencesValueForKey(val, key);
                });
            }
        }
    });

})(mechanic);
//     mechanic.js
//     Copyright (c) 2012 Jason Kozemczak
//     mechanic.js may be freely distributed under the MIT license.

(function($) {
    var target = UIATarget.localTarget();
    $.extend($, {
        timeout: function(duration) { target.setTimeout(duration); },
        delay: function(seconds) { target.delay(seconds); },
        cmd: function(path, args, timeout) { target.host().performTaskWithPathArgumentsTimeout(path, args, timeout); },
        orientation: function(orientation) {
            if (orientation === undefined || orientation === null) return target.deviceOrientation();
            else target.setDeviceOrientation(orientation);
        },
        location: function(coordinates, options) {
            options = options || {};
            target.setLocationWithOptions(coordinates, options);
        },
        shake: function() { target.shake(); },
        rotate: function(options) { target.rotateWithOptions(options); },
        pinchScreen: function(options) {
            if (!options.style) options.style = 'open';
            if (options.style === 'close') target.pinchCloseFromToForDuration(options.from, options.to, options.duration);
            else target.pinchOpenFromToForDuration(options.from, options.to, options.duration);
        },
        drag: function(options) { target.dragFromToForDuration(options.from, options.to, options.duration); },
        flick: function(options) { target.flickFromTo(options.from, options.to); },
        lock: function(duration) { target.lockForDuration(duration); },
        backgroundApp: function(duration) { target.deactivateAppForDuration(duration); },
        volume: function(direction, duration) {
            if (direction === 'up') {
                if (duration) target.holdVolumeUp(duration);
                else target.clickVolumeUp();
            } else {
                if (duration) target.holdVolumeDown(duration);
                else target.clickVolumeDown();
            }
        },
        input: function(s) {
            target.frontMostApp().keyboard().typeString(s);
        }
    });

    $.extend($.fn, {
        tap: function(options) {
            options = options || {};
            return this.each(function() {
                // TODO: tapWithOptions supports most of the behavior of doubleTap/twoFingerTap looking at the API, do we need to support these methods??
                if (options.style === 'double') this.doubleTap();
                else if (options.style === 'twoFinger') this.twoFingerTap();
                else this.tapWithOptions(options);
            });
        },
        touch: function(duration) {
            return this.each(function() { this.touchAndHold(duration); });
        },
        dragInside: function(options) {
            return this.each(function() { this.dragInsideWithOptions(options); });
        },
        flick: function(options) {
            return this.each(function() { this.flickInsideWithOptions(options); });
        },
        rotate: function(options) {
            return this.each(function() { this.rotateWithOptions(options); });
        },
        scrollToVisible: function() {
            if (this.length > 0) this[0].scrollToVisible();
            return this;
        },
        input: function(s) {
            if (this.length > 0) {
                this[0].tap();
                $.input(s);
            }
        }
    });

    'delay,cmd,orientation,location,shake,pinchScreen,drag,lock,backgroundApp,volume'.split(',').forEach(function(property) {
        var fn = $[property];
        $.fn[property] = function() {
            fn.apply($, arguments);
            return this;
        };
    });
})(mechanic);
// Generated by CoffeeScript 1.6.3
(function() {
  var CameraScreen, CropScreen, FlyerScreen, ForgotScreen, GalleryScreen, Help1Screen, Helpers, HomeScreen, Invite123Screen, InviteScreen, ProfileScreen, RegisterScreen, SavedScreen, Screen, SettingsScreen, ShareSettingsScreen, SignInScreen, WelcomeScreen, Zucchini, app, extend, raise, rotateTo, screensCount, target, view, wait, waitForElement, _elementFrom,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  UIAElement.prototype.$ = function(name) {
    $.debug("element.$ is deprecated. Zucchini now supports mechanic.js selectors: https://github.com/jaykz52/mechanic");
    return $('#' + name).first();
  };

  waitForElement = function(element) {
    $.debug("waitForElement is deprecated. Please use $.wait(finderFunction)");
    return $.wait(function() {
      return element;
    });
  };

  extend = $.extend;

  target = UIATarget.localTarget();

  app = target.frontMostApp();

  view = app.mainWindow();

  UIATarget.onAlert = function(alert) {
    return true;
  };

  screensCount = 0;

  target.captureScreenWithName_ = target.captureScreenWithName;

  target.captureScreenWithName = function(name) {
    var number;
    number = (++screensCount < 10 ? "0" + screensCount : screensCount);
    return this.captureScreenWithName_("" + number + "_" + name);
  };

  Function.prototype.bind = function(context) {
    var fun;
    if (!context) {
      return this;
    }
    fun = this;
    return function() {
      return fun.apply(context, arguments);
    };
  };

  String.prototype.camelCase = function() {
    return this.replace(/([\-\ ][A-Za-z])/g, function($1) {
      return $1.toUpperCase().replace(/[\-\ ]/g, '');
    });
  };

  raise = function(message) {
    throw new Error(message);
  };

  _elementFrom = function(finder) {
    var res;
    res = finder();
    if (res && typeof res.length === 'number') {
      res = res[0];
    }
    return res;
  };

  wait = function(finder) {
    var counter, element, found;
    found = false;
    counter = 0;
    element = null;
    while (!found && counter < 10) {
      element = _elementFrom(finder);
      if ((element != null) && element.checkIsValid() && element.isVisible()) {
        found = true;
      } else {
        target.delay(0.5);
        counter++;
      }
    }
    if (found) {
      return element;
    } else {
      return false;
    }
  };

  rotateTo = function(orientation) {
    return target.setDeviceOrientation(orientation === 'portrait' ? UIA_DEVICE_ORIENTATION_PORTRAIT : UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT);
  };

  Screen = (function() {
    Screen.prototype.takeScreenshot = function(screenshotName) {
      var orientation;
      $.delay(0.5);
      orientation = (function() {
        switch (app.interfaceOrientation()) {
          case 0:
            return 'Unknown';
          case 1:
            return 'Portrait';
          case 2:
            return 'PortraitUpsideDown';
          case 3:
            return 'LandscapeLeft';
          case 4:
            return 'LandscapeRight';
          case 5:
            return 'FaceUp';
          case 6:
            return 'FaceDown';
        }
      })();
      $.log("Screenshot of screen '" + this.name + "' taken with orientation '" + orientation + "'");
      return target.captureScreenWithName(screenshotName);
    };

    Screen.prototype.element = function(name) {
      var el, finder;
      finder = this.elements[name] || function() {
        return $('#' + name);
      };
      if (!(el = wait(finder))) {
        raise("Element '" + name + "' was not found on '" + this.name + "'");
      }
      return el;
    };

    function Screen(name) {
      this.name = name;
    }

    Screen.prototype.elements = {};

    Screen.prototype.actions = {
      'Take a screenshot$': function() {
        return this.takeScreenshot(this.name);
      },
      'Take a screenshot named "([^"]*)"$': function(name) {
        return this.takeScreenshot(name);
      },
      'Show elements': function() {
        return view.logElementTree();
      },
      'Show elements for "([^"]*)"$': function(name) {
        return this.element(name).logElementTree();
      },
      'Tap "([^"]*)"$': function(name) {
        return this.element(name).tap();
      },
      'Confirm "([^"]*)"$': function(element) {
        return this.actions['Tap "([^"]*)"$'].bind(this)(element);
      },
      'Wait for "([^"]*)" second[s]*$': function(seconds) {
        return target.delay(seconds);
      },
      'Type "([^"]*)" in the "([^"]*)" field$': function(text, name) {
        return $(this.element(name)).input(text);
      },
      'Clear the "([^"]*)" field$': function(name) {
        return this.element(name).setValue('');
      },
      'Cancel the alert$': function() {
        var alert;
        alert = app.alert();
        if (!alert.isValid()) {
          raise("No alert found to dismiss on screen '" + this.name + "'");
        }
        return alert.cancelButton().tap();
      },
      'Confirm the alert$': function() {
        var alert;
        alert = app.alert();
        if (!alert.isValid()) {
          raise("No alert found to dismiss on screen '" + this.name + "'");
        }
        return alert.defaultButton().tap();
      },
      'Select the date "([^"]*)"$': function(dateString) {
        var counter, dateParts, datePicker, monthWheel;
        datePicker = view.pickers()[0];
        if (!(datePicker.isValid() && datePicker.isVisible())) {
          raise("No date picker available to enter the date " + dateString);
        }
        dateParts = dateString.match(/^(\d{2}) (\D*) (\d{4})$/);
        if (dateParts == null) {
          raise("Date is in the wrong format. Need DD Month YYYY. Got " + dateString);
        }
        view.pickers()[0].wheels()[0].selectValue(dateParts[1]);
        counter = 0;
        monthWheel = view.pickers()[0].wheels()[1];
        while (monthWheel.value() !== dateParts[2] && counter < 12) {
          counter++;
          monthWheel.tapWithOptions({
            tapOffset: {
              x: 0.5,
              y: 0.33
            }
          });
          target.delay(0.4);
        }
        if (!(counter < 12)) {
          raise("Couldn't find the month " + dateParts[2]);
        }
        return view.pickers()[0].wheels()[2].selectValue(dateParts[3]);
      },
      'Rotate device to "([^"]*)"$': function(orientation) {
        return rotateTo(orientation);
      }
    };

    return Screen;

  })();

  Zucchini = function(featureText, orientation) {
    var e, func, functionFound, line, lines, match, regExpText, screen, screenMatch, screenName, section, sections, _i, _len, _results;
    rotateTo(orientation);
    sections = featureText.trim().split(/\n\s*\n/);
    _results = [];
    for (_i = 0, _len = sections.length; _i < _len; _i++) {
      section = sections[_i];
      lines = section.split(/\n/);
      screenMatch = lines[0].match(/.+ on the "([^"]*)" screen:$/);
      if (!screenMatch) {
        raise("Line '" + lines[0] + "' doesn't define a screen context");
      }
      screenName = screenMatch[1];
      try {
        screen = eval("new " + (screenName.camelCase()) + "Screen");
      } catch (_error) {
        e = _error;
        raise("Screen '" + screenName + "' not defined");
      }
      if (screen.anchor) {
        if (wait(screen.anchor)) {
          $.log("Found anchor for screen '" + screenName + "'");
        } else {
          raise("Could not find anchor for screen '" + screenName + "'");
        }
      }
      _results.push((function() {
        var _j, _len1, _ref, _ref1, _results1;
        _ref = lines.slice(1);
        _results1 = [];
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          line = _ref[_j];
          functionFound = false;
          _ref1 = screen.actions;
          for (regExpText in _ref1) {
            func = _ref1[regExpText];
            match = line.trim().match(new RegExp(regExpText));
            if (match) {
              functionFound = true;
              func.bind(screen)(match[1], match[2]);
            }
          }
          if (!functionFound) {
            _results1.push(raise("Action for line '" + line + "' not defined"));
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      })());
    }
    return _results;
  };

  CameraScreen = (function(_super) {
    __extends(CameraScreen, _super);

    CameraScreen.prototype.anchor = function() {
      return $('navigationBar[name=CameraView]');
    };

    function CameraScreen() {
      CameraScreen.__super__.constructor.call(this, 'camera');
      extend(this.elements, {
        'Cancel': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Take a photo': function() {
          return $('#TakePhoto');
        },
        'Gallery': function() {
          return $('#Gallery');
        },
        'Rotate Camera': function() {
          return $('#RotateCamera');
        },
        'Grid': function() {
          return $('#Grid');
        }
      });
    }

    return CameraScreen;

  })(Screen);

  CropScreen = (function(_super) {
    __extends(CropScreen, _super);

    CropScreen.prototype.anchor = function() {
      return $('navigationBar[name=CropView]');
    };

    function CropScreen() {
      CropScreen.__super__.constructor.call(this, 'crop');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Done': function() {
          return view.navigationBars()[0].buttons()[1];
        }
      });
    }

    return CropScreen;

  })(Screen);

  FlyerScreen = (function(_super) {
    __extends(FlyerScreen, _super);

    FlyerScreen.prototype.anchor = function() {
      return $('navigationBar[name=CreateFlyer]');
    };

    function FlyerScreen() {
      FlyerScreen.__super__.constructor.call(this, 'flyer');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Help': function() {
          return view.navigationBars()[0].buttons()[1];
        },
        'Next / Delete / Undo': function() {
          return view.navigationBars()[0].buttons()[2];
        },
        'Done / Share': function() {
          return view.navigationBars()[0].buttons()[3];
        },
        'Text': function() {
          return $('#Text');
        },
        'Photo': function() {
          return $('#Photo');
        },
        'Symbols': function() {
          return $('#Symbols');
        },
        'Clipart': function() {
          return $('#Clipart');
        },
        'Background': function() {
          return $('#Background');
        },
        'Text input': function() {
          return $("#TextInput");
        },
        'Font': function() {
          return $('#Font');
        },
        'Color': function() {
          return $('#Color');
        },
        'Size': function() {
          return $('#Size');
        },
        'Text border': function() {
          return $('#TextBorder');
        },
        'Edit': function() {
          return $('#Edit');
        },
        'Camera': function() {
          return $('#Camera');
        },
        'Gallery': function() {
          return $('#Gallery');
        },
        'Width': function() {
          return $('#Width');
        },
        'Height': function() {
          return $('#Height');
        },
        'Library': function() {
          return $('#Library');
        },
        'Take a photo': function() {
          return $('#TakePhoto');
        },
        'Cameral roll': function() {
          return $('#CameraRoll');
        },
        'Border': function() {
          return $('#Border');
        },
        'Facebook Button': function() {
          return $('#Facebook');
        },
        'Twitter Button': function() {
          return $('#Twitter');
        },
        'Tumblr Button': function() {
          return $('#Tumblr');
        },
        'Instagram Button': function() {
          return $('#Instagram');
        },
        'Flicker Button': function() {
          return $('#Flicker');
        },
        'Email Button': function() {
          return $('#Email');
        },
        'SMS Button': function() {
          return $('#SMS');
        },
        'Copy Button': function() {
          return $('#Copy');
        },
        'Tile1': function() {
          return view.scrollViews()[0].buttons()[0];
        },
        'Tile2': function() {
          return view.scrollViews()[0].buttons()[1];
        },
        'Tile3': function() {
          return view.scrollViews()[0].buttons()[2];
        },
        'Tile4': function() {
          return view.scrollViews()[0].buttons()[3];
        },
        'Tile5': function() {
          return view.scrollViews()[0].buttons()[4];
        },
        'Tile6': function() {
          return view.scrollViews()[0].buttons()[5];
        },
        'Tile7': function() {
          return view.scrollViews()[0].buttons()[6];
        },
        'Tile8': function() {
          return view.scrollViews()[0].buttons()[7];
        },
        'Tile9': function() {
          return view.scrollViews()[0].buttons()[8];
        },
        'Tile10': function() {
          return view.scrollViews()[0].buttons()[9];
        },
        'Tile11': function() {
          return view.scrollViews()[0].buttons()[10];
        },
        'Tile12': function() {
          return view.scrollViews()[0].buttons()[11];
        },
        'Tile13': function() {
          return view.scrollViews()[0].buttons()[12];
        },
        'Tile14': function() {
          return view.scrollViews()[0].buttons()[13];
        },
        'Tile15': function() {
          return view.scrollViews()[0].buttons()[14];
        },
        'Tile16': function() {
          return view.scrollViews()[0].buttons()[15];
        },
        'Tile17': function() {
          return view.scrollViews()[0].buttons()[16];
        },
        'Tile18': function() {
          return view.scrollViews()[0].buttons()[17];
        },
        'Tile19': function() {
          return view.scrollViews()[0].buttons()[18];
        },
        'Tile20': function() {
          return view.scrollViews()[0].buttons()[19];
        },
        'Tile21': function() {
          return view.scrollViews()[0].buttons()[20];
        },
        'Tile22': function() {
          return view.scrollViews()[0].buttons()[21];
        },
        'Tile23': function() {
          return view.scrollViews()[0].buttons()[22];
        },
        'Tile24': function() {
          return view.scrollViews()[0].buttons()[23];
        },
        'Tile25': function() {
          return view.scrollViews()[0].buttons()[24];
        }
      });
    }

    return FlyerScreen;

  })(Screen);

  ForgotScreen = (function(_super) {
    __extends(ForgotScreen, _super);

    ForgotScreen.prototype.anchor = function() {
      return $('navigationBar[name=ResetPWView]');
    };

    function ForgotScreen() {
      ForgotScreen.__super__.constructor.call(this, 'forgot');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Username': function() {
          return $('#Username');
        },
        'Reset Password': function() {
          return $('#Reset Password');
        }
      });
    }

    return ForgotScreen;

  })(Screen);

  GalleryScreen = (function(_super) {
    __extends(GalleryScreen, _super);

    GalleryScreen.prototype.anchor = function() {
      return $('navigationBar[name=9 albums]');
    };

    function GalleryScreen() {
      GalleryScreen.__super__.constructor.call(this, 'gallery');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        }
      });
    }

    return GalleryScreen;

  })(Screen);

  Help1Screen = (function(_super) {
    __extends(Help1Screen, _super);

    Help1Screen.prototype.anchor = function() {
      return $('navigationBar[name=Help]');
    };

    function Help1Screen() {
      Help1Screen.__super__.constructor.call(this, 'help');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        }
      });
    }

    return Help1Screen;

  })(Screen);

  HomeScreen = (function(_super) {
    __extends(HomeScreen, _super);

    HomeScreen.prototype.anchor = function() {
      return $('navigationBar[name=FlyerlyMainScreen]');
    };

    function HomeScreen() {
      HomeScreen.__super__.constructor.call(this, 'home');
      extend(this.elements, {
        'Saved': function() {
          return $('#SavedFlyers');
        },
        'Create': function() {
          return $('#CreateFlyer');
        },
        'Invite': function() {
          return $('#Invite');
        },
        'Settings': function() {
          return $('#Settings');
        },
        'Twitter': function() {
          return $('#Twitter');
        },
        'Facebook': function() {
          return $('#Facebook');
        },
        'FacebookLike': function() {
          return $('#FacebookLikeInPopup');
        },
        'FacebookClose': function() {
          return $('#FacebookClose');
        },
        'First Flyer': function() {
          return $('#FirstFlyer');
        },
        'Second Flyer': function() {
          return $('#SecondFlyer');
        },
        'Third Flyer': function() {
          return $('#ThirdFlyer');
        },
        'Fourth Flyer': function() {
          return $('#FourthFlyer');
        }
      });
    }

    return HomeScreen;

  })(Screen);

  InviteScreen = (function(_super) {
    __extends(InviteScreen, _super);

    InviteScreen.prototype.anchor = function() {
      return $('navigationBar[name=InviteFriends]');
    };

    InviteScreen.prototype.anchor = function() {
      return $('tableview[name=Empty list]');
    };

    function InviteScreen() {
      InviteScreen.__super__.constructor.call(this, 'invite');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Help': function() {
          return view.navigationBars()[0].buttons()[1];
        },
        'Next': function() {
          return view.navigationBars()[0].buttons()[2];
        },
        'First Contact': function() {
          return view.tableViews()[0].cells()[0];
        }
      });
    }

    return InviteScreen;

  })(Screen);

  Invite123Screen = (function(_super) {
    __extends(Invite123Screen, _super);

    Invite123Screen.prototype.anchor = function() {
      return $('navigationBar[name=InviteFriends]');
    };

    Invite123Screen.prototype.anchor = function() {
      return $('tableview[name=Empty list]');
    };

    function Invite123Screen() {
      Invite123Screen.__super__.constructor.call(this, 'invite_friend');
      extend(this.elements, {
        'Home': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Help': function() {
          return view.navigationBars()[0].buttons()[1];
        },
        'Create': function() {
          return view.navigationBars()[0].buttons()[2];
        },
        'Search Box': function() {
          return $('#Search');
        },
        'Cell': function() {
          return view.tableViews()[0].cells()[1];
        },
        '1Cell': function() {
          return view.tableViews()[0].cells()[11];
        }
      });
    }

    return Invite123Screen;

  })(Screen);

  ProfileScreen = (function(_super) {
    __extends(ProfileScreen, _super);

    ProfileScreen.prototype.anchor = function() {
      return $('navigationBar[name=ProfileView]');
    };

    function ProfileScreen() {
      ProfileScreen.__super__.constructor.call(this, 'profile');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Email': function() {
          return $('#Email');
        },
        'Name': function() {
          return $('#Name');
        },
        'Phone': function() {
          return $('#Phone');
        }
      });
    }

    return ProfileScreen;

  })(Screen);

  RegisterScreen = (function(_super) {
    __extends(RegisterScreen, _super);

    RegisterScreen.prototype.anchor = function() {
      return $('#SignUp');
    };

    function RegisterScreen() {
      RegisterScreen.__super__.constructor.call(this, 'register');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Next': function() {
          return view.navigationBars()[0].buttons()[1];
        },
        'Username': function() {
          return $('#Username');
        },
        'Password': function() {
          return $('#Password');
        },
        'Confirm Password': function() {
          return $('#ConfirmPassword');
        },
        'Email': function() {
          return $('#Email');
        },
        'Name': function() {
          return $('#Name');
        },
        'Phone Number': function() {
          return $('#PhoneNumber');
        },
        'Sign Up': function() {
          return $('#SignUp');
        },
        'Facebook': function() {
          return $('#Facebook');
        },
        'Twitter': function() {
          return $('#Twitter');
        }
      });
    }

    return RegisterScreen;

  })(Screen);

  SavedScreen = (function(_super) {
    __extends(SavedScreen, _super);

    SavedScreen.prototype.anchor = function() {
      return $('navigationBar[name=FlyrView]');
    };

    SavedScreen.prototype.anchor = function() {
      return $('tableview[name=Empty list]');
    };

    function SavedScreen() {
      SavedScreen.__super__.constructor.call(this, 'saved');
      extend(this.elements, {
        'Home': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Help': function() {
          return view.navigationBars()[0].buttons()[1];
        },
        'Create': function() {
          return view.navigationBars()[0].buttons()[2];
        },
        'Search Box': function() {
          return $('#Search');
        },
        'Cell': function() {
          return view.tableViews()[0].cells()[0];
        }
      });
    }

    return SavedScreen;

  })(Screen);

  SettingsScreen = (function(_super) {
    __extends(SettingsScreen, _super);

    SettingsScreen.prototype.anchor = function() {
      return $('navigationBar[name=MainSettingView]');
    };

    SettingsScreen.prototype.anchor = function() {
      return $('tableview[name=Empty list]');
    };

    function SettingsScreen() {
      SettingsScreen.__super__.constructor.call(this, 'settings');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Help': function() {
          return view.navigationBars()[0].buttons()[1];
        },
        'Email': function() {
          return $('#SettingsEmail');
        },
        'App Review': function() {
          return $('#AppReview');
        },
        'Twitter': function() {
          return $('#Twitter');
        },
        'Help': function() {
          return $('#Help');
        },
        'Sign Out': function() {
          return $('#Sign Out');
        },
        'Account Setting': function() {
          return $('#Account Setting');
        },
        'Save to Gallery': function() {
          return $('#Save to Gallery');
        },
        'Cell': function() {
          return view.tableViews()[0].scrollToElementWithName('Save to Gallery');
        },
        'Sign In': function() {
          return view.tableViews()[0].cells()[4];
        }
      });
    }

    return SettingsScreen;

  })(Screen);

  InviteScreen = (function(_super) {
    __extends(InviteScreen, _super);

    InviteScreen.prototype.anchor = function() {
      return $('navigationBar[name=InviteFriends]');
    };

    function InviteScreen() {
      InviteScreen.__super__.constructor.call(this, 'invite');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Help': function() {
          return view.navigationBars()[0].buttons()[1];
        }
      });
    }

    return InviteScreen;

  })(Screen);

  ShareSettingsScreen = (function(_super) {
    __extends(ShareSettingsScreen, _super);

    ShareSettingsScreen.prototype.anchor = function() {
      return $('#SettingsScreen');
    };

    function ShareSettingsScreen() {
      ShareSettingsScreen.__super__.constructor.call(this, 'share-settings');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Next': function() {
          return view.navigationBars()[0].buttons()[1];
        },
        'Facebook Button': function() {
          return $('#Facebook');
        },
        'Twitter Button': function() {
          return $('#Twitter');
        },
        'Instagram Button': function() {
          return $('#Instagram');
        },
        'Tumblr Button': function() {
          return $('#Tumblr');
        }
      });
    }

    return ShareSettingsScreen;

  })(Screen);

  SignInScreen = (function(_super) {
    __extends(SignInScreen, _super);

    SignInScreen.prototype.anchor = function() {
      return $('#Login');
    };

    function SignInScreen() {
      SignInScreen.__super__.constructor.call(this, 'sign-in');
      extend(this.elements, {
        'Back': function() {
          return view.navigationBars()[0].buttons()[0];
        },
        'Next': function() {
          return view.navigationBars()[0].buttons()[1];
        },
        'Username': function() {
          return $('#Username');
        },
        'Password': function() {
          return $('#PasswordField');
        },
        'Sign In': function() {
          return $('#Login');
        },
        'SignUp': function() {
          return $('#SignUp');
        },
        'Facebook': function() {
          return $('#SignInFacebook');
        },
        'Twitter': function() {
          return $('#SignInTwitter');
        },
        'Forgot': function() {
          return $('#ForgotPassword');
        },
        'Twitter User': function() {
          return $('#Username or email');
        },
        'Twitter Password': function() {
          return $('#Password textfield');
        },
        'Twitter Sign In': function() {
          return $('#Sign In');
        }
      });
    }

    return SignInScreen;

  })(Screen);

  WelcomeScreen = (function(_super) {
    __extends(WelcomeScreen, _super);

    WelcomeScreen.prototype.anchor = function() {
      return $('#Register');
    };

    function WelcomeScreen() {
      WelcomeScreen.__super__.constructor.call(this, 'welcome');
      extend(this.elements, {
        'Register': function() {
          return $('#Register');
        },
        'SignIn': function() {
          return $('#SignIn');
        }
      });
    }

    return WelcomeScreen;

  })(Screen);

  Helpers = (function() {
    function Helpers() {}

    Helpers.example = function() {
      return $.log("Helpers.example method is available in your screen classes");
    };

    return Helpers;

  })();

  Zucchini('Start on the "Home" screen:\n  Tap "Create"\n\nThen on the "Flyer" screen:\n  Tap "Symbols"\n  Tap "Tile4"\n  Tap "Done / Share"\n  Tap "Clipart"\n  Tap "Tile4"\n  Tap "Done / Share"\n  Take a screenshot\n  Tap "Tile1"\n  Tap "Done / Share"\n  Take a screenshot\n  Tap "Tile1"\n  Take a screenshot\n  Tap "Done / Share"\n  Tap "Done / Share"\n  Confirm "Sign In1"\n\nThen on the "SignIn" screen:\n  Take a screenshot\n  Clear the "Username" field\n  Type "riksof.yahoo" in the "Username" field\n  Type "riksof123" in the "Password" field\n  Tap "Sign In"\n\nThen on the "Flyer" screen:\n  Tap "Facebook Button"\n  Tap "Post"\n  Wait for "15" seconds\n  Tap "Twitter Button"\n  Tap "Send to Twitter"\n  Tap "Tumblr Button"\n  Tap "Cancel"\n  Tap "Instagram Button"\n  Tap "Cancel"\n  Tap "Flicker Button"\n  Tap "Send to Flickr"\n  Tap "SMS Button"\n  Tap "Cancel"\n  Tap "Copy Button"\n  Tap "Back"\n  Show elements\n\nThen on the "Home" screen:\n  Tap "Settings"\n  \nThen on the "Settings" screen:\n  Tap "Sign Out"\n  Confirm "Sign out"', 'portrait');

}).call(this);
