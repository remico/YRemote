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

enum {
    Y_STATE_IDLE,
    Y_STATE_RECORDING
}

class AppState {
    static var mAppState = Y_STATE_IDLE;

    static function set(state) {
        self.mAppState = state;
        WatchUi.requestUpdate();
    }

    static function isRecording() {
        return self.mAppState == Y_STATE_RECORDING;
    }
}
