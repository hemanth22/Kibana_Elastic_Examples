#!/bin/bash
docker stack deploy dashboard -c swarmdashboard.yml
docker stack deploy ek -c kibanaelasticv7.yml
