#!/bin/bash

#*******************************************************************************
# Copyright 2019 Huawei Technologies Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#*******************************************************************************
# VTP Installation script supported on Ubuntu 16.04 64 bit
#
#./vtp_install.sh --download      : It will download all required artifacts into /opt/vtp_stage
#./vtp_install.sh --install       : It will install VTP (/opt/controller) and CLI (/opt/oclip)
#./vtp_install.sh --start         : It will start VTP controller as tomcat service and CLI as oclip service
#./vtp_install.sh --verify        : It will verify the setup is done properly by running some test cases.
#./vtp_install.sh --uninstall     : It will stop and uninstall the VTP
#./vtp_install.sh --clean         : It will remove the downloaded artifacts

#Customize the download URL as below
#export OCLIP_DOWNLOAD_URL="https://nexus.onap.org/content/repositories/snapshots/org/onap/cli/cli-zip/4.0.0-SNAPSHOT/cli-zip-4.0.0-20190904.095516-170.zip"
#export VTP_DOWNLOAD_URL="https://nexus.onap.org/content/repositories/snapshots/org/onap/vnfsdk/refrepo/vnf-sdk-marketplace/1.3.3-SNAPSHOT/vnf-sdk-marketplace-1.3.3-20190903.092849-18.war"
#export CSAR_VALIDATE_DOWNLOAD_URL="https://nexus.onap.org/content/repositories/snapshots/org/onap/vnfsdk/validation/csarvalidation-deployment/1.2.2-SNAPSHOT/csarvalidation-deployment-1.2.2-20190904.082836-6.zip"
#export CSAR_VALIDATE_JAR_DOWNLOAD_URL="https://nexus.onap.org/content/repositories/snapshots/org/onap/vnfsdk/validation/validation-csar/1.2.2-SNAPSHOT/validation-csar-1.2.2-20190904.082829-6.jar"

if [ -z "$OCLIP_DOWNLOAD_URL" ]
then
    export OCLIP_DOWNLOAD_URL="https://nexus.onap.org/service/local/artifact/maven/redirect?r=releases&g=org.onap.cli&a=cli-zip&e=zip&v=LATEST"
fi

if [ -z "$VTP_DOWNLOAD_URL" ]
then
    export VTP_DOWNLOAD_URL="https://nexus.onap.org/service/local/artifact/maven/redirect?r=releases&g=org.onap.vnfsdk.refrepo&a=vnf-sdk-marketplace&e=war&v=LATEST"
fi

if [ -z "$CSAR_VALIDATE_DOWNLOAD_URL" ]
then
    export CSAR_VALIDATE_DOWNLOAD_URL="https://nexus.onap.org/service/local/artifact/maven/redirect?r=releases&g=org.onap.vnfsdk.validation&a=csarvalidation-deployment&e=zip&v=LATEST"
fi

if [ -z "$CSAR_VALIDATE_JAR_DOWNLOAD_URL" ]
then
    export CSAR_VALIDATE_JAR_DOWNLOAD_URL="https://nexus.onap.org/service/local/artifact/maven/redirect?r=releases&g=org.onap.vnfsdk.validation&a=validation-csar&e=jar&v=LATEST"
fi

export TOMCAT8_DOWNLOAD_URL="https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.tar.gz"
export SAMPLE_VTP_CSAR="https://github.com/onap/vnfsdk-validation/raw/master/csarvalidation/src/test/resources/VoLTE.csar"
#export VVP_GITHUB="https://github.com/onap/vvp-validation-scripts"
#export SAMPLE_VTP_HOT="https://git.openstack.org/cgit/openstack/heat-templates/plain/hot/hello_world.yaml"

export VTP_STAGE_DIR=/opt/vtp_stage
export OPEN_CLI_HOME=/opt/oclip
export PATH=$OPEN_CLI_HOME/bin:$PATH
export CATALINA_HOME=/opt/controller
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
#export ONAP_VVP_HOME=$VTP_STAGE_DIR/vvp-validation-scripts/ice_validator
export VTP_TRACK_MARK=+++++++++++++++++++++++++++++++++++

#init.d or systemd
if [ -z "$SERVICE_MODE" ]
then
    export SERVICE_MODE=systemd
fi

