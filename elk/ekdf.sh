#!/bin/bash
docker pull charypar/swarm-dashboard:latest
docker pull kibana:6.6.0
docker pull logstash:6.6.0
docker pull elasticsearch:6.6.0
docker stack deploy dashboard -c swarmdashboard.yml
docker stack deploy ek -c kibanaelastic.yml
