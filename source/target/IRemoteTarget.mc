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
    protected var mTargetName = self.toString();
    protected var mTargetResponseCallback;

    function initialize(targetResponseCallback) {
        self.mTargetResponseCallback = targetResponseCallback;
        setupRxCallback();
    }

    function makeRequestRemote(senderName, url, command, httpMethod, params, userContext) {
        var name = "";

        if (senderName instanceof Lang.String) {
            name = senderName;
        } else if (senderName instanceof Lang.Number) {
            name = WatchUi.loadResource(senderName);
        }

        Util.log("=> " + name + "::makeRequest2(" + command + ") ...");

        if (!System.getDeviceSettings().phoneConnected) {
            self.mTargetResponseCallback.invoke($.Y_ERROR_NO_CONNECTION);
            return;
        }

        doRequest(name, url, command, httpMethod, params, userContext);
    }

    protected function doRequest(senderName, url, command, httpMethod, params, userContext) {
        // do nothing; implement in subclasses
    }

    protected function setupRxCallback() {
        if (AppSettings.hasDirectMessagingSupport) {
            Communications.registerForPhoneAppMessages(null);
        }
    }
}
