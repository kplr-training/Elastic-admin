## Installation d'un cluster elastic/kibana multi-noeud sécurisé avec TLS/SSL/HTTPS

Dans le cadre de notre formation, vous allez installer un cluster multi-noeud pour héberger Elastic et Kibana. Cette configuration nous permettra de découvrir et de vous entraîner sur les outils de gestion de données d'Elasticsearch, tout en apprenant à configurer un cluster de manière optimale. 

Vous allez également mettre en place des mesures de sécurité en utilisant les protocoles TLS/SSL/HTTPS pour sécuriser l'accès à votre cluster. Cette configuration sécurisée vous permettra d'apprendre à protéger les données et les informations stockées dans votre cluster, ainsi que de comprendre les enjeux liés à la sécurité des données dans les environnements professionnels. 

**1- Installation d'Elasticsearch :**

Vous avez 3 machines Linux quelque part dans le cloud, chacune avec des adresses IP différentes. Ces machines utilisent le système d'exploitation Ubuntu 22.4. 

Pour avoir accès à distance à ces machines, Vous devez taper la commande suivante, en ajoutant à la fin l'adresse IP publique de la machine :
```
ssh -i "KPLR.pem" ubuntu@YOUR.IP.ADRESS
```
Lorsque vous êtes bien connectés à vos machines, vous basculez en mode administrateur,our éviter les problèmes d'accès aux ressources, et vous vous déplacez vers le répertoire racine, en tapant les commandes suivantes 
  
 ``` 
 sudo su
 cd
 ```
Vu que toutes ces machines sont des nouvelles instances d'Ubuntu, vous devez mettre à jour la distribution ainsi qu'installer certains paquets dont vous aurez peut-être besoin, tels que l'éditeur Vim, la commande curl, GNUPG et gpg. 

Donc, vous allez mettre à jour chacune de ces machines, à l'aide de la commande suivante:
 ```
 apt-get update && apt dist-upgrade -y && apt-get install -y vim curl gnupg gpg;
 ```
Maintenant, vos machines sont prêtes pour commencer l'installation d'Elasticsearch (L'installation suivante se fait dans les trois machines).

Tous les packages sont signés avec une clé de signature Elasticsearch. Téléchargez et installez la clé de signature publique :
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
```
Vous devrez installer le paquet apt-transport-https avant de procéder :
```
sudo apt-get install apt-transport-https
```
Enregistrez la définition du dépôt dans /etc/apt/sources.list.d/elastic-8.x.list :
```
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
```
Et finalement, vous installez Elasticsearch:
```
sudo apt-get update && sudo apt-get install elasticsearch
```
**Configuration additionnelle**

Vous devez apporter des modifications au fichier `/etc/hosts` qui contient une table de correspondance entre les adresses IP et les noms d'hôtes. Il est utilisé par le système d'exploitation pour résoudre les noms de domaine en adresses IP. 

Vous devez ajouter les adresses IP de vos machines avec des noms d'hôtes pour avoir une correspondance. Pour ce faire, vous tapez la commande suivante:
```
vi /etc/hosts
```
Puis, vous ajoutez les lignes suivantes en ajoutant l'adresse IP privée de chaque machine:
```
IP.ADRESS.HOST.1 esnode-1.elastic.kplr.fr esnode-1
IP.ADRESS.HOST.2 esnode-2.elastic.kplr.fr esnode-2
IP.ADRESS.HOST.3 esnode-3.elastic.kplr.fr esnode-3
```
**2- Configuration du noeud master du cluster :**
Dans cette partie, vous choisissez une machine parmi les trois que vous avez pour qu'elle soit le noeud maitre 'Master' de votre cluster et vous commencez de la configurer.

Tout d'abord, vous allez vous positionner dans le répertoire qui contient les fichiers de configuration à l'aide de la commande suivante: 
```
sudo apt-get update && sudo apt-get install elasticsearch
```







