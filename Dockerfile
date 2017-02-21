FROM ubuntu:xenial
MAINTAINER obscur95 <obscur95@gmail.com>
#
ENV DEBIAN_FRONTEND noninteractive \
	DEBCONF_NONINTERACTIVE_SEEN true
#
#Configuration de la langue FR
#
RUN locale-gen fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr
ENV LC_ALL fr_FR.UTF-8
#
#
#Creation des repertoires
#
RUN mkdir /home/gns3 \
	&& mkdir /home/gns3/GNS3 \
	&& mkdir /home/gns3/GNS3/images \
	&& mkdir /home/gns3/GNS3/images/IOS \
	&& mkdir /home/gns3/GNS3/images/IOU \
	&& mkdir /home/gns3/GNS3/images/QEMU \
	&& mkdir /home/gns3/GNS3/images/QEMU/CSR1000v \
	&& mkdir /home/gns3/GNS3/images/QEMU/Fortigate \
	&& mkdir /home/gns3/GNS3/images/QEMU/PC \
	&& mkdir /home/gns3/GNS3/projects
#
#Copie du fichier sources.list
#
COPY sources.list /etc/apt/sources.list
#
#Mise a jour de la distribution
#
RUN dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get -y dist-upgrade
#
#Installation des packages
#
RUN apt-get -y install libc6:i386 libstdc++6:i386 \
	&& apt-get -y install libssl1.0.0:i386 \
	&& apt-get -y install lsb-release telnet traceroute tcpdump net-tools vim nano \
	&& apt-get -y install git bison flex \
	&& apt-get -y install python3-setuptools python3.5 \
	&& apt-get -y install python3-pip \
	&& python3.5 -m pip install -U pip
#
#Pre-requis GNS3 server
#
RUN apt-get -y install qemu-kvm qemu-system-x86 vpcs dynamips uuid-runtime \
	&& cd /tmp ; git clone http://github.com/ndevilla/iniparser.git ; cd iniparser ; make \
	&& cp /tmp/iniparser/libiniparser.* /usr/lib/ \
	&& cp /tmp/iniparser/src/iniparser.h /usr/local/include \
	&& cp /tmp/iniparser/src/dictionary.h /usr/local/include \
	&& cd /tmp ; git clone https://github.com/GNS3/iouyap.git ; cd iouyap ; make ; make install \
	&& apt-get -y install libpcap-dev \
	&& cd /tmp ; git clone https://github.com/GNS3/ubridge.git ; cd ubridge ; make ; make install \
	&& cd / \
	&& ln -s /lib/i386-linux-gnu/libcrypto.so.1.0.0 /lib/i386-linux-gnu/libcrypto.so.4
#
#Installation de GNS3 server
#
RUN python3.5 -m pip install gns3-server
#
#Copie du fichier de configuration de GNS3 server
#
COPY GNS3.conf /etc/xdg/GNS3.conf
#
#Copie des images IOS
#
COPY IOS/c3745-advipservicesk9-mz.124-25d.bin /home/gns3/GNS3/images/IOS/c3745-advipservicesk9-mz.124-25d.bin
COPY IOS/c7200-adventerprisek9-mz.124-15.T17.bin /home/gns3/GNS3/images/IOS/c7200-adventerprisek9-mz.124-15.T17.bin
COPY IOS/c7200-adventerprisek9-mz.152-4.S7.bin /home/gns3/GNS3/images/IOS/c7200-adventerprisek9-mz.152-4.S7.bin
#
#Copie des images IOU
#
COPY IOU/CiscoIOUKeygen.py /home/gns3/GNS3/images/IOU/CiscoIOUKeygen.py
COPY IOU/i86bi-linux-l2-adventerprisek9-15.6.0.9S.bin /home/gns3/GNS3/images/IOU/i86bi-linux-l2-adventerprisek9-15.6.0.9S.bin
COPY IOU/i86bi-linux-l2-ipbasek9-15.1g.bin /home/gns3/GNS3/images/IOU/i86bi-linux-l2-ipbasek9-15.1g.bin
COPY IOU/i86bi-linux-l3-adventerprisek9-15.5.2T.bin /home/gns3/GNS3/images/IOU/i86bi-linux-l3-adventerprisek9-15.5.2T.bin
#
#Copie des images QEMU
#
COPY QEMU/CSR1000v/csr1000v_harddisk.vmdk /home/gns3/GNS3/images/QEMU/CSR1000v/csr1000v_harddisk.vmdk
COPY QEMU/CSR1000v/csr1000v-universalk9.03.16.04b.S.155-3.S4b-ext.iso /home/gns3/GNS3/images/QEMU/CSR1000v/csr1000v-universalk9.03.16.04b.S.155-3.S4b-ext.iso
COPY QEMU/Fortigate/fortios_5.4.2.qcow2 /home/gns3/GNS3/images/QEMU/Fortigate/fortios_5.4.2.qcow2
COPY QEMU/Fortigate/fortigate_p10G.qcow2 /home/gns3/GNS3/images/QEMU/Fortigate/fortigate_p10G.qcow2
COPY QEMU/PC/TinyCore-current.iso /home/gns3/GNS3/images/QEMU/PC/TinyCore-current.iso
COPY QEMU/PC/TinyCore-hda.qcow2 /home/gns3/GNS3/images/QEMU/PC/TinyCore-hda.qcow2
#
#Rends executable les images IOS et IOU
#
RUN chmod +x /home/gns3/GNS3/images/IOS/c3745-advipservicesk9-mz.124-25d.bin \
	&& chmod +x /home/gns3/GNS3/images/IOS/c7200-adventerprisek9-mz.124-15.T17.bin \
	&& chmod +x /home/gns3/GNS3/images/IOS/c7200-adventerprisek9-mz.152-4.S7.bin \
	&& chmod +x /home/gns3/GNS3/images/IOU/i86bi-linux-l2-adventerprisek9-15.6.0.9S.bin \
	&& chmod +x /home/gns3/GNS3/images/IOU/i86bi-linux-l2-ipbasek9-15.1g.bin \
	&& chmod +x /home/gns3/GNS3/images/IOU/i86bi-linux-l3-adventerprisek9-15.5.2T.bin
#
#Ouverture des ports
#
EXPOSE 3080 4000-4050 5900-5910
#
#Copie du fichier de demarrage
#
COPY startup.sh /home/gns3/startup.sh
RUN chmod a+x /home/gns3/startup.sh
#
ENTRYPOINT cd /home/gns3 ; ./startup.sh
#