function vtp_download() {
    echo $VTP_TRACK_MARK Downloading VTP binaries and setup the dependencies ...

    apt-get install -y tar wget unzip git python2.7 #python3 python3-pip
    #pip3 install --upgrade pip

    mkdir -p $VTP_STAGE_DIR

    if [ ! -f $VTP_STAGE_DIR/CLI.zip ]
    then
        wget -O $VTP_STAGE_DIR/CLI.zip $OCLIP_DOWNLOAD_URL
    else
        echo $VTP_TRACK_MARK $OCLIP_DOWNLOAD_URL already downloded
    fi

    if [ ! -f $VTP_STAGE_DIR/CSAR-VALIDATE.zip ]
    then
        wget -O $VTP_STAGE_DIR/CSAR-VALIDATE.zip $CSAR_VALIDATE_DOWNLOAD_URL
        wget -O $VTP_STAGE_DIR/CSAR.csar $SAMPLE_VTP_CSAR
        wget -O $VTP_STAGE_DIR/csar-validate.jar $CSAR_VALIDATE_JAR_DOWNLOAD_URL
    else
        echo $VTP_TRACK_MARK $CSAR_VALIDATE_DOWNLOAD_URL already downloded
    fi

    if [ ! -f $VTP_STAGE_DIR/TOMCAT.tar.gz ]
    then
        wget -O $VTP_STAGE_DIR/TOMCAT.tar.gz $TOMCAT8_DOWNLOAD_URL
    else
        echo $VTP_TRACK_MARK $TOMCAT8_DOWNLOAD_URL already downloded
    fi

    if [ ! -f $VTP_STAGE_DIR/VTP.zip ]
    then
        wget -O $VTP_STAGE_DIR/VTP.zip $VTP_DOWNLOAD_URL
    else
        echo $VTP_TRACK_MARK $VTP_DOWNLOAD_URL already downloded
    fi

#    if [ ! -d $VTP_STAGE_DIR/vvp-validation-scripts ]
#    then
#        git clone $VVP_GITHUB $VTP_STAGE_DIR/vvp-validation-scripts
#        git checkout casablanca
#        mkdir -p $VTP_STAGE_DIR/HOT
#        wget -O $VTP_STAGE_DIR/HOT/HOT.yaml $SAMPLE_VTP_HOT
#    else
#        echo $VTP_TRACK_MARK $VTP_DOWNLOAD_URL already cloned
#    fi

    if [ ! -d $JAVA_HOME ]
    then
        apt-get install -y openjdk-11-jre
    else
        echo $VTP_TRACK_MARK JAVA already installed
    fi
}

function vtp_backend_install() {
    if [ ! -f $OPEN_CLI_HOME/bin/oclip.sh ]
    then
        echo $VTP_TRACK_MARK Installing VTP Backend...

        mkdir -p $OPEN_CLI_HOME
        unzip $VTP_STAGE_DIR/CLI.zip -d $OPEN_CLI_HOME
        ln -s $OPEN_CLI_HOME/bin/oclip.sh /usr/bin/oclip

        echo $VTP_TRACK_MARK Configuring VTP Backend...

        if [[ $SERVICE_MODE == 'systemd' ]]
        then
            cp $OPEN_CLI_HOME/conf/oclip.service /etc/systemd/system
            systemctl daemon-reload
            systemctl status oclip | cat
        else
            echo export OPEN_CLI_HOME=$OPEN_CLI_HOME > $OPEN_CLI_HOME/bin/oclip-grpc-service.sh
            echo  $OPEN_CLI_HOME/bin/oclip-grpc-server.sh>> $OPEN_CLI_HOME/bin/oclip-grpc-service.sh
            chmod +x $OPEN_CLI_HOME/bin/oclip-grpc-service.sh
            cp $OPEN_CLI_HOME/conf/oclip-service.sh /etc/init.d/oclip-grpc && update-rc.d oclip-grpc defaults
        fi

    else
        echo "VTP Backend already installed"
    fi
}

