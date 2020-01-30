FROM theiaide/theia-python:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

#USER root
#RUN npm install socket.io ws express http-proxy bagpipe chokidar request nodemailer await-signal log4js moment
RUN mkdir /home/theia/agent && \
	cd /home/theia/agent && npm init -y && npm install http-proxy basic-auth
ADD proxy.js /home/theia/agent
ENV username=land007
ENV password=fcea920f7412b5da7be0cf42b8c93759
EXPOSE 5050

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y net-tools iputils-ping vim curl wget unzip screen openssh-server git subversion locales software-properties-common lsof nmon iftop sysstat netcat-traditional pciutils kmod uuid-runtime && \
	apt-get clean && \
	npm install -g node-gyp supervisor && cd / && npm init -y && npm install socket.io ws express http-proxy bagpipe chokidar request nodemailer await-signal log4js moment && \
	chown -R theia:theia /node_modules && chown -R theia:theia /usr/local/lib/node_modules && chown -R theia:theia /home/theia/.npm && chown -R theia:theia /usr/local/bin/
ADD *.sh /
RUN sed -i 's/\r$//' /*.sh ; chmod +x /*.sh && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/theia-python" >> /.image_names && \
	echo "land007/theia-python" > /.image_name
#ENTRYPOINT [ "node", "/home/theia/agent/proxy.js" ]
ENTRYPOINT []
#CMD node /home/theia/src-gen/backend/main.js /home/project --hostname=0.0.0.0
#CMD node /home/theia/agent/proxy.js
RUN echo 'nohup node /home/theia/agent/proxy.js > /tmp/proxy.out &' >> /start.sh && \
#RUN echo 'nohup node /home/theia/src-gen/backend/main.js /home/project --hostname=0.0.0.0 --startup-timeout=-1 --inspect=0.0.0.0:9229 > /tmp/theia.out &' >> /start.sh
#	echo 'node /home/theia/src-gen/backend/main.js /home/project --hostname=0.0.0.0 --startup-timeout=-1 --inspect=0.0.0.0:9229' >> /start.sh
	echo 'yarn theia start /home/project --hostname=0.0.0.0' >> /start.sh

#USER theia
CMD /task.sh ; /start.sh ; bash

#docker build -t land007/theia-python:latest .
#docker rm -f theia-python; docker run -it --privileged -p 15050:5050 --expose 9229 -p 19229:9229 -v "$(pwd):/home/project:cached" -e "username=land007" -e "password=fcea920f7412b5da7be0cf42b8c93759" --name theia-python land007/theia-python:latest
#docker rm -f theia-python; docker run -it --privileged --expose 1080 -p 1080:1080 --expose 3000 -p 3000:3000 -p 15050:5050 --expose 9229 -p 19229:9229 -v "$(pwd):/home/project:cached" -e "username=land007" -e "password=fcea920f7412b5da7be0cf42b8c93759" --name theia-python land007/theia-python:latest
