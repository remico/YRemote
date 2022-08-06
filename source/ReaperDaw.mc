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
using Toybox.Communications;
using Toybox.WatchUi;

class ReaperDaw {

    private enum {
        REA_REC_START = 1013,
        REA_REC_STOP_SAV = 40667,
        REA_REC_STOP_DEL = 40668,
        REA_REC_RESTART = REA_REC_STOP_DEL + ";" + REA_REC_START,
        REA_RESET_ALL_MIDI_DEVICES = 41175,
        REA_RESET_ALL_MIDI_CONTROL_DEVICES = 42348,
        REA_DELETE_ACTIVE_TAKE = 40129,
    }

    private var mUrl;

    function initialize(url) {
        mUrl = url;
    }

    function isEnabled() {
        return AppSettings.DawEnabled.get();
    }

    function recStart(callback) {
        makeRequest2(REA_REC_START, callback);
    }

    // function _onRecStartOk(d) {
    //     AppState.set($.Y_STATE_RECORDING);
    // }

    function recRestart() {
        makeRequest2(REA_REC_RESTART, method(:_onRecRestartOk));
    }

    function _onRecRestartOk(d) {}

    function recStop(callback) {
        makeRequest2(REA_REC_STOP_SAV, callback);
    }

    // function _onRecStopOk(d) {
    //     AppState.set($.Y_STATE_IDLE);
    // }

    function makeRequest(command) {
        makeRequest2(command, null);
    }

    function makeRequest2(command, userContext) {
        if (!isEnabled()) {
            return;
        }

        YRemoteApp.RemoteTarget.makeRequestRemote(
            Rez.Strings.TargetNameDaw,
            mUrl + "/_/" + command + ";TRANSPORT;",
            command,
            Communications.HTTP_REQUEST_METHOD_GET,
            null,
            userContext
        );
    }
}
