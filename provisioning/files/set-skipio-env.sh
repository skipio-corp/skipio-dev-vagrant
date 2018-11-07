# /bin/bash

# Replace Skipio env variables pulled from Heroku with values appropriate for local development
declare -A envvars

# Vars to change
envvars=(
        [RACK_ENV]=development
        [RAILS_ENV]=development
        [REDIS_URL]="\'redis:\/\/localhost:6379\/1\'"
        [RPUSH_REDIS_URL]="\'redis:\/\/localhost:6379\/1\'"
        [BASE_URL]="\'http:\/\/192.168.30.30:3000\'"
        [SKIPIO_GRAPHQL_URL]="\'http:\/\/localhost:5050\/graphql\'"
        [MEMCACHEDCLOUD_SERVERS]="\'localhost:11211\'"
)

# Vars to remove
envvars_d=(
        'REDISCLOUD_URL'
        'GOOGLE_APPLICATION_CREDENTIALS'
        'DATABASE_URL'
        'HEROKU_'
)

for e in "${!envvars[@]}"
do
        search=$e
        replace=${envvars[$e]}
        sed -i -r "s/${search}=(.*)/${search}=${replace}/g" /home/vagrant/.env
done

for i in "${envvars_d[@]}"
do
        search=${i}
        sed -i "/${search}/d" /home/vagrant/.env
done