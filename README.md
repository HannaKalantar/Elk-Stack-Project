## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![](https://github.com/HannaKalantar/Elk-Stack-Project/blob/f9a6d7b44bd630037fc970105767a0d355927015/Diagrams/Diagram.drawio.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the file-playbook.yml may be used to install only certain pieces of it, such as Filebeat.

https://github.com/HannaKalantar/Elk-Stack-Project/blob/9b881559124dea34dfd54d204d01846ba3a7ec81/Ansible/file-playbook.yml

This document contains the following details:
- Description of the Topologu
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly accessable, in addition to restricting non-authorized to the network.

- Load balancers can protect you against a Ddos attack due to its ability to split the work between two different servers, allowing one to go down and the system will still be running due to the load balancer now turning all the task back on to only one server instead of both. 
- The advantage of a jumpbox is that you have only one location that can be used to access multiple location this also allows for very good protection for all other locations you may have.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the event logs and system matrix.

- Filebeat is watching for specific logs and specific set of files you have set. 
- Metricbeat is recording the statics of the files and/or logs you have specified for it look for. 

The configuration details of each machine may be found below.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 10.0.0.4   | Linux            |
| Web-1RT  | Dvwa/WS  | 10.0.0.5   | Linux            |
| Web-2RT  | Dvwa/WS  | 10.0.0.6   | Linux            |
| Elk-VM   | Elk      | 10.2.0.4   | Linux            |

### Access Policies

- The machines on the internal network are not exposed to the public Internet. 
- Only the jump box machine can accept connections from the Internet.
- Access to this machine is only allowed from my own personal public IP address in order to pass through the firewall.
- Machines within the network can only be accessed by JumpBoxRedTeamProvisioner.

- If you want to access the ELK VM you must first start from the container located in your ansible-playbooks. 
- To find the container that allows you to access the ELK VM, the following steps must occur...
  - Connecting to your jump box machine
  - `sudo docker container list -a`
  - Find the container, mine is called "quirky_herschel"
  - `sudo docker start quirky_herschel`
  - `sudo docker attach quirky_herschel`
  - At this point you can SSH into your ELK machine
 
A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | Yes                 | 10.1.0.4             |    
| Web-1RT  | No                  |                      |
| Web-2RT  | No                  |                      |
| Elk-VM   | No                  |                      |

### Elk Configuration

The main advantage of automating configuration with Ansible is that it allows me the capability to copy a master copy of the playbook and then being able to copy into the container that I want to run it off of. This makes it easy to update the file if ever needed and makes the tedious changes more easy.

The playbook implements the following tasks:

