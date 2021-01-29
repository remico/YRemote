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
    hidden var mMessage = "";

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

    function onUpdate(dc) {
        // if (!System.getDeviceSettings().phoneConnected) {
        //     dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        //     dc.clear();
        //     dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        // }
        // else {
        //     View.onUpdate(dc);
        // }

        View.onUpdate(dc);
        return true;
    }

    function _onTargetResponse(args) {
        if (args instanceof Lang.String) {
            mMessage = args;
        }
        else if (args instanceof Dictionary) {
            // Print the arguments duplicated and returned by jsonplaceholder.typicode.com
            var keys = args.keys();
            mMessage = "<= : ";
            for( var i = 0; i < keys.size(); i++ ) {
                mMessage += Lang.format("$1$: $2$\n", [ keys[i], args[keys[i]] ]);
            }
        }
        WatchUi.requestUpdate();
        Util.log(mMessage);
    }
}