function vtp_csar_validation_install() {
    if [ ! -f $OPEN_CLI_HOME/lib/csar-validate.jar ]
    then
        echo "$VTP_TRACK_MARK Installing CSAR Validation Test cases (TOSCA & HEAT)"
        mkdir -p $VTP_STAGE_DIR/CSAR-VALIDATE
        unzip $VTP_STAGE_DIR/CSAR-VALIDATE.zip -d $VTP_STAGE_DIR/CSAR-VALIDATE
        cp $VTP_STAGE_DIR/csar-validate.jar $OPEN_CLI_HOME/lib
        cp $VTP_STAGE_DIR/CSAR-VALIDATE/commons-lang3*.jar $OPEN_CLI_HOME/lib
        cp $VTP_STAGE_DIR/CSAR-VALIDATE/bcpkix-jdk15on-1.61.jar $OPEN_CLI_HOME/lib
        cp $VTP_STAGE_DIR/CSAR-VALIDATE/bcprov-jdk15on-1.61.jar $OPEN_CLI_HOME/lib
        cp $VTP_STAGE_DIR/CSAR-VALIDATE/gson-*.jar $VTP_INSTALL_DIR/lib/
        cp $VTP_STAGE_DIR/CSAR-VALIDATE/snakeyaml-*.jar $OPEN_CLI_HOME/lib
        cp $VTP_STAGE_DIR/CSAR-VALIDATE/validation-csar*.jar $OPEN_CLI_HOME/lib
        cp $VTP_STAGE_DIR/CSAR-VALIDATE/validation-pmdictionary*.jar $OPEN_CLI_HOME/lib
    else
        echo "CSAR Validation Test cases (TOSCA & HEAT) already installed"
    fi
}

function vtp_controller_install() {
    if [ ! -d $CATALINA_HOME ]
    then
        echo $VTP_TRACK_MARK Installing Tomcat 8.5.3 ...
        mkdir -p $CATALINA_HOME
        tar --strip-components=1 -xf $VTP_STAGE_DIR/TOMCAT.tar.gz -C $CATALINA_HOME
        rm -rf $CATALINA_HOME/webapps
        mkdir -p $CATALINA_HOME/webapps/ROOT

        unzip $VTP_STAGE_DIR/VTP.zip -d $CATALINA_HOME/webapps/ROOT
        echo 'export CATALINA_OPTS="$CATALINA_OPTS -Xms64m -Xmx256m -XX:MaxPermSize=64m"' > $CATALINA_HOME/bin/setenv.sh
        echo 'export JAVA_OPTS="$JAVA_OPTS -Djava.security.egd=file:/dev/./urandom"' >> $CATALINA_HOME/bin/setenv.sh
    else
        echo "VTP Controller already installed"
    fi
}

function vtp_start() {
    echo $VTP_TRACK_MARK Starting VTP Backend...
    if [[ $SERVICE_MODE == 'systemd' ]]
    then
        systemctl start oclip
        systemctl status oclip | cat
    else
        service oclip-grpc start
    fi

    echo $VTP_TRACK_MARK Starting VTP Controller...
    $CATALINA_HOME/bin/startup.sh
}

function vtp_stop() {
    echo $VTP_TRACK_MARK Stoping VTP Backend...
    if [[ $SERVICE_MODE == 'systemd' ]]
    then
       systemctl stop oclip | cat
       systemctl status oclip | cat
    else
        service oclip-grpc stop
    fi

    for pid in `ps -aef | grep java | awk '{print $2}'`; do  kill -9 $pid; done

    echo $VTP_TRACK_MARK Stoping VTP Controller...
    $CATALINA_HOME/bin/shutdown.sh
}

function vtp_purge() {
    #Stop services
    vtp_stop

    #Stop tracking
    jobs -p | xargs kill -9

    echo $VTP_TRACK_MARK Purging VTP...
    rm -rf $OPEN_CLI_HOME
    rm -rf $CATALINA_HOME
    rm -rf $VTP_STAGE_DIR/CSAR-VALIDATE

    rm -f /etc/systemd/system/oclip.service
    systemctl daemon-reload | cat
    rm -f /etc/init.d/oclip-grpc

    #vtp_vvp_uninstall
}

function vtp_trace() {
    tailf $CATALINA_HOME/logs/catalina.out &
    tailf $OPEN_CLI_HOME/logs/open-cli.log &
}

function vtp_vvp_install() {
    echo $VTP_TRACK_MARK Installing VVP scripts
    _CWD=`pwd`
    cd $VTP_STAGE_DIR/vvp-validation-scripts
    pip install -r requirements.txt
    cd $_CWD
}

function vtp_vvp_uninstall() {
    echo $VTP_TRACK_MARK Uninstalling VVP scripts
    _CWD=`pwd`
    cd $VTP_STAGE_DIR/vvp-validation-scripts
    pip uninstall -y -r requirements.txt
    cd $_CWD
}

