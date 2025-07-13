#!/bin/bash

echo "🧹 Nettoyage complet de Docker en cours..."

# Arrêter et supprimer tout
sudo docker stop $(sudo docker ps -aq) 2>/dev/null
sudo docker rm $(sudo docker ps -aq) 2>/dev/null
sudo docker rmi -f $(sudo docker images -aq) 2>/dev/null
sudo docker volume rm $(sudo docker volume ls -q) 2>/dev/null
sudo docker network rm $(sudo docker network ls -q) 2>/dev/null
sudo docker system prune -a --volumes -f
sudo docker builder prune -a -f

# Nettoyer les données persistantes
sudo rm -rf /home/clarily/data/wordpress/*
sudo rm -rf /home/clarily/data/mariadb/*
sudo mkdir -p /home/clarily/data/wordpress
sudo mkdir -p /home/clarily/data/mariadb
sudo chown -R clarily:clarily /home/clarily/data/

echo "✅ Nettoyage terminé ! Vous pouvez relancer votre projet."