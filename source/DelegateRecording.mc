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

    function initialize() {
        BehaviorDelegate.initialize();

        var cam_url = AppSettings.CamUrl.get() + ":" + AppSettings.CamPort.get();
        var daw_url = AppSettings.DawUrl.get() + ":" + AppSettings.DawPort.get();

        self.mYiCamera = new YiCamera(cam_url);
        self.mDaw = new ReaperDaw(daw_url);
    }

    function onKeyPressed(evt) {
        if( evt.getKey() == KEY_ENTER) {
            // Util.log("KEY_ENTER pressed");
        }
        return true;
    }

    // ----------- system menu begin ----------
    function onMenu() {
        var menu = new CBMenu(Rez.Strings.MenuHeaderMain);
        var delegate = new CBMenuDelegate(menu);

        menu.addItem(Rez.Strings.MenuItemSettings, :settings, method(:onMenuSettings));

        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onMenuSettings() {
        Util.feedback(1);
        var menu = new MenuPageSettings();
        var delegate = new MenuSettingsDelegate(menu);
        WatchUi.switchToView(menu, delegate, WatchUi.SLIDE_BLINK);
    }
    // ------------ system menu end -----------

    function startRecording() {
        Util.feedback(1);

        if (cameraEnabled()) {
            self.mYiCamera.recStart(method(:_StartRecordingOk));
        } else {
            self.mDaw.recStart();
        }
    }

    function _StartRecordingOk(d) {
        AppState.set($.Y_STATE_RECORDING);
        self.mDaw.recStart();
    }

    function restartRecording() {
        Util.feedback(1);

        if (cameraEnabled()) {
            self.mYiCamera.recRestart(method(:_onRestartRecordingOk));
        } else {
            self.mDaw.recRestart();
        }
    }

    function _onRestartRecordingOk(d) {
        self.mDaw.recRestart();
    }

    function stopRecording() {
        Util.feedback(2);

        if (cameraEnabled()) {
            self.mYiCamera.recStop(method(:_onStopRecordingOk));
        } else {
            self.mDaw.recStop();
        }
    }

    function _onStopRecordingOk(d) {
        AppState.set($.Y_STATE_IDLE);

        var timer = new Timer.Timer();
        timer.start(method(:_onStopTimeoutOk), 2000, false);

        self.mDaw.recStop();
    }

    function _onStopTimeoutOk() {
        // self.mYiCamera.liveStop();
    }

    function onCamera() {
        Util.feedback(1);

        var menu = new MenuPageCamera(self.mYiCamera);
        var delegate = new CBMenuDelegate(menu);
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    function onDaw() {
        Util.feedback(1);
    }

    function onButtonRec() {
        if (AppState.isRecording()) {
            restartRecording();
        } else {
            startRecording();
        }
    }

    function onButtonStop() {
        stopRecording();
    }

    private function cameraEnabled() {
        return AppSettings.CamEnabled.get();
    }
}
