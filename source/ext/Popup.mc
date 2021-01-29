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
using Toybox.WatchUi;
using Toybox.Timer;

class Popup extends WatchUi.View {
    private var mTimer = new Timer.Timer();
    private var mText;

    function initialize(text) {
        self.mText = text;
        View.initialize();
    }

    function onLayout(dc) {
        var layout = Rez.Layouts.FullScreenPopup(dc);
        layout[0].setText(self.mText);
        setLayout(layout);
        return View.onLayout(dc);
    }

    function onHide() {
        self.mTimer.stop();
        return true;
    }

    function onShow() {
        self.mTimer.start(method(:close), 2000, false);
        return true;
    }

    function open() {
        WatchUi.pushView(self, new WatchUi.BehaviorDelegate(), WatchUi.SLIDE_BLINK);
    }

    function close() {
        WatchUi.popView(WatchUi.SLIDE_BLINK);
        self.mTimer.stop();
    }
}
