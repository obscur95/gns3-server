# gns3-server
L'image contiens les éléments suivants :
- IOUYAP
- QEMU
- VPCS
- DYNAMIPS

Vous trouverez également à disposition les images IOS suivants :
 - Pour Dynamips :
         - /home/gns3/GNS3/images/IOS/c3745-advipservicesk9-mz.124-25d.bin
         - /home/gns3/GNS3/images/IOS/c7200-adventerprisek9-mz.124-15.T17.bin
         - /home/gns3/GNS3/images/IOS/c7200-adventerprisek9-mz.152-4.S7.bin

- Pour IOUYAP (licence généré automatiquement):
         - /home/gns3/GNS3/images/IOU/i86bi-linux-l2-adventerprisek9-15.6.0.9S.bin
         - /home/gns3/GNS3/images/IOU/i86bi-linux-l2-ipbasek9-15.1g.bin
         - /home/gns3/GNS3/images/IOU/i86bi-linux-l3-adventerprisek9-15.5.2T.bin

Vous avez à disposition des images QEMU :
- Fortigate version 5.4.2
- CSR1000v
- TinyCore

Utilisation du FW Fortigate :
Créer une image QEMU avec les paramètres suivants :
- RAM : 1Go
- Qemu binary : qemu-system-x86_64
- Boot priority : HDD
- Console type : vnc
- Disk image (master) : Fortigate/fortios_5.4.2.qcow2
     - Disk interface : virtio
- Disk image (slave) : Fortigate/fortigate_p10G.qcow2
      - Disk interface : virtio
- Network 
      - Adapters : 1 -> 10
      - Type : virtio-net-pci
- Advanced settings : 
       - options : -nographic -vnc :5900 -enable-kvm

Utilisation du routeur CSR1000v
Créer une image QEMU avec les paramètres suivants :
- RAM : 4Go
- Qemu binary : qemu-system-x86_64
- Boot priority : HDD
- Console type : telnet
- Disk image (master) : CSR1000v/csr1000v_harddisk.vmdk
       - Disk interface : ide
- CD/DVD : CSR1000v/csr1000v-universalk9.03.16.04b.S.155-3.S4b-ext.iso
- Network 
          - Adapters : 1 -> 10
          - Type : virtio-net-pci
- Advanced settings 
          - Options : -nographic -enable-kvm -serial mon:stdio -boot order=c -smp 1 -usb -uuid XXXX

Il vous faut générer le UUID dans l'image et remplacer les XXXX avec l'UUID obtenu.

            docker exec -it "ID conteneur" bash
            uuidgen

Lorsque vous lancerez la première fois l'image, celle-ci s'installera. Pour cela, au démarrage de l'image sélectionner :
             - CSR 1000V Serial Console

Une fois l'installation terminée, il redémarrera automatiquement. 

Toute l'opération peut durée de 15 à 20 minutes suivant les performance de votre machine.

Pour générer une licence de démo suivre ce lien : https://www.cisco.com/go/license

Pour installer la licence suivre ce lien : 
http://www.cisco.com/c/en/us/td/docs/routers/csr1000/software/configuration/b_CSR1000v_Configuration_Guide/b_CSR1000v_Configuration_Guide_chapter_01000.html


Utilisation du TinyCore
Créer une image QEMU avec les paramètres suivants :
- RAM : 128Mo
- Qemu binary : qemu-system-x86_64
- Boot priority : HDD
- Console type : telnet
- Disk image (master) : PC/TinyCore-hda.qcow2
       - Disk interface : ide
- Network 
          - Adapters : 1
          - Type : virtio-net-pci
- Advanced settings 
          - Options : -boot order=c

Pour sauvegarder vos modifications, il vous faut passer la commande "backup". Les configurations se trouvent dans le répertoire "/opt".


Lancement de l'image :
          - docker run -d -e GNS3_USER=xxxx -e GNS3_PASSWORD=yyyy -p 3080:3080 -p 4000-4050:4000-4050 -p 5900-5910:5900-5910 --privileged obscur/gns3server:latest

3080 : Port HTTP d'aministration
4000-4050 : Range de port alloué pour les consoles telnet
5900-5910 : Range de port alloué pour les consoles vnc
XXXX : Login
YYYY : Password

Ajout du serveur à la GUI GNS3 :
Edit -> Preferences
Server -> Remote servers -> Add
Protocol : HTTP
Host : IP du serveur
Port : 3080 TCP
Cocher : Enable authentication
User : XXXX
Password : YYYY
