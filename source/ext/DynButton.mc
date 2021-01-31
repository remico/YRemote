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

class DynButton extends WatchUi.Button {
    private var mStateDefaultInactive;
    private var mStateHighlightedInactive;
    private var mStateSelectedInactive;

    private var mStateDefaultActive;
    private var mStateHighlightedActive;
    private var mStateSelectedActive;

    function initialize(params) {
        Button.initialize(params);

        mStateDefaultInactive = stateDefault;
        mStateHighlightedInactive = stateHighlighted;
        mStateSelectedInactive = stateSelected;

        mStateDefaultActive = new WatchUi.Bitmap({ :rezId => params.get(:stateDefaultActive) });
        mStateHighlightedActive = new WatchUi.Bitmap({ :rezId => params.get(:stateHighlightedActive) });
        mStateSelectedActive = new WatchUi.Bitmap({ :rezId => params.get(:stateSelectedActive) });

        if (params.hasKey(:id)) {
            self.identifier = params.get(:id);
        }
    }

    function activate(active) {
        if (active) {
            stateDefault = mStateDefaultActive;
            stateHighlighted = mStateHighlightedActive;
            stateSelected = mStateSelectedActive;
        } else {
            stateDefault = mStateDefaultInactive;
            stateHighlighted = mStateHighlightedInactive;
            stateSelected = mStateSelectedInactive;
        }
    }

    function active() {
        return stateDefault == mStateDefaultActive;
    }
}
