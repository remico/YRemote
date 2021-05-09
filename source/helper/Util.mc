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
using Toybox.Attention;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

module Util {

function feedback(n) {
    if(Attention has :vibrate) {
        var vibrateData = new [n];
        for (var i = 0; i < n; ++i) {
            vibrateData[i] = new Attention.VibeProfile(80, 100);
        }
        Attention.vibrate(vibrateData);
    }
}

(:debug)
function log(text) {
    System.println("@ " + text);
}

(:release)
function log(text) {}

function timestamp() {
    var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

    var formatted = Lang.format(
        "$1$:$2$:$3$ $4$ $5$, $6$",
        [
            now.hour,
            now.min,
            now.sec,
            now.month,
            now.day,
            now.year
        ]
    );

    return formatted;
}

} // module
