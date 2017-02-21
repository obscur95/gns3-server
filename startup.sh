#!/bin/bash
set -e
python3 /home/gns3/GNS3/images/IOU/CiscoIOUKeygen.py > /home/gns3/.iourc
cd /home/gns3/
echo [license] > iourc1 | cat .iourc | grep ";" >> iourc1
mv iourc1 .iourc
sed "s/GNS3_USER/$GNS3_USER/" /etc/xdg/GNS3.conf > /etc/xdg/GNS3_1.conf
sed "s/GNS3_PASSWORD/$GNS3_PASSWORD/" /etc/xdg/GNS3_1.conf > /etc/xdg/GNS3.conf
rm /etc/xdg/GNS3_1.conf
gns3server
