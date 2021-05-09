#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#  This file is part of "YRemote Companion App" project
#
#  Author: Roman Gladyshev <remicollab@gmail.com>
#  License: BSD 3-clause "New" or "Revised" License
#
#  SPDX-License-Identifier: BSD-3-Clause
#  License text is available in the LICENSE file and online:
#  http://www.opensource.org/licenses/BSD-3-Clause
#
#  Copyright (c) 2021 remico

import selectors
import ssl
from functools import partial
from wsgiref.simple_server import make_server

from .camera import YiCamera
from .wsgi_camera import wsgi_app as camera_app
from .wsgi_daw import wsgi_daw as daw_app

SECURE = True
# SECURE = False

YI_ADDRESS = '192.168.0.106'
HTTPD_PORT = 7878

DAW_ADDRESS = '192.168.0.105'
DAW_PORT = 8080
HTTPD_DAW_PORT = 7879


def main():
    selector = selectors.DefaultSelector()
    acam = YiCamera(YI_ADDRESS, HTTPD_PORT, selector)

    acam_app = partial(camera_app, acam)
    httpd = make_server('', HTTPD_PORT, acam_app)

    adaw_app = partial(daw_app, (DAW_ADDRESS, DAW_PORT))
    httpd_daw = make_server('', HTTPD_DAW_PORT, adaw_app)

    if SECURE:
        # openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes
        httpd.socket = ssl.wrap_socket(httpd.socket,
                                       certfile="/home/user/Dvlp/keys/ycmp.home.crt",
                                       keyfile="/home/user/Dvlp/keys/ycmp.home.key",
                                       server_side=True)

        httpd_daw.socket = ssl.wrap_socket(httpd_daw.socket,
                                       certfile="/home/user/Dvlp/keys/ycmp.home.crt",
                                       keyfile="/home/user/Dvlp/keys/ycmp.home.key",
                                       server_side=True)

    selector.register(httpd, selectors.EVENT_READ, data=httpd.handle_request)
    selector.register(httpd_daw, selectors.EVENT_READ, data=httpd_daw.handle_request)

    while True:
        for selector_key, _ in selector.select():
            callback = selector_key.data
            callback()


if __name__ == '__main__':
    main()
