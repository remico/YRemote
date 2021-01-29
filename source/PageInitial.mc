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

class PageInitial extends PageBase {
    hidden var mMessage = "";

    function initialize() {
        PageBase.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.LayoutPageInitial(dc));
        return PageBase.onLayout(dc);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // Update the view
    function onUpdate(dc) {
        // if (!System.getDeviceSettings().phoneConnected) {
        //     dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        //     dc.clear();
        //     dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        // }
        // else {
        //     PageBase.onUpdate(dc);
        // }

        PageBase.onUpdate(dc);
        return true;
    }

    function showResponse(args) {
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
