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

from . import response
from .camera import YiCamera

__all__ = ['wsgi_cam']


def wsgi_cam(camera: YiCamera, app_env, start_response):
    """WSGI app

    Args:
        app_env (dict): WSGI environment
        start_response (callback): starts http response by sending http headers

    Returns:
        list: body of the response represented by a list of encoded strings (bytes)
    """

    assert app_env["CONTENT_TYPE"] == "application/json", "Request must be a JSON object"

    # handle watch request
    in_datalen = int(app_env["CONTENT_LENGTH"])
    in_data = app_env["wsgi.input"].read(in_datalen)

    in_body = json.loads(in_data.decode())
    print(f"@@ CAM REQUEST:", in_body)

    # validate input
    try:
        current_msg_id = in_body['msg_id']
    except Exception as key_error:
        return response.error(start_response, HTTPStatus.BAD_REQUEST, "missing msg_id")

    # communicate to camera
    try:
        if not camera.connected():
            camera.connect()
        camera.send(in_data)
        yi_json = camera.wait_response(current_msg_id)

    except Exception as ex:
        return response.error(start_response, HTTPStatus.SERVICE_UNAVAILABLE, ex, current_msg_id)

    # replace the default CAM url with the correct one
    if "rtsp" in yi_json:
        yi_json["rtsp"] = f"rtsp://{camera.m_address}/live"

    # respond to watch
    print(f"@@ CAM RESPONSE:", yi_json)
    return response.success(start_response, yi_json)
