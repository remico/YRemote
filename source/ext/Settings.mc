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

class SettingsItem {
    private var mKey;
    private var mValue;

    function initialize(key) {
        self.mKey = key;
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
    static var CamEnabled = new SettingsItem("CAM_ENABLED");
    static var CamUrl = new SettingsItem("CAM_URL");
    static var CamPort = new SettingsItem("CAM_PORT");
    static var DawEnabled = new SettingsItem("DAW_ENABLED");
    static var DawUrl = new SettingsItem("DAW_URL");
    static var DawPort = new SettingsItem("DAW_PORT");
}
