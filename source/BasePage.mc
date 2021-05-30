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

class BasePage extends WatchUi.View {
    private var mLayout;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        if (!System.getDeviceSettings().phoneConnected) {
            self.mLayout = Rez.Layouts.FullScreenPopup(dc);

            var textArea = self.mLayout[0];
            var text = loadResource(Rez.Strings.AlertNoConnection);

            textArea.setText(text);
        }

        View.setLayout(self.mLayout);
        return true;
    }

    function setLayout(layout) {
        self.mLayout = layout;
    }

    function onUpdate(dc) {
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // dc.clear();
        // dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        View.onUpdate(dc);
        return true;
    }
}
