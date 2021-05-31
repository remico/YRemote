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
using Toybox.Application;

class YRemoteApp extends Application.AppBase {
    private var mResponseQueue = new PopupQueue();

    function initialize() {
        AppBase.initialize();

        // force reset settings before the app starts
        if (!AppSettings.hasDirectMessagingSupport
                && AppSettings.CommunicationType.get() == COMMTYPE_DIRECT_MESSAGING) {
            AppSettings.CommunicationType.set(COMMTYPE_HTTP_REQUESTS);
        }

        Util.log("\n### STARTED: " + Util.timestamp());
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        var view = new PageInitial();
        var delegate = new DelegateRecording(method(:_onTargetResponse));
        return [view, delegate];
    }

    function _onTargetResponse(args) {
        var message = "";

        // remote target error
        if (args instanceof Lang.String) {
            self.mResponseQueue.showMessage(args);
            message = args;
        }
        // remote target response
        else if (args instanceof Lang.Dictionary) {
            var keys = args.keys();
            for( var i = 0; i < keys.size(); i++ ) {
                message += Lang.format("$1$: $2$\n", [ keys[i], args[keys[i]] ]);
            }

            if (args.hasKey("rval") && args["rval"] != 0) {
                self.mResponseQueue.showMessage(message);
            }
        }
        // application errors
        else if (args instanceof Lang.Number) {
            switch (args) {
                case $.Y_ERROR_NO_CONNECTION:
                    message = loadResource(Rez.Strings.AlertNoConnection);
                    self.mResponseQueue.showMessage(message);
                    break;
            }
        }

        Util.log(message);
    }
}
