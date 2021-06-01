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

class RemoteTargetFactory {

    static function newRemoteTarget(targetResponseCallback) {
        var communicationType = AppSettings.CommunicationType.get();

        switch (communicationType) {
        case COMMTYPE_DIRECT_MESSAGING:
            return new DmRemoteTarget(targetResponseCallback);
        case COMMTYPE_HTTP_REQUESTS:
            return new HttpRemoteTarget(targetResponseCallback);
        }
    }

}
