## Installation d'un cluster elastic/kibana multi-noeud sécurisé avec TLS/SSL/HTTPS

Dans le cadre de notre formation, vous allez installer un cluster multi-noeud pour héberger Elastic et Kibana. Cette configuration nous permettra de découvrir et de vous entraîner sur les outils de gestion de données d'Elasticsearch, tout en apprenant à configurer un cluster de manière optimale. 

Vous allez également mettre en place des mesures de sécurité en utilisant les protocoles TLS/SSL/HTTPS pour sécuriser l'accès à votre cluster. Cette configuration sécurisée vous permettra d'apprendre à protéger les données et les informations stockées dans votre cluster, ainsi que de comprendre les enjeux liés à la sécurité des données dans les environnements professionnels. 

## 1- Installation d'Elasticsearch :

Vous avez 3 machines Linux quelque part dans le cloud, chacune avec des adresses IP différentes. Ces machines utilisent le système d'exploitation Ubuntu 22.4. 

Pour avoir accès à distance à ces machines, Vous devez taper la commande suivante, en ajoutant à la fin l'adresse IP publique de la machine :
```
ssh -i "training.pem" ubuntu@YOUR.IP.ADRESS
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
 elasticsearch-reset-password -u elastic -i
```
- **NB:** Si vous voulez d'avoir un mot de passe qui est généré automatiquement, vous tapez la commande suivante et vous aurez votre mot de passe:
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
![image](https://user-images.githubusercontent.com/123748177/228221462-d1420abd-9c3f-4aae-9786-13d3d2a9aa81.png)


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
**NB: Vous refaites la même chose pour le troisième noeud pour le configurer!!**

Pour vérifier que les nouveaux noeuds sont bien ajoutés au cluster, vous tapez les commandes suivantes: 
- Vous lancez Elasticsearch tout d'abord dans les nouveaux noeuds:
```
systemctl daemon-reload

systemctl enable elasticsearch

systemctl start elasticsearch
```
- Puis, vous interroguez l'API Elastic ( à partir du noeud 1 ):
```
curl -k -u elastic:kplr123 https://esnode-1.elastic.kplr.fr:9200/_cluster/health?pretty
``` 

Vous pouvez voir dans le résultat de la commande que le cluster kplr-cluster **contient à présent les 3 noeuds**.


## 4- Installation de Kibana:

Pour installer Kibana, vous choisissez l'un des noeuds secondaires dans lequel vous allez procédez l'installation. On choisit par exemple le noeud `es-node-2`.

Vous installez Kibana à l'aide de la commande suivante:
```
sudo apt-get update && sudo apt-get install kibana
```
Vous accédez par la suite au fichier de configuration pour modifier les parties nécessaires:
```
vi /etc/kibana/kibana.yml
```
Puis, vous apportez les modifications suivantes ( la partie System: Kibana Server), en précisant le port du serveur et son adresse, ainsi que le lien que vous allez utiliser pour se connecter à Kibana dans votre navigateur: 
```
server.port: 5601

server.host: "0.0.0.0"

server.publicBaseUrl: "https://dash01.dev.kplr.fr:5601"
```
Ajoutez aussi la liste des noeuds du cluster pour que Kibana puisse se connecte à chacun parmi eux ( la partie System: Elasticsearch):
```
elasticsearch.hosts:
  - https://esnode-1.elastic.kplr.fr:9200
  - https://esnode-2.elastic.kplr.fr:9200
  - https://esnode-3.elastic.kplr.fr:9200
```
![image](https://user-images.githubusercontent.com/123748177/228008363-ef620894-a6f9-44d7-a3b7-4479775e3ed2.png)

**Maintenant, vous devez créer des coordonnées de Kibana pour qu'elle se connecte au cluster d'une manière sécurisée.** 
Pour ce faire, vous devez générer le jeton, dans la console du noeud actuel, tapez la commande suivante:
```
curl -X POST -k -u elastic:kplr123 https://esnode-2.elastic.kplr.fr:9200/_security/service/elastic/kibana/credential/token/kibana_token

```

NB: Copiez la valeur du jeton pour l'utiliser par la suite! 
![image](https://user-images.githubusercontent.com/123748177/228222565-cd2bc29a-36dd-47f4-b9ee-863f0ce50acc.png)

Redirigez vous vers le répertoire `/usr/share/kibana/bin`:
```
 cd /usr/share/kibana/bin
```
Ensuite, vous tapez la commande suivante pour définir le jeton de connexion 
```
./kibana-keystore add elasticsearch.serviceAccountToken

```
Puis, collez le jeton que vous venez de copier dans la console.

Vous allez par la suite copier la certificat `http_ca.crt` qui existe dans le répertoire des certificats de Elasticsearch vers le répertoire des certificats de Kibana à l'aide de la commande suivante:
```
cp /etc/elasticsearch/certs/http_ca.crt  /etc/kibana/certs/
```
Vous modifiez le propriètaire des fichiers existants dans le répertoire `certs`:
```
cd /etc/kibana/certs/
chown -R kibana:kibana *
```
Vous revenez vers le fichier de configuration `kibana.yml` et vous apportez les modifications suivantes (la partie System: Elasticsearch (Optional)) :
```
elasticsearch.ssl.verificationMode: certificate
elasticsearch.ssl.certificateAuthorities: [ "/etc/kibana/certs/http_ca.crt" ]
```
**Génération des certificats SSL avec Let's Encrypt**

Dans cette partie, vous allez générer des certificats SSL dont on aura besoin pour sécuriser la communication entre le serveur de Kibana et votre navigateur web.

Pour ce faire, vous commencez par l'installation de `Snapd` qui est un gestionnaire de paquets utilisé pour gérer les paquets de logiciels Snap sur les systèmes d'exploitation Linux.
```
apt-get -y install snapd
```
A l'aide de Snap, vous allez installer Certbot qui va vous aidez à créer votre certificat:
```
snap install --classic certbot
```
Maintenant, pour générer votre certificat, tapez la commande suivante: 

```
certbot certonly --standalone
```
Ensuite: 
 - Vous pouvez tapez votre adresse email 
 - Vous tapez `Y` pour accepter les conditions d'utilisation 
 - Vous demandez à votre formateur de vous donnez le nom de domaine qui sera sous la forme suivante : `dash0X.dev.kplr.fr` 

A ce moment, votre certificat est bien téléchargé dans votre machine!

Dans la console, tapez la commande suivante pour créer le répertoire suivant dont vous allez ajouter votre certificat:
```
mkdir /etc/kibana/certs/dash01.dev.kplr.fr
```
Ensuite, vous copiez les fichiers du certificat vers le répertoire que vous venez de créer:
```
cp -a /etc/letsencrypt/archive/dash01.dev.kplr.fr/. /etc/kibana/certs/dash01.dev.kplr.fr
```
Finalement, vous revenez vers le fichier de configuration principal de Kibana et vous apportez les modifications suivantes:
```
server.ssl.enabled: true
server.ssl.certificate: /etc/kibana/certs/dash01.dev.kplr.fr/fullchain1.pem
server.ssl.key: /etc/kibana/certs/dash01.dev.kplr.fr/privkey1.pem

```

![image](https://user-images.githubusercontent.com/123748177/228023179-d22f1b5e-f832-42e4-8f18-f75c601644dd.png)


**Il ne vous reste qu'à démarrer Kibana :)**
Pour ce faire, exécuter les commandes suivantes: 
```
systemctl daemon-reload

systemctl enable kibana

systemctl start kibana
```
- Puis, on vérifie l'état du Kibana pour vérifier que tout marche correctement.

```
systemctl status kibana
```
![image](https://user-images.githubusercontent.com/123748177/228309327-a8321452-8bd4-4621-83cd-160b9c670f13.png)

**Félicitations!! Vous pouvez maintenant vous connecter à Kibana à partir de votre navigateur en utilisant votre lien unique qui est sous la forme `dash0X.dev.kplr.fr:5601`**

![image](https://user-images.githubusercontent.com/123748177/228312105-a49a3b2b-0cd2-4df9-bbeb-0fcf76dc5ece.png)

Notez bien: 
`
Username: elastic
Password: kplr123
`

![image](https://user-images.githubusercontent.com/123748177/228313513-dd01a125-77b2-4e77-ae46-3d55d1e0d8e6.png)
