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
import selectors
import socket
from contextlib import contextmanager

__all__ = ['YiCamera']

TCP_TIMEOUT = 5  # sec
YI_CMD_REC_STOP = 514


class SockReader:
    def __init__(self, sock) -> None:
        self.m_decoder = json.JSONDecoder()
        self.m_rx_buffer = ""
        self.m_sock = sock

    def __enter__(self):
        self._read_sock()
        return self._decode()

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is json.decoder.JSONDecodeError:
            pass  # leave remaining (i.e. incomplete) data in buffer as is
            return True

    def _read_sock(self):
        try:
            self.m_rx_buffer += self.m_sock.recv(1024).decode(errors="ignore")
        except ValueError as sock_error:
            print("EE: CAM socket reading error:", sock_error)
            self.m_rx_buffer = ""
            raise

    def _decode(self):
        while True:
            if not self.m_rx_buffer:
                return json.loads("{}")

            try:
                rx_data, end_idx = self.m_decoder.raw_decode(self.m_rx_buffer)
            except ValueError as decoding_error:
                print("EE: CAM rx buffer decoding error:", decoding_error)
                return json.loads("{}")

            self.m_rx_buffer = self.m_rx_buffer[end_idx:]
            yield rx_data


class YiCamera:
    def __init__(self, address, port, selector=None) -> None:
        self.m_address = address
        self.m_port = port
        self.m_selector = selector
        self.m_msg_id = 0
        self.m_sock = None
        self.m_sock_reader = None

    def _is_response(self, rx_json):
        try:
            if self.m_msg_id == YI_CMD_REC_STOP:
                # FIXME: workaround for testing: move modifying business logic somewhere else
                if rx_json["type"] == "video_record_complete":
                    rx_json["msg_id"] = YI_CMD_REC_STOP
                    rx_json["rval"] = 0
                return rx_json["type"] == "video_record_complete"
            else:
                return self.m_msg_id != 0 and self.m_msg_id == rx_json['msg_id']
        except Exception:
            return False

    def connect(self):
        self.m_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.m_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.m_sock.settimeout(TCP_TIMEOUT)
        self.m_sock.connect((self.m_address, self.m_port))
        self.m_sock_reader = SockReader(self.m_sock)

        if self.m_selector:
            self.m_selector.register(self.m_sock, selectors.EVENT_READ, self.read_chunk)

    def connected(self):
        return self.m_sock is not None

    def send(self, data):
        return self.m_sock.send(data)

    def read_chunk(self):
        with self.m_sock_reader as jsons:
            for rx_json in jsons:
                print("II:", rx_json)

    def wait_response(self, msg_id):
        self.m_msg_id = msg_id
        response = None

        while True:
            with self.m_sock_reader as jsons:
                for rx_json in jsons:
                    if self._is_response(rx_json):
                        response = rx_json
                        self.m_msg_id = 0
                    else:
                        print("II:", rx_json)

            if response:
                return response
