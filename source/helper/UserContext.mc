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
using Toybox.Lang;
using Toybox.StringUtil;
using Toybox.System;

class UserContext {

    var id;  // string
    var senderName;
    var payload;

    function initialize(senderName, payload) {
        self.id = generateHeader();
        self.senderName = senderName;
        self.payload = payload;
    }

    private static function generateHeader() {  // hex-encoded string of uint32
        var timestamp = System.getTimer();
        var ba = new [4]b;
        ba = ba.encodeNumber(timestamp, Lang.NUMBER_FORMAT_UINT32, { :endianness => Lang.ENDIAN_BIG });
        return StringUtil.convertEncodedString(ba, {
            :fromRepresentation => StringUtil.REPRESENTATION_BYTE_ARRAY,
            :toRepresentation => StringUtil.REPRESENTATION_STRING_HEX
        });
    }

}


class UserContextStorage {

    private var mContexts = {};

    function saveContext(cntx) {
        self.mContexts.put(cntx.id, cntx);
    }

    function popContext(id) {
        var c = self.mContexts.get(id);
        if (c != null) {
            self.mContexts.remove(id);
        }
        return c;
    }

}
