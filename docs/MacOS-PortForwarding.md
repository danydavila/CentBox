# Mac Port Forwarding
### Forward external Port 80 and 443 to your internal virtual machine
### 1.  Create the anchor file:

`sudo nano /etc/pf.anchors/com.centbox`


Inside the anchor file, enter:

```
rdr pass inet proto tcp from any to any port 80 -> 127.0.0.1 port 8000
rdr pass inet proto tcp from any to any port 443 -> 127.0.0.1 port 44300


```

**Make sure to add a newline at the end of this file.**

### 2.  Test the anchor file:

`sudo pfctl -vnf /etc/pf.anchors/com.centbox`

### 3.  Add the anchor file to the pf.conf file:

`sudo nano /etc/pf.conf`

Load the anchor file we previously created, make sure to add these entries to the appropriate spot.
 
```
#
# com.apple anchor point
#
scrub-anchor "com.apple/*"
nat-anchor "com.apple/*"
rdr-anchor "com.apple/*"
rdr-anchor "com.centbox"
dummynet-anchor "com.apple/*"
anchor "com.apple/*"
load anchor "com.apple" from "/etc/pf.anchors/com.apple"
load anchor "com.centbox" from "/etc/pf.anchors/com.centbox"
```

###4.  Load and enabling pf

* To manually enable it (no restart required)

`sudo pfctl -e -f /etc/pf.conf`

* To enable it automatically after each restart

`sudo nano /System/Library/LaunchDaemons/com.apple.pfctl.plist`

```
<key>ProgramArguments</key>
<array>
    <string>pfctl</string>
    <string>-e</string> <!-- new line -->
    <string>-f</string>
    <string>/etc/pf.conf</string>
</array>
```


### Display Your Current Port Forwarding Rules
  
    sudo pfctl -s nat

### Reference
https://apple.stackexchange.com/questions/230300/what-is-the-modern-way-to-do-port-forwarding-on-el-capitan-forward-port-80-to/230331#230331
https://apple.stackexchange.com/questions/254654/port-forwarding-on-macos-sierra
https://salferrarello.com/mac-pfctl-port-forwarding/
