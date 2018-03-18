# Centbox Vagrant Example
### Start the virutal machine
This command creates and configures guest machines according to your Vagrantfile.

    vagrant up

### Connect to you virtual machine. ssh into the vm. 
This will SSH into a running Vagrant machine and give you access to a shell.

    vagrant ssh

### shutdown the virutal machine
This command shuts down the running machine Vagrant is managing.

    vagrant halt

### List all Vagrant Boxes
This command stops the running machine Vagrant is managing and destroys all resources that were created during the machine creation process.

    vagrant destroy

### List all Vagrant Boxes

    vagrant box list

### Add CentBox to your 
  
    vagrant box add --name "CentBox" https://storage.googleapis.com/centbox/CentBox.json
   
### Remove all Cenbox from your computer
    vagrant box remove CentBox --all
    
### Remove specific version of Cenbox from your computer

    vagrant box remove CentBox --box-version 0.5.0  

### Verify Centbox checksum

    openssl sha1 `pwd`/centbox/build/CentBox.v0.5.4.box
