// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/java;

# LineStream used to initialize the string stream of lines.
public class LineStream {
    private ReadableCharacterChannel readableCharacterChannel;
    private boolean isClosed = false;

    public function init(ReadableCharacterChannel readableCharacterChannel) {
        self.readableCharacterChannel = readableCharacterChannel;
    }

    public isolated function next() returns record {| string value; |}? {
        var line = readLine(self.readableCharacterChannel);
        if (line is string) {
            record {| string value; |} value = {value: <string>line.cloneReadOnly()};
            return value;
        } else {
            var closeResult = closeReader(self.readableCharacterChannel);
            return ();
        }
    }

    public isolated function close() returns Error? {
        if (!self.isClosed) {
            var closeResult = closeReader(self.readableCharacterChannel);
            if (closeResult is ()) {
                self.isClosed = true;
            }
            return closeResult;
        }
        return ();
    }
}

isolated function readLine(ReadableCharacterChannel readableCharacterChannel) returns string|Error = @java:Method {
    name: "readLine",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterChannelUtils"
} external;

isolated function closeReader(ReadableCharacterChannel readableCharacterChannel) returns Error? = @java:Method {
    name: "closeBufferedReader",
    'class: "org.ballerinalang.stdlib.io.nativeimpl.CharacterChannelUtils"
} external;
