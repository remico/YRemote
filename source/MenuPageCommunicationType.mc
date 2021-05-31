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


enum {
    COMMTYPE_DIRECT_MESSAGING,
    COMMTYPE_HTTP_REQUESTS
}


class MenuPageCommunicationType extends CBCheckboxMenu2 {

    function initialize() {
        CBCheckboxMenu2.initialize(Rez.Strings.CommunicationType_title_alias);
    }

    static function mapToString(value) {
        var resId;
        switch (value) {
            case COMMTYPE_DIRECT_MESSAGING:
                resId = Rez.Strings.CommunicationType_item_DirectMessaging;
                break;
            case COMMTYPE_HTTP_REQUESTS:
                resId = Rez.Strings.CommunicationType_item_HttpRequest;
                break;
        }
        return WatchUi.loadResource(resId);
    }

}


class MenuPageCommunicationTypeDelegate extends CBMenu2Delegate {

    private var mCallback;
    private var mTempCommunicationTypeValue;

    function initialize(menu, callback) {
        mCallback = callback;
        mTempCommunicationTypeValue = AppSettings.CommunicationType.get();
        CBMenu2Delegate.initialize(menu);
        fillMenu(menu);
    }

    function fillMenu(menu) {
        if (AppSettings.hasDirectMessagingSupport) {
            var itemDirectMessaging = new WatchUi.CheckboxMenuItem(
                Rez.Strings.CommunicationType_item_DirectMessaging,
                null,
                :directMessagingMenuItem,
                mTempCommunicationTypeValue == COMMTYPE_DIRECT_MESSAGING,
                null
            );
            menu.addItem(itemDirectMessaging, :directMessagingMenuItem, method(:onDirectMessagingMenuItem));
        }

        var itemHttpRequests = new WatchUi.CheckboxMenuItem(
            Rez.Strings.CommunicationType_item_HttpRequest,
            null,
            :httpRequestsMenuItem,
            mTempCommunicationTypeValue == COMMTYPE_HTTP_REQUESTS,
            null
        );
        menu.addItem(itemHttpRequests, :httpRequestsMenuItem, method(:onHttpRequestsMenuItem));
    }

    private function updateUI() {
        if (AppSettings.hasDirectMessagingSupport) {
            var idx = mMenu.findItemById(:directMessagingMenuItem);
            mMenu.getItem(idx).setChecked(mTempCommunicationTypeValue == COMMTYPE_DIRECT_MESSAGING);
        }

        var idx = mMenu.findItemById(:httpRequestsMenuItem);
        mMenu.getItem(idx).setChecked(mTempCommunicationTypeValue == COMMTYPE_HTTP_REQUESTS);
    }

    private function setCommunicationType(value) {
        if (value != COMMTYPE_DIRECT_MESSAGING || AppSettings.hasDirectMessagingSupport) {
            Util.feedback(1);
            mTempCommunicationTypeValue = value;
        }
        updateUI();
    }

    function onDone() {
        AppSettings.CommunicationType.set(mTempCommunicationTypeValue);
        if (mCallback != null) {
            mCallback.invoke(mTempCommunicationTypeValue);
        }
        CBMenu2Delegate.onDone();
    }

    function onDirectMessagingMenuItem() {
        setCommunicationType(COMMTYPE_DIRECT_MESSAGING);
    }

    function onHttpRequestsMenuItem() {
        setCommunicationType(COMMTYPE_HTTP_REQUESTS);
    }

}
