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
package org.onap.vnfsdk.marketplace.filemanage.http;

import java.io.File;
import java.io.IOException;
import java.util.Objects;

import org.apache.commons.lang3.StringUtils;
import org.onap.vnfsdk.marketplace.filemanage.FileManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class HttpFileManagerImpl implements FileManager {
  private static final Logger LOGGER = LoggerFactory.getLogger(HttpFileManagerImpl.class);

  @Override
  public boolean upload(String srcPath, String dstPath) {
    boolean flag = true;
    if (LOGGER.isInfoEnabled()) {
      LOGGER.info("start upload file.srcPath:{} dstPath{}" , loggerPatternBreaking(srcPath) , loggerPatternBreaking(dstPath));
    }
    File srcFile = new File(srcPath);
    if (!srcFile.exists()) {
      LOGGER.error("src file not exist!");
      return false;
    }

    String targetDir = ToolUtil.getHttpServerAbsolutePath() + dstPath;
    try {
      ToolUtil.copyDirectory(srcPath, targetDir, true);
    } catch (IOException e1) {
      flag = false;
      LOGGER.error("ErrorMsg: failed to copy file:", e1);
    }
    LOGGER.info("upload file success!");
    return flag;
  }

  @Override
  public boolean download(String srcPath, String dstPath) {
    // TODO Auto-generated method stub
    return false;
  }

  @Override
  public boolean delete(String srcPath) {
    if (LOGGER.isInfoEnabled()) {
      LOGGER.info("start delete file from http server.srcPath:{}" , loggerPatternBreaking(srcPath));
    }
    boolean flag = ToolUtil.deleteDir(new File(ToolUtil.getHttpServerAbsolutePath() + srcPath));
    LOGGER.info("delete file from http server end.flag:{}" , flag);
    return flag;
  }
  private String loggerPatternBreaking(String loggerInput) {
    return Objects.nonNull(loggerInput) ? loggerInput.replaceAll("[\n\r\t]", "_") : StringUtils.EMPTY;

  }

}
