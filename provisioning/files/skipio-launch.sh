#!/bin/bash
# Helper script to startup all skipio related services
#   Or run them separately outside of this script

#./bin/twilio_proxy #DISABLED

systemctl start skipio-clockwork.service
systemctl start skipio-sidekiq.service
systemctl start skipio-webpack.service
systemctl start skipio-web.service