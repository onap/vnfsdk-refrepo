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
package org.onap.vnfsdk.marketplace.common;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.onap.vnfsdk.marketplace.db.entity.PackageData;

public class JsonUtil {
    private static Gson gson = getGsonInstance();

    public static Gson getGsonInstance() {
        return new GsonBuilder().serializeNulls().create();
    }

    public static String convertObjectToJsonString(Object obj) {
        return gson.toJson(obj);
    }

    public static <T>Object  convertJsonStringToClassType(String jsonValue, Class<T> clazz) {
        return gson.fromJson(jsonValue,clazz);
    }
}
