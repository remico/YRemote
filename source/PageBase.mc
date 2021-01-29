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
    private var mResponseQueue = new PopupQueue();

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

    function _onTargetResponse(args) {
        var message = "";

        // remote target error
        if (args instanceof Lang.String) {
            self.mResponseQueue.showMessage(args);
            message = args;
        }
        // remote target response
        else if (args instanceof Lang.Dictionary) {
            var keys = args.keys();
            for( var i = 0; i < keys.size(); i++ ) {
                message += Lang.format("$1$: $2$\n", [ keys[i], args[keys[i]] ]);
            }

            if (args.hasKey("rval") && args["rval"] != 0) {
                self.mResponseQueue.showMessage(message);
            }
        }
        // application errors
        else if (args instanceof Lang.Number) {
            switch (args) {
                case $.Y_ERROR_NO_CONNECTION:
                    message = loadResource(Rez.Strings.AlertNoConnection);
                    self.mResponseQueue.showMessage(message);
                    break;
            }
        }

        Util.log(message);
    }
}
