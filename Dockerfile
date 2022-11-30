FROM ubuntu

#install dependencies
RUN apt update && apt install curl -y && apt install npm -y && apt install zip -y
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN npm install -g @datadog/datadog-ci

#'aws configure' equivalent
RUN mkdir /root/.aws
COPY config credentials /root/.aws/
RUN chmod 777 /root/.aws/config /root/.aws/credentials

COPY instrument-lambda-apm.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/instrument-lambda-apm.sh

#Datadog setup
ENV DATADOG_SITE="datadoghq.com" DATADOG_API_KEY="<INSERT-DD-APIKEY>" AWS_PAGER=  
#last var remains empty to compensate for no 'less' pkg installed

WORKDIR /usr/local/bin/
ENTRYPOINT ["./instrument-lambda-apm.sh"]

