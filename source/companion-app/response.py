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

import json
from http import HTTPStatus


def format_status(status: HTTPStatus):
    return str(status.value)  + " " + status.phrase


def error(start_response, http_status, msg, param=None):
    headers = [
        ("Content-Type", "application/json")
    ]

    start_response(format_status(http_status), headers)
    body = [
        f'{{"param": "{param}", "error": "{msg}"}}'.encode()
    ]

    return body


def success(start_response, body):
    headers = [
        ("Content-Type", "application/json")
    ]

    start_response(format_status(HTTPStatus.OK), headers)

    if isinstance(body, str):
        body = body.encode()
    elif not isinstance(body, (bytes, bytearray)):
        body = json.dumps(body).encode()

    return [ body ]
