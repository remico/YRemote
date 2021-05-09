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

class PopupQueue {
    private var mMessageQueue = new [0];
    private var mPopup;

    function showMessage(text) {
        var popup = popup();
        if (popup == null) {
            popup = new Popup(text);
            self.mPopup = popup.weak();
            popup.open();
        } else {
            self.mMessageQueue.add(text);
            popup.subscribeToClose(method(:_onPopupClosed));
        }
    }

    private function popup() {
        return self.mPopup != null && self.mPopup.stillAlive() ?
                  self.mPopup.get()
                : null;
    }

    function _onPopupClosed() {
        var msg = next();
        var popup = popup();
        if (msg != null && popup != null) {
            popup.openWithText(msg);
        }
    }

    private function next() {
        if (self.mMessageQueue.size() > 0) {
            var msg = self.mMessageQueue[0];
            self.mMessageQueue.remove(msg);
            return msg;
        }
        return null;
    }
}
