
 ***** NOTE All the credit of the VIB file etc goes to 'thebel1' and his original branch  https://github.com/thebel1/thpimon


 I've just added bits for HomeAssistant for JSON reading.

 So here goes.......

 1) create your rsa public/private key 

 e.g. passwordless 
 
 mkdir /usr/share/hassio/share/local-secrets/
 chmod 700 /usr/share/hassio/share/local-secrets/
 ssh-keygen -f /usr/share/hassio/share/local-secrets/
 scp /usr/share/hassio/share/local-secrets/id_rsa.pub <target-esxi>:/etc/ssh/root-keys/
 and then appened to your /etc/ssh/root-keys/authorized_keys

 After doing so you should be able to ssh freely using the command
 
 ssh -i /usr/share/hassio/share/local-secrets/id_rsa root@<target-esxi>

 2) Install the driver and Get the esxi temp to be read 

   Look at and ha_push2esxi.sh script... to push required VIB file and a python file and library over to your ESXI

   It'll require you to install the VIB file and then reboot your ESXI host, aka all your VMs will need to be stopped temporarily

   THEN COME BACK TO THIS FILE...

   You'll want to review and modify the

    ha_piesxi_config.ini
    
    Adjust for what you want the json output file to be called and then execute the script 

    ha_piesxi_temp.sh
 
    it should generate the output file in /usr/share/hassio/share/<youroutput-esxi-name>.json

    ONCE YOU'VE GOT THAT BIT WORKING ........

 3) In HomeAssistant Make sure that 'Homeassistant' has ability to access the /share area ( Internall it translates to  the location under /usr/share/hassio/share ) 
    In the configuration.yaml file of homeassistant allow external directory access as via the NEW or existing allowlist_external_dirs:

homeassistant:
  allowlist_external_dirs:
    - /share/


sensor:

  - platform: file
    name: esxi_pi401_temp
    value_template: "{{ value_json.temp }}"
    unit_of_measurement: °C
    file_path: /share/esxi_pi401_temp.json
    scan_interval: 70

  Verify the configuration in HA ...  Configuration -> Server Controls -> Check configuration ... if ALL OK , then click Restart.

