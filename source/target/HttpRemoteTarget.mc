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

class HttpRemoteTarget extends IRemoteTarget {

    private var mSenderName = "";

    function initialize(targetResponseCallback) {
        IRemoteTarget.initialize(targetResponseCallback);
    }

    protected function doRequest(senderName, url, command, httpMethod, params, userContext) {
        self.mSenderName = senderName;

        var options = {
            :method => httpMethod,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            },
            :context => userContext
        };
        var callback = userContext != null ? method(:onRxCntx) : method(:onRx);
        Communications.makeWebRequest(url, params, options, callback);
    }

    function onRx(responseCode, data) {
        onRxCntx(responseCode, data, null);
    }

    function onRxCntx(responseCode, data, userContext) {
        if (responseCode == 200) {  // http OK
            if (userContext != null && userContext has :invoke) {
                userContext.invoke(data);
            }
            self.mTargetResponseCallback.invoke(data);
        } else {
            var eMsg = "<= EE: " + self.mSenderName + ": " + responseCode.toString();
            self.mTargetResponseCallback.invoke(eMsg);
        }
    }

}
