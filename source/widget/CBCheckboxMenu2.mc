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

class CBCheckboxMenu2 extends WatchUi.CheckboxMenu {
    private var mCallbacks = {};

    function initialize(title) {
        CheckboxMenu.initialize({:title=>title});
    }

    function addItem(item, identifier, callback) {
        CheckboxMenu.addItem(item);
        self.mCallbacks.put(identifier, callback);
    }

    function callback(identifier) {
        return self.mCallbacks.get(identifier);
    }
}
