
# Setup dependencies
#sudo apt-get update

# Set env
source /home/vagrant/.nvm/nvm.sh

systemctl start skipio-clockwork.service
systemctl start skipio-sidekiq.service
systemctl start skipio-webpack.service
systemctl start skipio-web.service