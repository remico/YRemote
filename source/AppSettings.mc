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
using Toybox.Application.Properties;
using Toybox.Communications;

class AppSettingsItem {
    private var mKey;
    private var mValue;

    function initialize(propertyId) {
        self.mKey = propertyId;
    }

    function get() {
        // return self.mValue;
        return read();
    }

    function set(value) {
        self.mValue = value;
        Properties.setValue(self.mKey, value);
    }

    function read() {
        self.mValue = Properties.getValue(self.mKey);
        return self.mValue;
    }
}


class AppSettings {
    static var CommunicationType = new AppSettingsItem("COMMUNICATION_TYPE");
    static var CamEnabled = new AppSettingsItem("CAM_ENABLED");
    static var CamUrl = new AppSettingsItem("CAM_URL");
    static var CamPort = new AppSettingsItem("CAM_PORT");
    static var DawEnabled = new AppSettingsItem("DAW_ENABLED");
    static var DawUrl = new AppSettingsItem("DAW_URL");
    static var DawPort = new AppSettingsItem("DAW_PORT");

    static var hasDirectMessagingSupport = (Communications has :registerForPhoneAppMessages);
}
