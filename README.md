This site is helpful in making this bad boy work:

http://verahill.blogspot.com/2013/12/532-temper-temperature-monitoring-usb.html, and for posterity, here's the content from the site will follow. I'll note, that I did not copy the instructions exactly, but you can adapt this information to the latest best practices.

----

A colleague of mine got a TEMPer thermometer USB (0c45:7401 Microdia) back when he didn't have any air conditioning at all in his office and wanted to prove to the university that the temperature got so high that it was impossible for him to do any work on some days. He's now got air conditioning.

Anyway, plugging in the USB stick got me the following:
* /dev/hidraw5 and /dev/hidraw6 get created

* DMESG shows 

[441126.932728] usb 2-4.2: new low-speed USB device number 11 using ehci-pci
[441127.025790] usb 2-4.2: New USB device found, idVendor=0c45, idProduct=7401
[441127.025803] usb 2-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[441127.025811] usb 2-4.2: Product: TEMPerV1.2
[441127.025818] usb 2-4.2: Manufacturer: RDing
[441127.030229] input: RDing TEMPerV1.2 as /devices/pci0000:00/0000:00:02.1/usb2/2-4/2-4.2/2-4.2:1.0/input/input24
[441127.030516] hid-generic 0003:0C45:7401.000F: input,hidraw5: USB HID v1.10 Keyboard [RDing TEMPerV1.2] on usb-0000:00:02.1-4.2/input0
[441127.033234] hid-generic 0003:0C45:7401.0010: hiddev0,hidraw6: USB HID v1.10 Device [RDing TEMPerV1.2] on usb-0000:00:02.1-4.2/input1

* lsusb shows

Bus 002 Device 011: ID 0c45:7401 Microdia 


Searching online for 0c45:7401 brought up this cheesily title post: http://www.linuxjournal.com/content/temper-pi

From that post: 
 If instead dmesg says this:
[snip]
and lsusb says:
$ lsusb
Bus 001 Device 005: ID 0c45:7401 Microdia
then congratulations, you have the new TEMPer probe and will have to use completely different software. 
While that sounds as if you'll have continue searching for a new how-to, in fact the entire post is about that particular version. So, I followed the instructions at Linux Journal -- I'll just offer my step by step version of it here with some added detail:

sudo apt-get install python-usb python-setuptools snmpd git
sudo easy_install snmp-passpersist
mkdir ~/tmp
cd ~/tmp
git clone git://github.com/padelt/temper-python.git
cd temper-python/
sudo python setup.py install

At this point I could get a temperature reading by doing: 
$ sudo temper-poll 

Found 1 devices
Device #0: 24.4°C 75.9°F

But running stuff as root is unsatisfying, so I created a UDEV rule:
$ sudo vim /etc/udev/rules.d/80-temper.rules

SUBSYSTEMS=="usb", ATTRS{idVendor}=="0c45", ATTRS{idProduct}=="7401", GROUP="users", MODE="0666"

I then unplugged the USB stick, did 
sudo service udev restart

and plugged it back in. 
$ temper-poll 
Found 1 devices
Device #0: 25.8°C 78.3°F

