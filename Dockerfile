# ========================================================================
# Start with an intermediate image only for downloading / extracting / ...
# ========================================================================
FROM centos:7
#autor information
MAINTAINER  Jiaosai Li ljs@impcas.ac.cn
#install system packages
RUN yum -y update && \
    yum install -y \
    make \
    wget \
    perl-devel \
    gcc \
    gcc-c++ \
    readline-devel \
    && yum clean all -y

ENV EPICS_TOP /home/linac/software/epics
ENV EPICS_BASE ${EPICS_TOP}/base-R7.0.4.1
ENV EPICS_HOST_ARCH=linux-x86_64
RUN mkdir -p ${EPICS_TOP}
ADD base-7.0.4.1.tar.gz ${EPICS_TOP}

#set work directory
WORKDIR ${EPICS_BASE}
RUN make clean && make

ENV EPICS_BASE_BIN=${EPICS_BASE}/bin/${EPICS_HOST_ARCH} \
    EPICS_BASE_LIB=${EPICS_BASE}/lib/${EPICS_HOST_ARCH} \
    LD_LIBRARY_PATH=${EPICS_BASE_LIB}:${LD_LIBRARY_PATH}
ENV PATH=${PATH}:${EPICS_BASE_BIN}

#Set the work directory to root
WORKDIR /

#run /bin/bash by default
ENTRYPOINT ["/bin/bash"]
