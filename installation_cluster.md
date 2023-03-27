## Installation d'un cluster elastic/kibana multi-noeud sécurisé avec TLS/SSL/HTTPS

Dans le cadre de notre formation, vous allez installer un cluster multi-noeud pour héberger Elastic et Kibana. Cette configuration nous permettra de découvrir et de vous entraîner sur les outils de gestion de données d'Elasticsearch, tout en apprenant à configurer un cluster de manière optimale. 

Vous allez également mettre en place des mesures de sécurité en utilisant les protocoles TLS/SSL/HTTPS pour sécuriser l'accès à votre cluster. Cette configuration sécurisée vous permettra d'apprendre à protéger les données et les informations stockées dans votre cluster, ainsi que de comprendre les enjeux liés à la sécurité des données dans les environnements professionnels. 

## 1- Installation d'Elasticsearch :

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
## 2- Configuration du noeud master du cluster :

Dans cette partie, vous choisissez une machine parmi les trois que vous avez pour qu'elle soit le noeud maitre 'Master' de votre cluster et vous commencez de la configurer.

Tout d'abord, vous allez vous positionner dans le répertoire qui contient les fichiers de configuration à l'aide de la commande suivante: 
```
cd /etc/elasticsearch/
```
Vous pouvez taper la commande `ls` pour lister les différents fichiers de configuration existants.

Vous trouvez un fichier yml nommé `elasticsearch.yml` qui est le fichier qui contient la configuration principale d'Elasticsearch, vous devez le configurer pour que ce noeud soit le noeud Master.

Vous allez apporter les changmements suivants: 

  - Vous allez changer le nom du cluster et le nommé `kplr-cluster`
  - Puis, vous donnez le nom `esnode-1` au noeud maitre. Le nom du noeud doit etre unique au sein de votre cluster pour éviter toute collision de nommage.
```
cluster.name: kplr-cluster
node.name: esnode-1
```
![image](https://user-images.githubusercontent.com/123748177/227979869-e78cca58-6f6f-4717-86ae-580230cd34a8.png)

  - Modifiez le `network.host` et utilisez le nom de domaine qui est associé à ce serveur.
  - Et ajouter le port HTTP 9200
```
network.host: esnode-1.elastic.kplr.fr
http.port: 9200
```

![image](https://user-images.githubusercontent.com/123748177/227979999-1029c0ec-a81b-4315-b262-2ff509a194a4.png)

  - Modifiez la ligne `cluster.initial_masternodes`. Ce champ n'est nécessaire que la première fois que vous démarrez cette instance Elasticsearch, qui configure   également le cluster auquel ce noeud appartient. La valeur devrait être le nom du nœud Master, qui dans ce cas est `esnode-1`.
  
![image](https://user-images.githubusercontent.com/123748177/227981642-a99f7d27-5004-46d1-9c60-0122539a74d5.png)


**On va lancer maintenant le cluster avec seulement ce noeud Master**

- Vous pouvez utiliser les commandes suivantes : 
```
systemctl daemon-reload

systemctl enable elasticsearch

systemctl start elasticsearch
```

- Puis, on vérifie l'état du cluster pour vérifier que tout marche correctement.

```
systemctl status elasticsearch
```
![image](https://user-images.githubusercontent.com/123748177/227985805-e2755adf-9942-4f90-8f14-c8b6bfa7ec5b.png)


**Réinitialisation du mot de passe de Super utilisateur des noeuds Elasticsearch :**

Vous devriez pinguer l'API pour voir quel est le statut du cluster, mais tout d'abord vous devez réinitialiser le mot de passe pour le super utilisateur 'elastic' dont vous aurez besoin.

- Tout d'abord, positionnez vous dans le répertoire `/usr/share/elasticsearch/bin/`: 
```
 cd /usr/share/elasticsearch/bin/
```
- Ensuite, utilisez la commande de réinitialisation du mot de passe qui vient avec l'installation d'Elasticsearch ( Saissisez le mot de passe : kplr123 ):
```
 elasticsearch-reset-password -u elastic
```

**Maintenant, vous allez pinguer l'API elastic pour vérifier l'état du cluster:** 

```
curl -k -u elastic:kplr123 https://esnode-1.elastic.kplr.fr:9200/_cluster/health?pretty
```
Vous pouvez voir dans le résultat de la commande que le cluster `kplr-cluster` contient un seul noeud.


## 3- Ajout et configuration des noeuds 2 et 3:

Pour ajouter autres noeuds dans le cluster, vous devez générer un `jeton d'inscription` dans le noeud Master et l'utiliser dans le noeud en question pour l'intégrer dans votre cluster. Pour ce faire, on commence par la génération du jeton d'inscription 'Enrollement Token'.

- Dans le `noeud Master` ou `es-node-1`, accédez au répertoire suivant `/usr/share/elasticsearch/bin/` et puis générez le jeton à l'aide de la commande suivante: 
```
 elasticsearch-create-enrollment-token -s node
```
Vous aurez comme résultat un jeton, copiez-le et gardez-le pour l'utiliser par la suite.

- Dans le noeud que vous voulez ajouter au cluster, accédez au répertoire suivant `/usr/share/elasticsearch/bin/` et utilisez le jeton pour l'intégrer à votre cluster:

```
  elasticsearch-reconfigure-node --enrollment-token YOUR-TOKEN
```
- Pour vérifier que ce dernier est bien intégré au cluster, déplacez vous dans le fichier de configuration: 
```
  vi /etc/elasticsearch/elasticsearch.yml
```
- Vérifiez que le champ `discovery.seed_hosts` contient l'adresse IP du noeud Master
![image](https://user-images.githubusercontent.com/123748177/227997848-fa8d4eab-7db6-4a46-93e2-79b5ee1da3fb.png)

- Ensuite, vous apportez les modifications suivantes au fichier de configuration `elasticsearch.yml` du nouveau noeud:

```
cluster.name: kplr-cluster
node.name: esnode-2
network.host: esnode-2.elastic.kplr.fr
http.port: 9200
```