1) First, the playbook will install docker.io on to all webservers that have been underlined in the hosts file. After that, it will follow and install the rest python3-pip, and - docker module.
2) The second task in our playbook will run a systemctl command to insure that the memory that is being used is within a stated amount
3) The third task that is being used in our playbook is installing and elk container with certain ports open allowing for us to get into it after succesful download the playbook will run its final task
4) Fourth task will be used as a systemd command to ensure that the service that has been installed and configured is up and running with no issues.

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![](https://github.com/HannaKalantar/Elk-Stack-Project/blob/e5319f88efe9bc574181bd147922097e7049eb1a/Diagrams/docker%20ps.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- 10.0.0.6
- 10.0.0.5

We have installed the following Beats on these machines:
- Metricbeat 
- Filebeat

Side Note: Filebat is collecting the system log information and storing that information into a designated location, and will be readable using kibana.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the ansible file to the designated container.
- Update the host file to include all webservers that you are requesting as well as uncommenting [webservers] and adding underneath your webservers ip addresses you will be adding a [elk] and the elks IP address. Next to all IP addresses you need to include ansible_python_interpreter=/usr/bin/python3.
- Run the playbook, and navigate to Kibana<also the public ip address of the elk server:port address that you opened((5601))> to check that the installation worked as expected.

- The file that is the playbook is called elk.yml and you copy this file into the /etc/ansible/directory.
- In order to check if your elk server is up and running, you need to connect to the public IP address of the elk machine in a browser with the open port. Thus, your url should read something similar to this http://13.77.219.27:5601/app/kibana#/home.

### Step by Step from Downloading Docker to Setting up a Playbook

In order to run this set of dockers you will want to run the commands as follows. 
Note: This can only work if you already have set up Azure VMs. 

`sudo apt install docker.io`

`systemctl status docker` (run this command to ensure that your docker.io was installed and running)

After installation, if your process is not running please run `sudo systemctl status docker` to start your process.

`sudo docker pull cyberxsecurity/ansible` (this will pull the container((you must know the container/image name exactly)) and download the container for you to access)

`sudo docker run -ti cyberxsecurity/ansible:latest bash` (please only run this once, if you run it more than once you will have one or more container)

`sudo docker container list -a` (this will show all available containers that you have after running ((run -ti)) this will also give you the name of the container for you to start)

`sudo docker start` (for instance mine is quirky_herschel). This will start your container and make it available to attach too.

`sudo docker attach`

`sudo docker run -it cyberxsecurity/ansible /bin/bash` (This command will set up a host and config file within your container allowing you to set up the files how you want).

Once you have done that you will want to locate the files.

`cd /etc/ansible` once you have moved into the directory `/etc/` and moved into ansible you will want to run a `ls` to confirm your files are there.

Now that you have done all previous steps, you will be able to adjust the playbook files here. This will allow you to overwrite your playbooks, update your config files to include new webservers, or even new elk servers.

The first file we should look at is the hosts file. In here you will want to remove the # next to [webservers] and underneath a couple of lines that are already added. Then you will want to add the IP addresses that you want for your webservers. For example, mine is 10.0.0.6. Once you have added that, you will want to hit tab and add the following line next to it: `ansible_python_interpreter=/usr/bin/python3`. Rhis will allow your python-pip3 that you installed in your playbooks to work with out any issues.

After we are done with our changes to the hosts file we are going to save, exit and go into our configure file for ansible.

Once we are in the ansbile.cfg file, we are going to page down to the remote_user section of this file and change the remote_user= sysadmin to the username that you used to set up your VM. This will also be commented. You will want to uncomment the line after changing the username to your username.

Now that we have set up both of our hosts and configure files we are now going to create a playbook.

Start your container (if it already is not started) and make sure on your command is comming directly from root. For example, check your screen to see if you see something like root@5e4b8f36e048:~#.

When you are in here you are more than welcome to create a playboook, for this exercise we are creating a DVWA (Damn Vulnerable Website App) so this playbook will be for that.

Our first step will be to write the command `nano pentest.yml` this will create the playbook.

The top of your playbook should read something like this:

![](https://github.com/HannaKalantar/Elk-Stack-Project/blob/main/Images/output1.png)

This is declaring what you want the playbook to do. So we are Configuring a Web Virtual Machine using Docker.

Our host for this is going to be webservers hence why we uncommented and added the IP addresses.

Last but not least, we have become true. Allowing for this entire playbook to come true.

![](https://github.com/HannaKalantar/Elk-Stack-Project/blob/main/Images/output2.png)

This segment is saying we want `docker.io` to install, so go ahead and force it to go through if we do not have it, update the cache to `yes`, name of the process we want and the state of the process.

In the next segment we are installing pip3 which is pulling from a index of python libary that is unable to be carried with python when we install python.

![](https://github.com/HannaKalantar/Elk-Stack-Project/blob/main/Images/output3.png)

The next step should look like this...

![](https://github.com/HannaKalantar/Elk-Stack-Project/blob/main/Images/output4.png)

The next step in the playbook is going to start the webserver and open the desired ports you want. This is also where you want to include the most important piece in all of the ansible-playbook in my opinion. That would be the restart_policy: `always`. If you do not include this, you will have to always restart the playbook in order for the webserver to start up instead of starting up when you start up your machine.

![](https://github.com/HannaKalantar/Elk-Stack-Project/blob/main/Images/output5.png)

The final step in a playbook is making sure that the service is up and running. The first line in this is the name of the service we are running. The second line is the command we are running. The third line is the name of service we are running. Lastly, the fourth line is what we want to do with the service, do we want it enabled or disbaled.

![](https://github.com/HannaKalantar/Elk-Stack-Project/blob/main/Images/output6.png)

Now that we have completed that we are going to run this command `ansible-playbook pentest.yml`.

You should get this read:

![](https://github.com/HannaKalantar/Elk-Stack-Project/blob/main/Images/output7.png)

If you would like to test that the webserver is up an running you can ssh into your PRIVATE Ip address of your webserver using ssh @.

At this point you have successfully set up a webserver, playbook, configure file, and a host file.
Thank you for reading!
