#!/bin/sh

if [ "$3" = "grep" ];
then
    for i in $(aws lambda list-functions --query 'Functions[].FunctionName' | grep $4 | sed 's/\,//g; s/\"//g')
    do
        datadog-ci lambda instrument -f $i -r us-east-1 -v $1 -e $2
    done
else
    for i in $(aws lambda list-functions --query 'Functions[].FunctionName' --output text)
    do
        datadog-ci lambda instrument -f $i -r us-east-1 -v $1 -e $2
    done
fi

