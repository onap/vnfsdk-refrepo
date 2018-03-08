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

public class ErrorCodeException extends Exception {

	private static final long serialVersionUID = 3220072444842529499L;
	private final int errorCode;	

	public ErrorCodeException(Throwable source, int category, int code, String debugMessage, String[] arguments) {
		super(debugMessage, source);
		this.errorCode = code;
	}

	public int getErrorCode() {
		return errorCode;
	}

}
