## Initiation au principe de partitionnement (Sharding) dans Elasticsearch

Le partitionnement des données dans Elasticsearch est une fonctionnalité clé qui permet de répartir efficacement les données sur plusieurs nœuds, ce qui améliore la résilience et les performances de votre cluster. 

Vous avez déjà configurer votre cluster Elasticsearch en utilisant plusieurs nœuds, afin de pouvoir répartir les données de manière efficace. Maintenant, vous allez charger des données massives dans votre cluster et puis configurer les indices et les shards pour répartir les données sur plusieurs nœuds et maximiser les performances de votre cluster en ajustant les paramètres de réplication et de partitionnement en fonction de vos besoins spécifiques. 

Tout au long de cette expérience pratique, vous allez découvrir les avantages du partitionnement d'Elasticsearch et acquérir les compétences nécessaires pour gérer efficacement des données massives.

## 1- Préparation de l'environnement et chargement des données

Tout d'abord, connectez vous à un de vos noeuds du cluster que vous créez (par exemple esnode-3) à l'aide de la commande ssh:
```
ssh -i "KPLR.pem" ubuntu@ec2-NODE-PUBLIC-IP-ADRESS.compute-1.amazonaws.com
```
Vous basculez en mode administrateur et puis vous vous positionnez dans le répertoire racine: 
```
sudo su
cd
```
Vous allez tout d'abord créez l'ensemble des répertoires sur lesquels vous allez organiser votre travail.

Commencez par la création du répertoire `enwiki20201020` et puis accédez à ce dernier:
```
mkdir enwiki20201020
cd enwiki20201020/
```

