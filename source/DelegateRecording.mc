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
using Toybox.Application;
using Toybox.Lang;
using Toybox.Timer;
using Toybox.WatchUi;

class DelegateRecording extends WatchUi.BehaviorDelegate {
    private var mYiCamera;
    private var mDaw;

    // Set up the callback to the view
    function initialize(notify) {
        BehaviorDelegate.initialize();

        var YI_URL = Application.Properties.getValue("CAM_URL") + ":"
                   + Application.Properties.getValue("CAM_PORT");
        var DAW_URL = Application.Properties.getValue("DAW_URL") + ":"
                    + Application.Properties.getValue("DAW_PORT");

        self.mYiCamera = new YiCamera(YI_URL, notify);
        self.mDaw = new ReaperDaw(DAW_URL, notify);
    }

    function onKeyPressed(evt) {
        if( evt.getKey() == KEY_ENTER) {
            // Util.log("KEY_ENTER pressed");
        }
        return true;
    }

    // ----------- menu begin ----------
    function onMenu() {
        var menu = new CBMenu();
        var delegate = new CBMenuDelegate(menu);

        menu.setTitle("Yi camera");
        menu.addItem("Authenticate?", :authenticate, method(:onMenuAuthenticate));
        menu.addItem("Start Live", :liveStart, method(:onMenuLiveStart));
        menu.addItem("Stop Live", :liveStop, method(:onMenuLiveStop));

        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onMenuAuthenticate() {
        WatchUi.switchToView(
            new WatchUi.Confirmation("Authenticate?"),
            new YesDelegate(method(:_onAuthConfirmed)),
            WatchUi.SLIDE_IMMEDIATE
        );
    }

    function _onAuthConfirmed() {
        Util.feedback(1);
        self.mYiCamera.authenticate();
    }

    function onMenuLiveStart() {
        Util.feedback(1);
        self.mYiCamera.liveStart();
    }

    function onMenuLiveStop() {
        Util.feedback(1);
        self.mYiCamera.liveStop();
    }
    // ------------ menu end -----------

    function onPlay() {
        Util.feedback(1);
        self.mYiCamera.recStart(method(:_onPlayOk));
    }

    function _onPlayOk(d) {
        var view = new PageRecording();
        WatchUi.switchToView(view, self, WatchUi.SLIDE_BLINK);
        self.mDaw.recStart();
    }

    function onReplay() {
        Util.feedback(1);
        self.mYiCamera.recRestart(method(:_onRecReplayOk));
    }

    function _onRecReplayOk(d) {
        self.mDaw.recRestart();
    }

    function onStop() {
        Util.feedback(2);
        self.mYiCamera.recStop(method(:_onStopOk));
    }

    function _onStopOk(d) {
        var view = new PageInitial();
        WatchUi.switchToView(view, self, WatchUi.SLIDE_BLINK);

        var timer = new Timer.Timer();
        timer.start(method(:_onStopTimeoutOk), 2000, false);

        self.mDaw.recStop();
    }

    function _onStopTimeoutOk() {
        // self.mYiCamera.liveStop();
    }
}
