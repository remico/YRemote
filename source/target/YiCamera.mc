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
using Toybox.Timer;
using Toybox.WatchUi;

const YI_TOKEN = "YI_TOKEN";

class YiCameraCallback extends ConditionalMethod {
    static const mConditions = {
        "rval" => 0,
    };

    function initialize(aClass, aMethod) {
        ConditionalMethod.initialize(aClass, aMethod, self.mConditions);
    }

    static function method(aCallback, arg) {
        return ConditionalMethod.method(aCallback, arg, self.mConditions);
    }

    static function deferredMethod(aCallback, arg, delay) {
        return ConditionalMethod.deferredMethod(aCallback, arg, delay, self.mConditions);
    }
}


class YiCamera extends IRemoteTarget {

    private enum {
        YI_CMD_AUTHENTICATE = 257,
        YI_CMD_DEAUTHORIZE = 258,
        YI_CMD_LIVE_START = 259,
        YI_CMD_LIVE_STOP = 260,
        YI_CMD_REC_START = 513,
        YI_CMD_REC_STOP = 514,
        YI_CMD_CAPTURE_PHOTO = 769,
        YI_CMD_MEDIA_REMOVE = 1281,
    }

    function initialize(url, webCallback) {
        IRemoteTarget.initialize("CAM", url, webCallback);
    }

    private function getYiToken() {
        return Application.Storage.getValue(YI_TOKEN);
    }

    function authenticate() {
        makeRequest2(YI_CMD_AUTHENTICATE, method(:_onAuthenticateOk));
    }

    function _onAuthenticateOk(d) {
        Application.Storage.setValue(YI_TOKEN, d["param"]);
        liveStart();
    }

    function deauthorize() {
        makeRequest(YI_CMD_DEAUTHORIZE);
    }

    function liveStart() {
        makeRequest(YI_CMD_LIVE_START);
    }

    function liveStop() {
        makeRequest(YI_CMD_LIVE_STOP);
    }

    function recStart(callback) {
        makeRequest2(YI_CMD_REC_START, YiCameraCallback.method(callback, null));
    }

    function recRestart(callback) {
        makeRequest2(YI_CMD_REC_STOP, YiCameraCallback.deferredMethod(method(:recStart), callback, 2000));
    }

    function recStop(callback) {
        makeRequest2(YI_CMD_REC_STOP, YiCameraCallback.method(callback, null));
    }

    function removeMedia(path) {
        // makeRequest(YI_CMD_MEDIA_REMOVE);  TODO: pass a path to makeRequest()
    }

    function capturePhoto() {
        makeRequest(YI_CMD_CAPTURE_PHOTO);
    }

    function makeRequest(command) {
        makeRequest2(command, null);
    }

    function makeRequest2(command, userContext) {
        var params = {
            "msg_id" => command,
            "token" => self.getYiToken()
        };

        IRemoteTarget.makeRequest2(
            targetUrl(),
            command,
            Communications.HTTP_REQUEST_METHOD_POST,
            params,
            userContext
        );
    }
}

// {"token":15,"msg_id":1283,"param":"/tmp/fuse_d/DCIM/100MEDIA"}
// {"token":15,"msg_id":1282,"param":"/tmp/fuse_d/DCIM/100MEDIA"}
// {"token":15,"msg_id":1282,"param":"/tmp/SD0/DCIM/100MEDIA"}
// {"token":15,"msg_id":1282}
// {"token":15,"msg_id":1281,"param":"*"}
// {"token":15,"msg_id":1281,"param":"/tmp/fuse_d/DCIM/100MEDIA/YI041101.MP4"}
// {"token":15,"msg_id":1026,"param":"/tmp/fuse_d/DCIM/100MEDIA/YIAC0408.JPG"}
// {"token":15,"msg_id":13}
// {"token":15,"msg_id":5,"type":"free"}
// {"token":15,"msg_id":5,"type":"total"}

