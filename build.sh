 #!/bin/bash

 # INTEL CONFIDENTIAL
 # Copyright (2019) Intel Corporation.
 #
 # The source code contained or described herein and all documents related to the source code ("Material")
 # are owned by Intel Corporation or its suppliers or licensors. Title to the Material remains with
 # Intel Corporation or its suppliers and licensors. The Material may contain trade secrets and proprietary
 # and confidential information of Intel Corporation and its suppliers and licensors, and is protected by
 # worldwide copyright and trade secret laws and treaty provisions. No part of the Material may be used,
 # copied, reproduced, modified, published, uploaded, posted, transmitted, distributed, or disclosed in
 # any way without Intel/'s prior express written permission.
 # No license under any patent, copyright, trade secret or other intellectual property right is granted
 # to or conferred upon you by disclosure or delivery of the Materials, either expressly, by implication,
 # inducement, estoppel or otherwise. Any license under such intellectual property rights must be express
 # and approved by Intel in writing.
 # Unless otherwise agreed by Intel in writing, you may not remove or alter this notice or any other
 # notice embedded in Materials by Intel or Intel's suppliers or licensors in any way.

echo
echo "Installing the following dependencies..."
echo "    1. make"
echo "    2. curl"
echo
sudo apt update
sudo apt -y install build-essential curl

echo
echo "Checking docker and Intel RSP..."
echo
{
  sudo docker ps -q > /dev/null
} || {
  echo "Docker is not running. Please make sure Docker is installed."  
  exit 1
}
echo "Docker...OK"
echo
if curl --output /dev/null --silent --head --fail "http://127.0.0.1:8080/web-admin"
then
    echo "Intel RSP Controller...OK"
else
    echo "Intel RSP is not running. Please follow instructions to install and run RSP controller."
    exit 1
fi
echo
echo "Building and Deploying Intel Inventory Suite and EdgeX..."
echo

if sudo -E make build 
then   
  if sudo make deploy 
  then     
    echo    
    echo
    echo "Applying index to EdgeX's reading collection..."
    sleep 5    
    RETRY=5
    i=0
    while [ $i -lt $RETRY ]; do        
        sudo docker exec -it $(sudo docker ps | awk '{print $NF}' | grep -w Inventory-Suite-Dev_mongo.1) mongo localhost/coredata --eval "db.reading.createIndex({uuid:1})" && echo $?
        [[ $? -eq 0 ]] && break
        echo "Retries...${i}"        
        sleep 5
        i=$((i + 1))
    done
    if [[ $RETRY -eq i ]]
    then
      echo "Not able to apply index to EdgeX Mongo. Exiting..."
    else
     echo "EdgeX and Inventory Suite successfully deployed!"
     exit 0
    fi    
  fi
  exit 1
fi
exit 1

