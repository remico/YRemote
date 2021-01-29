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
    private var notifyClose;

    function initialize(text) {
        self.mText = text;
        View.initialize();
    }

    function onLayout(dc) {
        var layout = Rez.Layouts.FullScreenPopup(dc);
        setLayout(layout);
        return View.onLayout(dc);
    }

    function onHide() {
        self.mTimer.stop();

        if (self.notifyClose != null) {
            self.notifyClose.invoke();
        }

        return true;
    }

    function onShow() {
        var textArea = findDrawableById("PopupTextArea");
        textArea.setText(self.mText);
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

    function openWithText(text) {
        self.mText = text;
        open();
    }

    function subscribeToClose(callback) {
        self.notifyClose = callback;
    }
}
