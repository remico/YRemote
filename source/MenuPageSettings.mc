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
using Toybox.WatchUi;

class MenuPageSettings extends CBMenu2 {
    function initialize() {
        CBMenu2.initialize(Rez.Strings.MenuHeaderSettings);
    }
}


class MenuSettingsDelegate extends CBMenu2Delegate {
    function initialize(menu) {
        CBMenu2Delegate.initialize(menu);
        fillMenu(menu);
    }

    private function fillMenu(menu) {
        var itemCamera = new WatchUi.ToggleMenuItem(
            Rez.Strings.MenuItemCamera,
            Rez.Strings.MenuItemCameraSub,
            :itemCamera,
            AppSettings.CamEnabled.get(),
            {}
        );
        menu.addItem(itemCamera, :itemCamera, method(:_onItemCamera));

        var itemDaw = new WatchUi.ToggleMenuItem(
            Rez.Strings.MenuItemDaw,
            Rez.Strings.MenuItemDawSub,
            :itemDaw,
            AppSettings.DawEnabled.get(),
            {}
        );
        menu.addItem(itemDaw, :itemDaw, method(:_onItemDaw));

        var itemCommunicationType = new WatchUi.MenuItem(
            Rez.Strings.CommunicationType_title_alias,
            MenuPageCommunicationType.mapValueToString(AppSettings.CommunicationType.get()),
            :itemCommunicationType,
            null
        );
        menu.addItem(itemCommunicationType, :itemCommunicationType, method(:_onItemCommunicationType));
    }

    function _onItemCamera() {
        var idx = self.mMenu.findItemById(:itemCamera);
        var item = self.mMenu.getItem(idx);
        AppSettings.CamEnabled.set(item.isEnabled());
    }

    function _onItemDaw() {
        var idx = self.mMenu.findItemById(:itemDaw);
        var item = self.mMenu.getItem(idx);
        AppSettings.DawEnabled.set(item.isEnabled());
    }

    function _onItemCommunicationType() {
        var menu = new MenuPageCommunicationType();
        var delegate = new CBMenuDelegate(menu);
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_BLINK);
    }
}
