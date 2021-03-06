#!/usr/bin/env bash

#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# environment
export AIRFLOW_HOME=${AIRFLOW_HOME:=~/airflow}
export AIRFLOW_CONFIG=$AIRFLOW_HOME/unittests.cfg

# configuration test
export AIRFLOW__TESTSECTION__TESTKEY=testvalue

# use Airflow 2.0-style imports
export AIRFLOW_USE_NEW_IMPORTS=1

# any argument received is overriding the default nose execution arguments:

nose_args=$@
if [ -z "$nose_args" ]; then
  nose_args="--with-coverage \
--cover-erase \
--cover-html \
--cover-package=airflow \
--cover-html-dir=airflow/www/static/coverage \
-s \
-v \
--logging-level=DEBUG "
fi

#--with-doctest

# Generate the `airflow` executable if needed
which airflow > /dev/null || python setup.py develop

echo "Initializing the DB"
yes | airflow resetdb
airflow initdb

echo "Starting the unit tests with the following nose arguments: "$nose_args
nosetests $nose_args

# To run individual tests:
# nosetests tests.core:CoreTest.test_scheduler_job
