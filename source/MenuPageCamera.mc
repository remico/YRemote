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

class MenuPageCamera extends CBMenu {
    var mCamera;

    function initialize(camera) {
        CBMenu.initialize();

        self.mCamera = camera;

        setTitle(Rez.Strings.MenuHeaderCamera);
        addItem(Rez.Strings.MenuItemAuthConfirmationRequest, :authenticate, method(:onMenuAuthenticate));
        addItem(Rez.Strings.MenuItemLiveStart, :liveStart, method(:onMenuLiveStart));
        addItem(Rez.Strings.MenuItemLiveStop, :liveStop, method(:onMenuLiveStop));
    }

    function onMenuAuthenticate() {
        var text = loadResource(Rez.Strings.MenuItemAuthConfirmationRequest);
        WatchUi.switchToView(
            new WatchUi.Confirmation(text),
            new YesDelegate(method(:_onAuthConfirmed)),
            WatchUi.SLIDE_IMMEDIATE
        );
    }

    function _onAuthConfirmed() {
        Util.feedback(1);
        self.mCamera.authenticate();
    }

    function onMenuLiveStart() {
        Util.feedback(1);
        self.mCamera.liveStart();
    }

    function onMenuLiveStop() {
        Util.feedback(1);
        self.mCamera.liveStop();
    }

}
