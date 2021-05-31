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

class CBMenu extends WatchUi.Menu {
    private var mCallbacks = {};

    function initialize(title) {
        WatchUi.Menu.initialize();
        setTitle(title);
    }

    function addItem(name, identifier, callback) {
        WatchUi.Menu.addItem(name, identifier);
        self.mCallbacks.put(identifier, callback);
    }

    function callback(identifier) {
        return self.mCallbacks.get(identifier);
    }
}


class CBMenuDelegate extends WatchUi.MenuInputDelegate {
    private var mMenu;

    function initialize(menu) {
        self.mMenu = menu;
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        var callback = self.mMenu.callback(item);
        if (callback != null) {
            callback.invoke();
        }
    }
}
