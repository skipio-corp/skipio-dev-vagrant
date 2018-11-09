
# Setup dependencies
#sudo apt-get update

# Set permissions just in case
#sudo chmod -R 775 /home/vagrant/skipio

# Set env
source /home/vagrant/.nvm/nvm.sh

sudo systemctl start skipio-clockwork.service
sudo systemctl start skipio-sidekiq.service
#sudo systemctl start skipio-webpack.service
#sudo systemctl start skipio-web.service