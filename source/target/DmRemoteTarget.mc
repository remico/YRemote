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

class DmRemoteTarget extends IRemoteTarget {

    private var mSenderName = "";

    function initialize(targetResponseCallback) {
        IRemoteTarget.initialize(targetResponseCallback);
    }

    protected function doRequest(senderName, url, command, httpMethod, params, userContext) {
        self.mSenderName = senderName;

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
                    data += "\"null\"";
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

        var listener = new DmConnectionListener(null, method(:onTxError));
        Communications.transmit(data, {}, listener);
    }

    function onTxError() {
        var eMsg = "<= EE: " + self.mSenderName + ": " + "DM transmission failed";
        self.mTargetResponseCallback.invoke(eMsg);
    }

    function onRxCallback(msg) {
        self.mTargetResponseCallback.invoke(msg.data);
    }

    protected function setupRxCallback() {
        if (AppSettings.hasDirectMessagingSupport) {
            Communications.registerForPhoneAppMessages(method(:onRxCallback));
        }
    }
}
