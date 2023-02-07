# Copyright (c)
#   2021-2022 Hammad Rauf <rauf.hammad@gmail.com>, Syed M. Shaaf
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
FROM debian:stable-slim
ENV container docker
ENV TERM=linux
ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_DB_NAME=my_db
ENV ROOT_PWD=changeme01
ENV POWER_USER=ceaser
ENV PU_PWD=changeme02
RUN /bin/bash -c 'echo "deb http://ftp.us.debian.org/debian stable main contrib non-free" > /etc/apt/sources.list.d/additional-repo.list'
RUN apt-get update
RUN apt-get install -y --no-install-recommends dialog apt-utils sudo
RUN apt-get update
##STOPSIGNAL SIGRTMIN+3
RUN mkdir maria_install
WORKDIR maria_install
COPY create_db_user.sql .
COPY create_db_user.sh .
COPY response_file.txt .
RUN chmod a+x create_db_user.sh
WORKDIR /
COPY startup_script.sh .
RUN chmod a+x startup_script.sh
RUN apt-get install -y --no-install-recommends mariadb-server mariadb-client
#RUN apt-get clean
#RUN rm -rf                        \
#    /var/lib/apt/lists/*          \
#    /var/log/alternatives.log     \
#    /var/log/apt/history.log      \
#    /var/log/apt/term.log         \
#    /var/log/dpkg.log
VOLUME ["/var/lib/mysql","/var/log/mysql"]
CMD [ "/bin/bash", "-c", "/startup_script.sh" ]
