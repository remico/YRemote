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
using Toybox.WatchUi;

class MenuPageCommunicationType extends CBMenu {

    private var mCallback;

    private enum {
        COMMTYPE_DIRECT_MESSAGING,
        COMMTYPE_HTTP_REQUESTS
    }

    function initialize(callback) {
        CBMenu.initialize();
        mCallback = callback;
        setTitle(Rez.Strings.CommunicationType_title_alias);
        addItem(Rez.Strings.CommunicationType_item_DirectMessaging, :directMessagingMenuItem, method(:onDirectMessagingMenuItem));
        addItem(Rez.Strings.CommunicationType_item_HttpRequest, :httpRequestsMenuItem, method(:onHttpRequestsMenuItem));
    }

    function onDirectMessagingMenuItem() {
        Util.feedback(1);
        AppSettings.CommunicationType.set(COMMTYPE_DIRECT_MESSAGING);
        mCallback.invoke(COMMTYPE_DIRECT_MESSAGING);
    }

    function onHttpRequestsMenuItem() {
        Util.feedback(1);
        AppSettings.CommunicationType.set(COMMTYPE_HTTP_REQUESTS);
        mCallback.invoke(COMMTYPE_HTTP_REQUESTS);
    }

    static function mapToString(value) {
        var resId;
        switch (value) {
            case MenuPageCommunicationType.COMMTYPE_DIRECT_MESSAGING:
                resId = Rez.Strings.CommunicationType_item_DirectMessaging;
                break;
            case MenuPageCommunicationType.COMMTYPE_HTTP_REQUESTS:
                resId = Rez.Strings.CommunicationType_item_HttpRequest;
                break;
        }
        return WatchUi.loadResource(resId);
    }
}
