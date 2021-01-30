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

class CBMenu2 extends WatchUi.Menu2 {
    private var mCallbacks = {};

    function initialize(title) {
        Menu2.initialize({:title=>title});
    }

    function addItem(name, identifier, callback) {
        Menu2.addItem(name);
        self.mCallbacks.put(identifier, callback);
    }

    function callback(identifier) {
        return self.mCallbacks.get(identifier);
    }
}


class CBMenu2Delegate extends WatchUi.Menu2InputDelegate {
    protected var mMenu;

    function initialize(menu) {
        self.mMenu = menu;
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var callback = self.mMenu.callback(item.getId());
        if (callback != null) {
            callback.invoke();
        }
    }
}
