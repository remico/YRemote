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

class ReaperDaw extends IRemoteTarget {

    private enum {
        REA_REC_START = 1013,
        REA_REC_STOP_SAV = 40667,
        REA_REC_STOP_DEL = 40668,
        REA_REC_RESTART = REA_REC_STOP_DEL + ";" + REA_REC_START,
    }

    function initialize(url, targetResponseCallback) {
        IRemoteTarget.initialize(Rez.Strings.TargetNameDaw, url, targetResponseCallback);
    }

    function isEnabled() {
        return AppSettings.DawEnabled.get();
    }

    function recStart() {
        makeRequest2(REA_REC_START, method(:_onRecStartOk));
    }

    function _onRecStartOk(d) {
        Util.log("_onRecStartOk");
    }

    function recRestart() {
        makeRequest2(REA_REC_RESTART, method(:_onRecRestartOk));
    }

    function _onRecRestartOk(d) {
        Util.log("_onRecRestartOk");
    }

    function recStop() {
        makeRequest2(REA_REC_STOP_SAV, method(:_onRecStopOk));
    }

    function _onRecStopOk(d) {
        Util.log("_onRecStopOk");
    }

    function makeRequest(command) {
        makeRequest2(command, null);
    }

    function makeRequest2(command, userContext) {
        var url = targetUrl() + "/_/" + command + ";TRANSPORT;";

        IRemoteTarget.makeRequest2(
            url,
            command,
            Communications.HTTP_REQUEST_METHOD_GET,
            null,
            userContext
        );
    }
}
