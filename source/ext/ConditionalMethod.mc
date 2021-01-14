/*
 * This file is part of "YRemote" project
 *
 * Author: Roman Gladyshev <remicollab@gmail.com>
 * License: BSD 3-clause "New" or "Revised" License
 *
 * SPDX-License-Identifier: BSD-3-Clause
 * License text is available in the LICENSE file and online:
 * http://www.opensource.org/licenses/BSD-3-Clause
 *
 * Copyright (c) 2021 remico
 */
using Toybox.Lang;

class ConditionalMethod extends Lang.Method {
    private var mInvokeConditions = {};
    private var mMethod;
    private var mDelay = 0;
    private var mMethodArgument;

    // aClass - a type name
    // aMethod - Lang.Symbol
    function initialize(aClass, aMethod, invokeConditions) {
        if (! (invokeConditions instanceof Lang.Dictionary)) {
            throw new Toybox.Lang.UnexpectedTypeException("`invokeConditions` must be of Lang.Dictionary type", null, null);
        }

        self.mInvokeConditions = invokeConditions;

        if (aClass != null && aMethod != null) {
            self.mMethod = new Lang.Method(aClass, aMethod);
        }

        Lang.Method.initialize(ConditionalMethod, :invoke);
    }

    function _canInvoke(data) {
        var valid = true;

        if (data instanceof Lang.Dictionary) {
            var keysToCheck = self.mInvokeConditions.keys();

            for (var i = 0; i < self.mInvokeConditions.size(); ++i) {
                var key = keysToCheck[i];
                if ( data.hasKey(key)
                        && data[key] != self.mInvokeConditions[key] ) {
                    valid = false;
                }
            }
        }

        return valid;
    }

    function _setMethod(aMethod, arg) {
        if (aMethod != null && ! (aMethod instanceof Lang.Method)) {
            throw new Toybox.Lang.UnexpectedTypeException("`aMethod` must be of Lang.Method type", null, null);
        }

        self.mMethod = aMethod;
        self.mMethodArgument = arg;
    }

    function _setDelay(delay) {
        if (delay != null && ! (delay instanceof Lang.Number)) {
            throw new Toybox.Lang.UnexpectedTypeException("`delay` must be of Lang.Number type", null, null);
        }

        self.mDelay = delay;
    }

    function invoke(data) {
        if (self.mMethod != null && _canInvoke(data)) {

            var argument = self.mMethodArgument != null ? self.mMethodArgument : data;

            if (self.mDelay > 0) {  // invoke deferred
                var timer = new TimerEx();
                timer.start(self.mMethod, [argument], self.mDelay, false);
            } else {
                return self.mMethod.invoke(argument);
            }

        }
        return null;
    }

    // aCallback - Lang.Method
    static function method(aCallback, arg, invokeConditions) {
        var m = new ConditionalMethod(null, null, invokeConditions);
        m._setMethod(aCallback, arg);
        return m;
    }

    // aCallback - Lang.Method
    static function deferredMethod(aCallback, arg, delay, invokeConditions) {
        var m = method(aCallback, arg, invokeConditions);
        m._setDelay(delay);
        return m;
    }
}
