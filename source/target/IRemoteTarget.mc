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
    private var mWebCallback;

    function initialize(name, url, webCallback) {
        self.mTargetUrl = url;
        self.mWebCallback = webCallback;

        if (name instanceof Lang.String) {
            self.mTargetName = name;
        } else if (name instanceof Lang.Number) {
            self.mTargetName = WatchUi.loadResource(name);
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
            self.mWebCallback.invoke($.Y_ERROR_NO_CONNECTION);
            return;
        }

        var options = {
            :method => httpMethod,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            },
            :context => userContext
        };

        Communications.makeWebRequest(
            url,
            params,
            options,
            userContext ? method(:_onReceiveCntx) : method(:_onReceive)
        );
    }

    function _onReceive(responseCode, data) {
        _onReceiveCntx(responseCode, data, {});
    }

    function _onReceiveCntx(responseCode, data, userContext) {
        if (responseCode == 200) {
            if (userContext instanceof Lang.Method) {
                userContext.invoke(data);
            }
            self.mWebCallback.invoke(data);
        } else {
            var eMsg = "<= EE: " + self.mTargetName + ": " + responseCode.toString();
            self.mWebCallback.invoke(eMsg);
        }
    }
}