function vtp_sample_scenario_install() {
    echo $VTP_TRACK_MARK Installing sample scenarios...
    mkdir -p $OPEN_CLI_HOME/open-cli-schema/sample-scenarios
    cp -r $CATALINA_HOME/webapps/ROOT/WEB-INF/classes/sample-vtp-scenarios/open-cli-schema/ $OPEN_CLI_HOME/open-cli-schema/sample-scenarios
}

function vtp_test() {
    echo $VTP_TRACK_MARK Check the CSAR validation
    oclip --product onap-dublin csar-validate --csar $VTP_STAGE_DIR/CSAR.csar
    oclip --product onap-dublin vnf-tosca-provision --help
    oclip --product onap-dublin --request-id test vnf-tosca-provision --mode checkup --vsp $VTP_STAGE_DIR/CSAR.csar --vnf-csar $VTP_STAGE_DIR/CSAR.csar --ns-csar $VTP_STAGE_DIR/CSAR.csar --vnfm-driver hwvnfmdriver --vnf-name test --vnf-vendor-name test

    #echo $VTP_TRACK_MARK Check the HOT validation
    #oclip --product onap-vtp hot-validate --hot-folder $VTP_STAGE_DIR/HOT --format json

    echo $VTP_TRACK_MARK Check the VTP Controller
    curl -X GET http://localhost:8080/onapapi/vnfsdk-marketplace/v1/vtp/scenarios
    curl -X GET http://localhost:8080/onapapi/vnfsdk-marketplace/v1/vtp/scenarios/onap-dublin/testsuites
    echo ..... Happy VTPing ......
}

function vtp_install() {
    vtp_download
    vtp_backend_install
    vtp_controller_install
    vtp_csar_validation_install
    #vtp_vvp_install
    vtp_sample_scenario_install
}

function vtp_setup() {
    vtp_install
    vtp_start
    vtp_test
}

if [[ $1 == '--install' ]]
then
    vtp_install
elif [[ $1 == '--download' ]]
then
    vtp_download
elif [[ $1 == '--setup' ]]
then
    vtp_setup
elif [[ $1 == '--uninstall' ]]
then
    vtp_purge
elif [[ $1 == '--stop' ]]
then
    vtp_stop
elif [[ $1 == '--start' ]]
then
    vtp_start
elif [[ $1 == '--clean' ]]
then
    rm -rf $VTP_STAGE_DIR
elif [[ $1 == '--verify' ]]
then
    vtp_test
else
    echo "$0 [ --install | --uninstall | --start | --stop | --verify | --download | --clean]"
    echo "--download      : It will download all required artifacts into /opt/vtp_stage"
    echo "--install       : It will install VTP (/opt/controller) and CLI (/opt/oclip)"
    echo "--start         : It will start VTP controller as tomcat service and CLI as oclip service"
    echo "--verify        : It will verify the setup is done properly by running some test cases"
    echo "--uninstall     : It will stop and uninstall the VTP"
    echo "--clean         : It will remove the downloaded artifacts"
    echo
    echo "Customize the download URL as below from latest snapshot or release onap repository"
    echo "export OCLIP_DOWNLOAD_URL=\"https://nexus.onap.org/content/repositories/snapshots/org/onap/cli/cli-zip/4.0.0-SNAPSHOT/cli-zip-4.0.0-20190904.095516-170.zip\""
    echo "export VTP_DOWNLOAD_URL=\"https://nexus.onap.org/content/repositories/snapshots/org/onap/vnfsdk/refrepo/vnf-sdk-marketplace/1.3.3-SNAPSHOT/vnf-sdk-marketplace-1.3.3-20190903.092849-18.war\""
    echo "export CSAR_VALIDATE_DOWNLOAD_URL=\"https://nexus.onap.org/content/repositories/snapshots/org/onap/vnfsdk/validation/csarvalidation-deployment/1.2.2-SNAPSHOT/csarvalidation-deployment-1.2.2-20190904.082836-6.zip\""
    echo "export CSAR_VALIDATE_JAR_DOWNLOAD_URL=\"https://nexus.onap.org/content/repositories/snapshots/org/onap/vnfsdk/validation/validation-csar/1.2.2-SNAPSHOT/validation-csar-1.2.2-20190904.082829-6.jar\""
fi
