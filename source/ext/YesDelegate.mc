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

class YesDelegate extends WatchUi.ConfirmationDelegate {
    private var mOnYes;

    function initialize(onYes) {
        ConfirmationDelegate.initialize();
        self.mOnYes = onYes;
    }

    function onResponse(response) {
        if (response == WatchUi.CONFIRM_YES) {
            mOnYes.invoke();
        }
    }
}
