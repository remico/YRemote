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
using Toybox.Communications;

class DmConnectionListener extends Communications.ConnectionListener {

    private var mOnOk;
    private var mOnError;

    function initialize(onOk, onError) {
        ConnectionListener.initialize();
        self.mOnOk = onOk;
        self.mOnError = onError;
    }

    function onComplete() {
        ConnectionListener.onComplete();
        if (self.mOnOk != null) {
            mOnOk.invoke();
        }
    }

    function onError() {
        ConnectionListener.onError();
        if (self.mOnError != null) {
            mOnError.invoke();
        }
    }

}
