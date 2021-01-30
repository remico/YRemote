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
using Toybox.Application.Properties;
using Toybox.Lang;
using Toybox.Timer;
using Toybox.WatchUi;

class DelegateRecording extends WatchUi.BehaviorDelegate {
    private var mYiCamera;
    private var mDaw;

    // Set up the callback to the view
    function initialize(notify) {
        BehaviorDelegate.initialize();

        var YI_URL = Properties.getValue($.SETTINGS_CAM_URL) + ":" + Properties.getValue($.SETTINGS_CAM_PORT);
        var DAW_URL = Properties.getValue($.SETTINGS_DAW_URL) + ":" + Properties.getValue($.SETTINGS_DAW_PORT);

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
        menu.addItem("Settings", :settings, method(:onMenuSettings));

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
        if (cameraEnabled()) {
            self.mYiCamera.authenticate();
        }
    }

    function onMenuLiveStart() {
        Util.feedback(1);
        if (cameraEnabled()) {
            self.mYiCamera.liveStart();
        }
    }

    function onMenuLiveStop() {
        Util.feedback(1);
        if (cameraEnabled()) {
            self.mYiCamera.liveStop();
        }
    }

    function onMenuSettings() {
        Util.feedback(1);
        var menu = new MenuSettings();
        var delegate = new MenuSettingsDelegate(menu);
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_BLINK);
    }
    // ------------ menu end -----------

    function onStartRecording() {
        Util.feedback(1);

        if (cameraEnabled()) {
            self.mYiCamera.recStart(method(:_StartRecordingOk));
        }
        else if (dawEnabled()) {
            self.mDaw.recStart();
        }
    }

    function _StartRecordingOk(d) {
        var view = new PageRecording();
        WatchUi.switchToView(view, self, WatchUi.SLIDE_BLINK);
        self.mDaw.recStart();
    }

    function onRestartRecording() {
        Util.feedback(1);

        if (cameraEnabled()) {
            self.mYiCamera.recRestart(method(:_onRestartRecordingOk));
        }
        else if (dawEnabled()) {
            self.mDaw.recRestart();
        }
    }

    function _onRestartRecordingOk(d) {
        self.mDaw.recRestart();
    }

    function onStopRecording() {
        Util.feedback(2);

        if (cameraEnabled()) {
            self.mYiCamera.recStop(method(:_onStopRecordingOk));
        }
        else if (dawEnabled()) {
            self.mDaw.recStop();
        }
    }

    function _onStopRecordingOk(d) {
        var view = new PageInitial();
        WatchUi.switchToView(view, self, WatchUi.SLIDE_BLINK);

        var timer = new Timer.Timer();
        timer.start(method(:_onStopTimeoutOk), 2000, false);

        self.mDaw.recStop();
    }

    function _onStopTimeoutOk() {
        // self.mYiCamera.liveStop();
    }

    private function cameraEnabled() {
        return Properties.getValue($.SETTINGS_CAM_ENABLED);
    }

    private function dawEnabled() {
        return Properties.getValue($.SETTINGS_DAW_ENABLED);
    }
}
