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

import requests
from urllib.parse import unquote
from http import HTTPStatus

from . import response

__all__ = ['wsgi_daw']

DAW_TIMEOUT = 2

session = None

def wsgi_daw(target, app_env, start_response):
    global session

    if session is None:
        session = requests.Session()

    incoming_request = app_env['PATH_INFO']
    print("@@ DAW REQUEST", incoming_request)

    daw_url = f"http://{target[0]}:{target[1]}"
    daw_request = daw_url + incoming_request

    try:
        daw_response = session.get(daw_request, timeout=DAW_TIMEOUT)
    except (
            requests.exceptions.Timeout,
            requests.exceptions.ConnectionError
        ) as ex:
        return response.error(start_response, HTTPStatus.SERVICE_UNAVAILABLE, incoming_request)

    if daw_response.status_code == HTTPStatus.OK.value:
        body = f'{{"DAW says": "{daw_response.text.strip()}"}}'
        print(f"@@ DAW RESPONSE:", body)
        return response.success(start_response, body)
    else:
        daw_status = response.format_status(HTTPStatus(daw_response.status_code))
        return response.error(start_response, daw_status, incoming_request)
