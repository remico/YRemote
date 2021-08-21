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

class DmRemoteTarget extends RemoteTargetBase {

    private enum DmPacketFields {
        DMPKT_CNTXID = "cntxid",
        DMPKT_PAYLOAD = "payload"
    }

    private var mListener = new DmConnectionListener(null, method(:onTxError));
    private var mUserContextStorage = new UserContextStorage();
    private var mCurrentContextId;  // valid only for callbacks in current transmission process

    function initialize(targetResponseCallback) {
        RemoteTargetBase.initialize(targetResponseCallback);
    }

    protected function doRequest(senderName, url, command, httpMethod, params, userContext) {
        var cntx = new UserContext(senderName, userContext);
        self.mUserContextStorage.saveContext(cntx);

        self.mCurrentContextId = cntx.id;

        var data = params != null ? params : url.toString();
        var txPacket = {
            DMPKT_CNTXID => cntx.id,
            DMPKT_PAYLOAD => data
        };

        Communications.transmit(txPacket, {}, self.mListener);
    }

    function onTxError() {
        var cntx = self.mUserContextStorage.popContext(self.mCurrentContextId);
        var eMsg = "<= EE: " + cntx.senderName + ": " + "DM transmission failed";
        self.mTargetResponseCallback.invoke(eMsg);
    }

    function onRxCallback(msg) {
        var cntxid = msg.data.get(DMPKT_CNTXID);
        var body = msg.data.get(DMPKT_PAYLOAD);

        var userContext = self.mUserContextStorage.popContext(cntxid);
        if (userContext != null && userContext.payload != null && userContext.payload has :invoke) {
            userContext.payload.invoke(body);
        }

        self.mTargetResponseCallback.invoke(body);
    }

    protected function setupRxCallback() {
        if (AppSettings.hasDirectMessagingSupport) {
            Communications.registerForPhoneAppMessages(method(:onRxCallback));
        }
    }
}
