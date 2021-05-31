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

class IRemoteTarget {
    private var mTargetName = self.toString();
    private var mTargetUrl = "";
    private var mTargetResponseCallback;

    function initialize(name, url, targetResponseCallback) {
        self.mTargetUrl = url;
        self.mTargetResponseCallback = targetResponseCallback;

        if (name instanceof Lang.String) {
            self.mTargetName = name;
        } else if (name instanceof Lang.Number) {
            self.mTargetName = WatchUi.loadResource(name);
        }

        if (AppSettings.hasDirectMessagingSupport) {
            Communications.registerForPhoneAppMessages(method(:onDmRxCallback));
        }
    }

    function isEnabled() {
        return true;
    }

    function targetUrl() {
        return self.mTargetUrl;
    }

    function makeRequest(url, command, httpMethod, params) {
        makeRequest2(url, command, httpMethod, params, null, null);
    }

    // params - dict, http request data
    function makeRequest2(url, command, httpMethod, params, userContext) {
        if (!isEnabled()) {
            return;
        }

        Util.log("=> " + self.mTargetName + "::makeRequest2(" + command + ") ...");

        if (!System.getDeviceSettings().phoneConnected) {
            self.mTargetResponseCallback.invoke($.Y_ERROR_NO_CONNECTION);
            return;
        }

        var communicationType = AppSettings.CommunicationType.get();

        switch (communicationType) {
        case COMMTYPE_HTTP_REQUESTS: {
            doHttpRequest(url, command, httpMethod, params, userContext);
            break;
        }

        case COMMTYPE_DIRECT_MESSAGING: {
            doDirecmMessagingRequest(url, command, httpMethod, params, userContext);
            break;
        }

        default:
            Util.log("Unsupported CommunicationType: " + communicationType);
        }
    }

    private function doHttpRequest(url, command, httpMethod, params, userContext) {
        var options = {
            :method => httpMethod,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            },
            :context => userContext
        };
        var callback = userContext != null ? method(:onHttpRxCntx) : method(:onHttpRx);
        Communications.makeWebRequest(url, params, options, callback);
    }

    private function doDirecmMessagingRequest(url, command, httpMethod, params, userContext) {
        var data = "";

        if (params != null) {
            // CAM => build json
            for (var i = 0; i < params.size(); ++i) {
                var key = params.keys()[i];
                var value = params[key];

                data += "\"" + key + "\"=";

                if (value instanceof Lang.String) {
                    data += "\"" + value + "\"";
                } else if (value instanceof Lang.Number) {
                    data += value;
                } else if (value == null) {
                    data += "null";
                }

                if (i + 1 < params.size()) {
                    data += ",";
                }
            }
            data = "{" + data + "}";
        } else {
            // DAW => commands encoded in URLs
            data = url.toString();
        }

        var listener = new DMConnectionListener(null, method(:onDmTxError));
        Communications.transmit(data, {}, listener);
    }

    function onHttpRx(responseCode, data) {
        onHttpRxCntx(responseCode, data, null);
    }

    function onHttpRxCntx(responseCode, data, userContext) {
        if (responseCode == 200) {  // http OK
            if (userContext != null && userContext has :invoke) {
                userContext.invoke(data);
            }
            self.mTargetResponseCallback.invoke(data);
        } else {
            var eMsg = "<= EE: " + self.mTargetName + ": " + responseCode.toString();
            self.mTargetResponseCallback.invoke(eMsg);
        }
    }

    function onDmTxError() {
        var eMsg = "<= EE: " + self.mTargetName + ": " + "DM transmission failed";
        self.mTargetResponseCallback.invoke(eMsg);
    }

    function onDmRxCallback(msg) {
        self.mTargetResponseCallback.invoke(msg.data);
    }
}
