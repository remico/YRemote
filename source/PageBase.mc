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

class PageBase extends WatchUi.View {
    private var mLayout;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        if (!System.getDeviceSettings().phoneConnected) {
            self.mLayout = Rez.Layouts.FullScreenPopup(dc);

            var popup = self.mLayout[0];
            var message = WatchUi.loadResource(Rez.Strings.AlertNoConnection);

            popup.setText(message);
        }

        View.setLayout(self.mLayout);
        return true;
    }

    function setLayout(layout) {
        self.mLayout = layout;
    }
}
