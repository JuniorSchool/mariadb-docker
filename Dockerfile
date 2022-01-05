# Copyright (c)
#   2021-2022 Hammad Rauf <rauf.hammad@gmail.com>
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
ARG ARG_ROOT_PWD=changeme01
ARG ARG_POWER_USER=ceaser
ARG ARG_PU_PWD=changeme02
ARG ARG_MYSQL_DB_NAME
ENV container docker
ENV TERM=linux
ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_DB_NAME=${ARG_MYSQL_DB_NAME:-my_db}
RUN /bin/bash -c 'echo "deb http://ftp.us.debian.org/debian stable main contrib non-free" > /etc/apt/sources.list.d/additional-repo.list'
RUN apt-get update
RUN apt-get install -y --no-install-recommends dialog apt-utils
RUN apt-get update
##STOPSIGNAL SIGRTMIN+3
RUN mkdir maria_install
WORKDIR maria_install
COPY create_db_user.sql .
COPY create_db_user.sh .
COPY response_file.txt .
RUN chmod a+x create_db_user.sh
RUN apt-get install -y --no-install-recommends mariadb-server mariadb-client
RUN apt-get clean
RUN rm -rf                        \
    /var/lib/apt/lists/*          \
    /var/log/alternatives.log     \
    /var/log/apt/history.log      \
    /var/log/apt/term.log         \
    /var/log/dpkg.log
RUN /bin/bash -c "service mariadb start && sleep 10 && script -c 'mysql_secure_installation' < response_file.txt"
RUN /bin/bash -c "sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf && cat /etc/mysql/mariadb.conf.d/50-server.cnf | grep bind"
RUN /bin/bash -c "sed -i 's/MYSQL_DB_NAME/${MYSQL_DB_NAME}/g; s/ARG_POWER_USER/${ARG_POWER_USER}/g; s/ARG_PU_PWD/${ARG_PU_PWD}/g' create_db_user.sql" 
## INSERT SQL HERE - START -- CUSTOMIZATION, USER Creation and DB Creation Script. Use either .sh or .sql file.
RUN /bin/bash -c "service mariadb start && sleep 5 && mysql -uroot -p${ARG_ROOT_PWD} < create_db_user.sql"
##RUN /bin/bash -c "service mariadb start && sleep 5 && ./create_db_user.sh"
## INSERT SQL HERE - END
## Cleanup installation artifacts for security reasons.
WORKDIR /
RUN /bin/bash -c "rm -rf /maria_install"
##RUN /bin/bash -c 'service mariadb start && tail -f /dev/null'
CMD [ "/bin/bash", "-c", "/usr/sbin/service mariadb start && /usr/bin/tail -f /dev/null" ]
##ENTRYPOINT [ "/bin/bash", "-c", "/usr/sbin/service mariadb start" ]
##ENTRYPOINT [ "/bin/bash", "-c", "/usr/sbin/service mariadb start && /usr/bin/tail -f /dev/null" ]
