# Skipio Vagrant Build
An isolated development environment for the Skipio stack. It uses Vagrant and ansible to build and auto provision a VM to run a Skipio instance.

## Setup Dependencies
Download and install VirtualBox and Vagrant for your OS:
    * [VirtualBox](https://www.virtualbox.org/wiki/Downloads/) - System virtualization
    * [Vagrant](https://www.vagrantup.com/downloads.html) - Tool to build and manage VMs

## Download, Build, and Setup
This vagrant config runs a minimized version of Ubuntu 16.04 (Xenial) and utilizes [Ansible](https://www.ansible.com/resources/get-started) to auto provision nearly all of the dependencies and configuration prerequisites for running the Skipio stack.

### 1 - Download
Get the Skipio Vagrant files from the repo:
In this current iteration you should download the **skipio-dev-vagrant** repo in the same parent directory that contains your Skipio code repo. (i.e The **skipio-dev-vagrant** and **skipio** repo dirs should be siblings) This allows the dev environment to be agnostic from the skipio code and helps for IDEs to still be able to develop locally, or in the VM.

```
git clone git@github.com:skipio-corp/skipio-dev-vagrant.git 
```

[Skipio Development Environment (Vagrant)](https://github.com/skipio-corp/skipio-dev-vagrant)


### 2 - Build and Provision
Stand up the Vagrant machine

Enter the cloned repo directory and run the command to stand up and provision the machine:
```
cd skipio-dev-vagrant
```

```
vagrant up
```

NOTE: The auto provisioning does not include **skipio graphql**. It has been disabled in this iteration.


### 3 - Setup: Manually finish provisioning
Some provisioning steps have not yet been automated and require manual setup:

Within the **skipio-dev-vagrant** dir, SSH into the new machine, switch users, and go to the shared skipio dir:
```
vagrant ssh
```

Everything must run as the **skipio** user, so switch users:
```
sudo su - skipio
```

### 4 - Set env vars
Get env variables from Heroku env:
```
cd /home/skipio/
```

```
heroku config -s -a skipio-qa >> .env
```

Run the script to update env vars for development purposes:
```
bash /home/skipio/set-skipio-env.sh
```

```
chmod 600 .env
```

From **/home/skipio/** run the env file:
```
export $(cat .env | xargs)
```

Next, go into the repo folder in order to setup the DB
```
cd /home/skipio/skipio
```


### 4 - Setup Database
Run command to pull QA database from Heroku (You will need to input your Heroku login):
```
rails db:drop
```

```
heroku pg:pull DATABASE_URL skipio_development -a skipio-qa
```

```
rails db:migrate
```

Re-add the skipio DB user for dev: (must be the **skipio** user in the terminal)
```
bash -lc rails runner "User.create(email: 'skipio@skipio.com', first_name: 'Skipio', last_name: 'User', password: 'skipio', password_confirmation: 'skipio', phone_mobile: '+18019108019', enabled_features: ::ALL_FEATURES, verified_at: Time.now, setup_completed_at: Time.now, setup_completed_at: Time.now, is_enabled: true, api_phone_number: '+18019108019', api_phone_provider: 'twilio', time_zone: 'Mountain Time (US & Canada)')"
```


### 5 - Run the application

```
bundle exec rails server -p 3000 -b 192.168.30.30
```

Now go to a browser and load the app:
```
192.168.30.30:3000
```


## TROUBLESHOOTING

### Setup assets
If, for some reason, an issue with assets occurs, webpack, yarn, and other rails assets may need to be rebuilt. Run the following to build and install required webpack files, and rebuild assets: (in /home/skipio/skipio/)

```
bundle exec rails assets:clobber
```
 
```
yarn install
```
```
rake assets:precompile
```


### Alternate website loading
Binding the rails app to the private IP of the Vagrant VM negates the use of the **port_forwarding**. If you still want to utilize the forwarded ports, you will need to bind the app to **0.0.0.0** instead.

### TODO
1) Add Twilio configuration
2) Add ngrok integration