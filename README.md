# Skipio Vagrant Build
An isolated development environment for the Skipio stack. It uses Vagrant and ansible to build and auto provision a VM to run a Skipio instance.

## Setup Dependencies
Download and install VirtualBox and Vagrant for your OS:
    * [VirtualBox](https://www.virtualbox.org/wiki/Downloads/) - System virtualization
    * [Vagrant](https://www.vagrantup.com/downloads.html) - Tool to build and manage VMs

## Download, Build, and Setup
This vagrant config runs a minimized version of Ubuntu 16.04 (Xenial) and utilizes [Ansible](https://www.ansible.com/resources/get-started) to auto provision nearly all of the dependencies and configuration prerequisites for running the Skipio stack.


### 0 - Setup Skipio repo
Clone the Skipio repo from git:
```
git clone git@github.com:skipio-corp/skipio.git
```

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

Within the **skipio-dev-vagrant** dir, SSH into the new machine and go to the shared skipio dir:
```
vagrant ssh
```

### 4 - Set env vars
Get env variables from Heroku env:
```
cd /home/vagrant/
```

```
heroku config -s -a skipio-qa >> .env
```

Run the script to update env vars for development purposes:
```
bash /home/vagrant/set-skipio-env.sh
```

```
chmod 600 .env
```

From **/home/vagrant/** run the env file:
```
export $(cat .env | xargs)
```

Next, go into the repo folder in order to setup the DB
```
cd /home/vagrant/skipio
```


### 5 - Setup Database
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

Re-add the skipio DB user for dev:
```
bash -lc rails runner "User.create(email: 'skipio@skipio.com', first_name: 'Skipio', last_name: 'User', password: 'skipio', password_confirmation: 'skipio', phone_mobile: '+18019108019', enabled_features: ::ALL_FEATURES, verified_at: Time.now, setup_completed_at: Time.now, setup_completed_at: Time.now, is_enabled: true, api_phone_number: '+18019108019', api_phone_provider: 'twilio', time_zone: 'Mountain Time (US & Canada)')"
```


### 6 - Run the application

```
bundle exec rails server -p 3000 -b 192.168.30.30
```

Now go to a browser and load the app:
```
192.168.30.30:3000
```

### Update personal settings - ngrok - twilio
Update the following variable in **/home/vagrant/.env** to your personal twilio settings:
```
TWILIO_INBOUND_MESSAGE_CALLBACK_URL='https://<YOUR_NGROK_URL>/webhooks/twilio/messaging'
TWILIO_INBOUND_VOICE_CALLBACK_URL='https://<YOUR_NGROK_URL>/webhooks/twilio/voice'
TWILIO_PHONE_NUMBER=<YOUR_TWILIO_NUMBER>
TWILIO_STATUS_CALLBACK_URL='https://<YOUR_NGROK_URL>/webhooks/twilio/messaging'
```

### 7 - Configure ngrok (optional)
In **/home/vagrant/** set ngrok with your auth token:
```
./ngrok <YOUR_AUTHTOKEN>
```


### 8 - Run sidekiq and clock (optional)
If you want to be able to run the job queue and scheduler, start up the processes in the background. Run from **/home/vagrant/skipio**:
```
bundle exec sidekiq -v -C config/sidekiq.yml &
```

```
bundle exec clockwork config/clock.rb &
```

If you would like to suppress the output, then use **2>&1 &** instead of **&** at the end of the command.


## TROUBLESHOOTING

### Setup assets
If, for some reason, an issue with assets occurs, webpack, yarn, and other rails assets may need to be rebuilt. Run the following to build and install required webpack files, and rebuild assets: (in /home/vagrant/skipio/)

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

### Rsync
Currently sharing folders via Rsync, so if you remove or add files/folder you will need to re-sync using the **vagrant rsync** command on your local machine. May switch this back to a standard file share using mount

### TODO
1) Add Twilio configuration
2) Add ngrok integration