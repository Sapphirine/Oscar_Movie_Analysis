#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Modified by Xi Chen, Yuxuan Liu, Zhiyuan Guo and Yunge Ma, Electrical Engineering, Columbia University, for the terms of finishing Big Data Analytics course final project.

#
# Get dataset from local file -- movies-out and prepares it for clustering
#
# To run:  change into the mahout directory and type:
#  examples/bin/cluster-movies.sh

if [ "$1" = "--help" ] || [ "$1" = "--?" ]; then
  echo "This script clusters the movies data set using a variety of algorithms.  The data set is downloaded automatically."
  exit
fi

SCRIPT_PATH=${0%/*}
if [ "$0" != "$SCRIPT_PATH" ] && [ "$SCRIPT_PATH" != "" ]; then 
  cd $SCRIPT_PATH
fi

MAHOUT="../../bin/mahout"

if [ ! -e $MAHOUT ]; then
  echo "Can't find mahout driver in $MAHOUT, cwd `pwd`, exiting.."
  exit 1
fi

algorithm=( kmeans fuzzykmeans lda streamingkmeans)
if [ -n "$1" ]; then
  choice=$1
else
  echo "Please select a number to choose the corresponding clustering algorithm"
  echo "1. ${algorithm[0]} clustering"
  echo "2. ${algorithm[1]} clustering"
  echo "3. ${algorithm[2]} clustering"
  echo "4. ${algorithm[3]} clustering"
  read -p "Enter your choice : " choice
fi

echo "ok. You chose $choice and we'll use ${algorithm[$choice-1]} Clustering"
clustertype=${algorithm[$choice-1]} 

WORK_DIR=/usr/local/Cellar/mahout-work-xichen
echo "creating work directory at ${WORK_DIR}"

if [ "$HADOOP_HOME" != "" ] && [ "$MAHOUT_LOCAL" == "" ] ; then
  HADOOP="$HADOOP_HOME/bin/hadoop"
  if [ ! -e $HADOOP ]; then
    echo "Can't find hadoop in $HADOOP, exiting"
    exit 1
  fi
fi


    if [ "$HADOOP_HOME" != "" ] && [ "$MAHOUT_LOCAL" == "" ] ; then
        echo "Copying movies data to Hadoop"
        set +e
       $HADOOP dfs -rmr ${WORK_DIR}/movies-out
       set -e
       $HADOOP dfs -put ${WORK_DIR}/movies-out ${WORK_DIR}/movies-out
   fi

 echo "Converting to Sequence Files from Directory"
 $MAHOUT seqdirectory -i ${WORK_DIR}/movies-out -o ${WORK_DIR}/movies-out-seqdir -c UTF-8 -chunk 64 -xm sequential
 

if [ "x$clustertype" == "xkmeans" ]; then
  $MAHOUT seq2sparse \
    -i ${WORK_DIR}/movies-out-seqdir/ \
    -o ${WORK_DIR}/movies-out-seqdir-sparse-kmeans --maxDFPercent 85 --namedVector \
  && \
  $MAHOUT kmeans \
    -i ${WORK_DIR}/movies-out-seqdir-sparse-kmeans/tfidf-vectors/ \
    -c ${WORK_DIR}/movies-kmeans-clusters \
    -o ${WORK_DIR}/movies-kmeans \
    -dm org.apache.mahout.common.distance.CosineDistanceMeasure \
    -x 10 -k 20 -ow --clustering \
  && \
  $MAHOUT clusterdump \
    -i ${WORK_DIR}/movies-kmeans/clusters-*-final \
    -o ${WORK_DIR}/movies-kmeans/clusterdump \
    -d ${WORK_DIR}/movies-out-seqdir-sparse-kmeans/dictionary.file-0 \
    -dt sequencefile -b 100 -n 20 --evaluate -dm org.apache.mahout.common.distance.CosineDistanceMeasure -sp 0 \
    --pointsDir ${WORK_DIR}/movies-kmeans/clusteredPoints \
    && \
  cat ${WORK_DIR}/movies-kmeans/clusterdump
elif [ "x$clustertype" == "xfuzzykmeans" ]; then
  $MAHOUT seq2sparse \
    -i ${WORK_DIR}/movies-out-seqdir/ \
    -o ${WORK_DIR}/movies-out-seqdir-sparse-fkmeans --maxDFPercent 85 --namedVector \
  && \
  $MAHOUT fkmeans \
    -i ${WORK_DIR}/movies-out-seqdir-sparse-fkmeans/tfidf-vectors/ \
    -c ${WORK_DIR}/movies-fkmeans-clusters \
    -o ${WORK_DIR}/movies-fkmeans \
    -dm org.apache.mahout.common.distance.CosineDistanceMeasure \
    -x 10 -k 20 -ow -m 1.1 \
  && \
  $MAHOUT clusterdump \
    -i ${WORK_DIR}/movies-fkmeans/clusters-*-final \
    -o ${WORK_DIR}/movies-fkmeans/clusterdump \
    -d ${WORK_DIR}/movies-out-seqdir-sparse-fkmeans/dictionary.file-0 \
    -dt sequencefile -b 100 -n 20 -sp 0 \
    && \
  cat ${WORK_DIR}/movies-fkmeans/clusterdump
elif [ "x$clustertype" == "xlda" ]; then
  $MAHOUT seq2sparse \
    -i ${WORK_DIR}/movies-out-seqdir/ \
    -o ${WORK_DIR}/movies-out-seqdir-sparse-lda -ow --maxDFPercent 85 --namedVector \
  && \
  $MAHOUT rowid \
    -i ${WORK_DIR}/movies-out-seqdir-sparse-lda/tfidf-vectors \
    -o ${WORK_DIR}/movies-out-matrix \
  && \
  rm -rf ${WORK_DIR}/movies-lda ${WORK_DIR}/movies-lda-topics ${WORK_DIR}/movies-lda-model \
  && \
  $MAHOUT cvb \
    -i ${WORK_DIR}/movies-out-matrix/matrix \
    -o ${WORK_DIR}/movies-lda -k 20 -ow -x 20 \
    -dict ${WORK_DIR}/movies-out-seqdir-sparse-lda/dictionary.file-* \
    -dt ${WORK_DIR}/movies-lda-topics \
    -mt ${WORK_DIR}/movies-lda-model \
  && \
  $MAHOUT vectordump \
    -i ${WORK_DIR}/movies-lda-topics/part-m-00000 \
    -o ${WORK_DIR}/movies-lda/vectordump \
    -vs 10 -p true \
    -d ${WORK_DIR}/movies-out-seqdir-sparse-lda/dictionary.file-* \
    -dt sequencefile -sort ${WORK_DIR}/movies-lda-topics/part-m-00000 \
    && \
  cat ${WORK_DIR}/movies-lda/vectordump
elif [ "x$clustertype" == "xstreamingkmeans" ]; then
  $MAHOUT seq2sparse \
    -i ${WORK_DIR}/movies-out-seqdir/ \
    -o ${WORK_DIR}/movies-out-seqdir-sparse-streamingkmeans -ow --maxDFPercent 85 --namedVector \
  && \
  rm -rf ${WORK_DIR}/movies-streamingkmeans \
  && \
  $MAHOUT streamingkmeans \
    -i ${WORK_DIR}/movies-out-seqdir-sparse-streamingkmeans/tfidf-vectors/ \
    --tempDir ${WORK_DIR}/tmp \
    -o ${WORK_DIR}/movies-streamingkmeans \
    -sc org.apache.mahout.math.neighborhood.FastProjectionSearch \
    -dm org.apache.mahout.common.distance.SquaredEuclideanDistanceMeasure \
    -k 10 -km 100 -ow \
  && \
  $MAHOUT qualcluster \
    -i ${WORK_DIR}/movies-out-seqdir-sparse-streamingkmeans/tfidf-vectors/part-r-00000 \
    -c ${WORK_DIR}/movies-streamingkmeans/part-r-00000   \
    -o ${WORK_DIR}/movies-cluster-distance.csv \
    && \
  cat ${WORK_DIR}/movies-cluster-distance.csv
else 
  echo "unknown cluster type: $clustertype"
fi 
