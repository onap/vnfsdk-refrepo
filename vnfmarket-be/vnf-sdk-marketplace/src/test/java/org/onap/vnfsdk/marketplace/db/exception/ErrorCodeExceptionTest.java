/**
 * Copyright 2017 Huawei Technologies Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.onap.vnfsdk.marketplace.db.exception;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class ErrorCodeExceptionTest {
    ErrorCodeException e1;

    @Before
    public void setUp() {
        e1 = new ErrorCodeException(null, 0, 0, null, null);
    }

    @Test
    public void testConstructor() {

        ErrorCodeException e2 = new ErrorCodeException(0, null);
        assertNotNull(e2);

    }

    @Test
    public void testGet() {
        assertEquals(0, e1.getErrorCode());
    }
}