/**
 * Copyright 2019 Huawei Technologies Co., Ltd.
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
package org.onap.vtp.execution;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import mockit.MockUp;
import org.glassfish.jersey.media.multipart.ContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataBodyPart;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.onap.vtp.VTPResource;
import org.onap.vtp.error.VTPError;
import org.onap.vtp.execution.model.VTPTestExecution;
import org.open.infc.grpc.Output;

import java.io.IOException;
import java.util.*;

import static org.junit.Assert.*;
@RunWith(MockitoJUnitRunner.class)
public class VTPExecutionResourceTest {

    @Mock
    FormDataBodyPart formDataBodyPart;
    @Mock
    ContentDisposition contentDisposition;
    String requestId;
    VTPExecutionResource vtpExecutionResource;
    @Before
    public void setUp() throws Exception {
        vtpExecutionResource= new VTPExecutionResource();
        requestId = UUID.randomUUID().toString();
    }
    @Test(expected = Exception.class)
    public void testExecuteHandler() throws Exception
    {
        VTPTestExecution.VTPTestExecutionList executions= new VTPTestExecution.VTPTestExecutionList();
        List<VTPTestExecution> list= new ArrayList<>();
        JsonParser jsonParser = new JsonParser();
        String jsonString = "{\"name\":\"Mahesh Kumar\", \"age\":\"nine\",\"verified\":\"false\"}";
        JsonElement rootNode = jsonParser.parse(jsonString);

        VTPTestExecution vtp=new VTPTestExecution();
        vtp.setEndTime("2019-03-12T11:49:52.845");
        vtp.setProfile("abc");
        vtp.setStatus("pass");
        vtp.setRequestId(requestId);
        vtp.setExecutionId("executionid");
        vtp.setParameters(rootNode);
        vtp.setResults(rootNode);
        vtp.setScenario("open-cli");
        vtp.setStartTime("2019-04-12T11:49:52.845");
        vtp.setTestCaseName("testcase");
        vtp.setTestSuiteName("testsuite");
        list.add(vtp);
        executions.setExecutions(list);
        //System.out.println(executions.getExecutions());
        assertNotNull(executions.getExecutions());
       vtpExecutionResource.executeHandler(executions,null);
       // vtpExecutionResource.executeHandler(executions,requestId);

    }
    @Test
    public void testExecuteHandlerForGsonCoverage() throws Exception
    {
        new MockUp<VTPResource>(){

            @mockit.Mock
            protected Output makeRpc(String scenario, String requestId, String profile, String testCase, JsonElement argsJsonNode) throws VTPError.VTPException {
                String dummyValue = "{\"execution-id\":\"execution-id\"}";
                Gson gson = new Gson();
                return gson.fromJson(dummyValue,Output.class);
            }

        };
        new MockUp<Output>(){

            @mockit.Mock
            public Map<String, String> getAddonsMap() {
                String dummyValue = "{\"execution-id\":\"execution-id\"}";
                Gson gson = new Gson();
                return gson.fromJson(dummyValue,Map.class);
            }

        };
        new MockUp<Output>(){

            @mockit.Mock
            public Map<String, String> getAttrsMap() {
                String dummyValue = "{\"results\":[{\"execution-id\":\"execution-id\"}]}";
                Gson gson = new Gson();
                return gson.fromJson(dummyValue,Map.class);
            }

        };
        new MockUp<Output>(){

            @mockit.Mock
            public boolean getSuccess() {
                return true;
            }

        };
        VTPTestExecution.VTPTestExecutionList executions= new VTPTestExecution.VTPTestExecutionList();
        List<VTPTestExecution> list= new ArrayList<>();
        JsonParser jsonParser = new JsonParser();
        String jsonString = "{\"name\":\"Mahesh Kumar\", \"age\":\"nine\",\"verified\":\"false\"}";
        JsonElement rootNode = jsonParser.parse(jsonString);

        VTPTestExecution vtp=new VTPTestExecution();
        vtp.setEndTime("2019-03-12T11:49:52.845");
        vtp.setProfile("abc");
        vtp.setStatus("pass");
        vtp.setRequestId(requestId);
        vtp.setExecutionId("executionid");
        vtp.setParameters(rootNode);
        vtp.setResults(rootNode);
        vtp.setScenario("open-cli");
        vtp.setStartTime("2019-04-12T11:49:52.845");
        vtp.setTestCaseName("testcase");
        vtp.setTestSuiteName("testsuite");
        list.add(vtp);
        executions.setExecutions(list);
        //System.out.println(executions.getExecutions());
        assertNotNull(executions.getExecutions());
       assertNotNull(vtpExecutionResource.executeHandler(executions,null));
       // vtpExecutionResource.executeHandler(executions,requestId);

    }
    @Test
    public void testExecuteHandlerForGsonCoverageNegative() throws Exception
    {
        new MockUp<VTPResource>(){

            @mockit.Mock
            protected Output makeRpc(String scenario, String requestId, String profile, String testCase, JsonElement argsJsonNode) throws VTPError.VTPException {
                String dummyValue = "{\"execution-id\":\"execution-id\"}";
                Gson gson = new Gson();
                return gson.fromJson(dummyValue,Output.class);
            }

        };
        new MockUp<Output>(){

            @mockit.Mock
            public Map<String, String> getAddonsMap() {
                String dummyValue = "{\"execution-id\":\"execution-id\"}";
                Gson gson = new Gson();
                return gson.fromJson(dummyValue,Map.class);
            }

        };
        new MockUp<Output>(){

            @mockit.Mock
            public Map<String, String> getAttrsMap() {
                String dummyValue = "{\"error\":\"DummyError occurs\"}";
                Gson gson = new Gson();
                return gson.fromJson(dummyValue,Map.class);
            }

        };
        new MockUp<Output>(){

            @mockit.Mock
            public boolean getSuccess() {
                return false;
            }

        };
        VTPTestExecution.VTPTestExecutionList executions= new VTPTestExecution.VTPTestExecutionList();
        List<VTPTestExecution> list= new ArrayList<>();
        JsonParser jsonParser = new JsonParser();
        String jsonString = "{\"name\":\"Mahesh Kumar\", \"age\":\"nine\",\"verified\":\"false\"}";
        JsonElement rootNode = jsonParser.parse(jsonString);

        VTPTestExecution vtp=new VTPTestExecution();
        vtp.setEndTime("2019-03-12T11:49:52.845");
        vtp.setProfile("abc");
        vtp.setStatus("pass");
        vtp.setRequestId(requestId);
        vtp.setExecutionId("executionid");
        vtp.setParameters(rootNode);
        vtp.setResults(rootNode);
        vtp.setScenario("open-cli");
        vtp.setStartTime("2019-04-12T11:49:52.845");
        vtp.setTestCaseName("testcase");
        vtp.setTestSuiteName("testsuite");
        list.add(vtp);
        executions.setExecutions(list);
        //System.out.println(executions.getExecutions());
        assertNotNull(executions.getExecutions());
       assertNotNull(vtpExecutionResource.executeHandler(executions,null));
       // vtpExecutionResource.executeHandler(executions,requestId);

    }
    @Test(expected = Exception.class)
    public void testListTestExecutionsHandler() throws Exception
    {
        vtpExecutionResource.listTestExecutionsHandler(requestId,"abc","abc","abc","abc","123","123");
    }
//    @Test
//    Tested individually
    public void testListTestExecutionsHandlerForGson() throws Exception
    {
        new MockUp<VTPResource>(){

            @mockit.Mock
            protected JsonElement makeRpcAndGetJson(List<String> args, int timeout) throws VTPError.VTPException, IOException {
                String values = "[{\"start-time\":\"start-time\", \"end-time\":\"end-time\", " +
                        "\"request-id\":\"request-id\", \"product\":\"product\"," +
                        "\"service\":\"service\", \"command\":\"command\", " +
                        "\"profile\":\"profile\", \"status\":\"status\", \"execution-id\":\"execution-id\"}]";
                JsonParser jsonParser = new JsonParser();
                return jsonParser.parse(values);
            }

        };
        assertNotNull(vtpExecutionResource.listTestExecutionsHandler(requestId,"abc","abc","abc","abc","123","123"));
    }

    @Test(expected = Exception.class)
    public void testListTestExecutions() throws Exception
    {
        vtpExecutionResource.listTestExecutions(requestId,"abc","abc","abc","abc","123","123");
    }
    @Test(expected = Exception.class)
    public void testGetTestExecution() throws Exception
    {
        //assertNotNull(vtpExecutionResource.getTestExecution("abc"));
        assertNotNull(vtpExecutionResource.getTestExecution("1234"));
    }
    @Test(expected = Exception.class)
    public void testGetTestExecutionHandler() throws Exception
    {
        //assertNotNull(vtpExecutionResource.getTestExecution("abc"));
        assertNotNull(vtpExecutionResource.getTestExecutionHandler("1234"));
    }
//    @Test
//    Tested individually
    public void testGetTestExecutionHandlerForGson() throws Exception
    {
        new MockUp<VTPResource>(){

            @mockit.Mock
            protected JsonElement makeRpcAndGetJson(List<String> args, int timeout) throws VTPError.VTPException, IOException {
                String values = "{\"start-time\":\"start-time\", \"end-time\":\"end-time\", " +
                        "\"request-id\":\"request-id\", \"product\":\"product\"," +
                        "\"service\":\"service\", \"command\":\"command\", " +
                        "\"profile\":\"profile\", \"status\":\"status\", \"execution-id\":\"execution-id\"," +
                        "\"input\": \"[]\", \"output\":\"[]\"}";
                JsonParser jsonParser = new JsonParser();
                return jsonParser.parse(values);
            }

        };
        //assertNotNull(vtpExecutionResource.getTestExecution("abc"));
        assertNotNull(vtpExecutionResource.getTestExecutionHandler("1234"));
    }

    @Test(expected = NullPointerException.class)
    public void testExecuteTestcases() throws Exception
    {

        List<FormDataBodyPart> bodyParts= new ArrayList<>();
        formDataBodyPart.setName("abc");
        formDataBodyPart.setValue("123");
        formDataBodyPart.setContentDisposition(contentDisposition);
        formDataBodyPart.getContentDisposition().getFileName();
        bodyParts.add(formDataBodyPart);
      vtpExecutionResource.executeTestcases(requestId,bodyParts,"exeJson") ;
    }
}