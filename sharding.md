## Initiation au principe de partitionnement (Sharding) dans Elasticsearch

Le partitionnement des données dans Elasticsearch est une fonctionnalité clé qui permet de répartir efficacement les données sur plusieurs nœuds, ce qui améliore la résilience et les performances de votre cluster. 

Vous avez déjà configurer votre cluster Elasticsearch en utilisant plusieurs nœuds, afin de pouvoir répartir les données de manière efficace. Maintenant, vous allez charger des données massives dans votre cluster et puis configurer les indices et les shards pour répartir les données sur plusieurs nœuds et maximiser les performances de votre cluster en ajustant les paramètres de réplication et de partitionnement en fonction de vos besoins spécifiques. 

Tout au long de cette expérience pratique, vous allez découvrir les avantages du partitionnement d'Elasticsearch et acquérir les compétences nécessaires pour gérer efficacement des données massives.

## 1- Préparation de l'environnement et chargement des données
  **Préparation de l'environnement**
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
Dans ce répertoire, vous allez créer 3 répertoires:
```
mkdir json ndjson sample
```
Tapez la commande suivante pour vérifier que vous avez bien créez les différents répertoires:
```
ll
```
Notez bien: 
- json : ce répertoire sert à stocker les données que vous allez téléchargés et dont vous aurez besoin pour alimenter Elasticsearch.
- ndjson : ce répertoire va contenir les différentes fichiers qui contiennent les memes données mais au format NDJSON. NDJSON (Newline Delimited JSON) est un format de données qui permet de stocker et de transmettre des données structurées sous forme de fichiers texte, où chaque objet JSON est séparé par une nouvelle ligne. 
- sample: ce répertoire vous sera utile pour exécuter vos tests.

  **Chargement des données**
  
Kaggle est l'une des plateformes les plus populaires pour trouver des ensembles de données publics pour les utilisateurs intéressés à explorer et à apprendre la science des données et l'apprentissage automatique. Vous allez utilisez cette plateforme pour télécharger l'ensemble de données que vous allez manipuler durant ce workshop.

Pour ce faire:
- Vous aurez besoin tout d'abord de télécharger les packages dont vous aurez besoin à savoir `le gestionnaire des packets de Python 3` et `API de ligne de commande de Kaggle`:
```
  apt install python3-pip
```
```
  pip install --user kaggle
```
- Connectez vous sur la plateforme Kaggle `https://www.kaggle.com`.
- Cliquez sur l'icone de votre compte existante en haut à droite, et puis accédez à votre profile.
![image](https://user-images.githubusercontent.com/123748177/228361517-cb675031-abd6-4e6e-b6f5-2abb7057fb48.png)

 - Allez dans la section "Compte", puis "API" et sélectionnez "Créer un nouveau jeton API". Cela déclenchera le téléchargement de kaggle.json, un fichier contenant vos identifiants API.
![image](https://user-images.githubusercontent.com/123748177/228361783-e2d2df1d-44a0-4de7-9841-294749300ad8.png)

 - Créez un répertoire `kaggle` dans la racine :
 ```
 mkdir ~/.kaggle
 ```
 - Dans ce répertoire, créez un fichier json `kaggle.json` dans lequel vous allez **copier le contenu du fichier contenant vos identifiants API**:
 ```
  cd .kaggle/
  vi kaggle.json
 ```
 - Déplacez vous vers le répertoire `json` dans lequel vous allez téléchargez votre ensemble de données:
 ```
  cd /enwiki20201020/json
 ``` 
 - Téléchargez vos données, n'oubliez pas d'ajouter votre nom d'utilisateur dans la commande: 
 ```
  /root/.local/bin/kaggle datasets download USER-NAME/plain-text-wikipedia-202011
 ```
 - Les données sont téléchargés sous format zip, extrayez le fichier dans le répertoire actuel et supprimer le:
 ```
  unzip plain-text-wikipedia-202011.zip && rm plain-text-wikipedia-202011.zip
 ```
 **NB: Les données sont chargées sous forme des fichiers JSON
 
## 2- Conversion des fichiers JSON en fichiers NDJSON

NDJSON signifie "newline delimited JSON" en anglais. C'est un format de données qui permet de stocker et de transmettre des données structurées sous forme de fichiers texte, où chaque objet JSON est séparé par une nouvelle ligne.

Contrairement à JSON standard, qui stocke des données structurées dans un seul bloc de texte, ndjson stocke chaque objet JSON dans une ligne distincte. Cela permet de lire et de traiter les données de manière plus efficace pour les programmes qui travaillent avec des flux de données en temps réel ou avec de grands ensembles de données.

En particulier, ndjson est souvent utilisé pour importer en vrac des données dans les bases de données NoSQL, y compris Elasticsearch, car il permet de transmettre un grand nombre de documents en une seule requête HTTP. En utilisant ndjson, il est possible de transmettre un grand nombre de documents JSON sans avoir à créer une requête HTTP pour chaque document, ce qui peut entraîner une diminution des performances.

**Maintenant, vous etes censés créer un script Python qui sert à convertir des fichiers JSON en format NDJSON qui est compatible avec l'API Bulk d'Elasticsearch.**

L'API Bulk d'Elasticsearch est une API RESTful qui permet de traiter plusieurs documents en une seule requête HTTP. Elle permet de créer, de mettre à jour ou de supprimer plusieurs documents à la fois, et de les ajouter à un index spécifié. Cela rend le traitement en masse de données beaucoup plus efficace que les opérations de traitement de document individuel.


**- Script de conversion des fichiers JSON**

A ce moment, vous devez écrire le script Python qui va vous permet de convertir les fichiers JSON en fichiers NDJSON.

Pour ce faire, créez un fichier Python `to_ndjson.py` dans lequel vous écrivez votre script. Voici le pseudo code du script à créer:

```
Importer les bibliothèques 'json' et 'os'

Définir le dossier où se trouvent les fichiers .json

Pour chaque fichier dans le dossier :

    Si le fichier se termine par .json :
    
        Ouvrir le fichier et Charger les données JSON à partir du fichier
        Créer une liste vide pour stocker les données à envoyer à Elasticsearch
        
        Pour chaque document dans les données JSON :
            Créer une action de type "index" pour chaque document
            Ajouter l'action à la liste des données
            Ajouter le document à la liste des données
            
        Ajouter un caractère de nouvelle ligne à la fin de la requête
        Écrire les données dans un fichier .ndjson

```

## 3- Ingestion des données dans un cluster Elasticsearch en utilisant l'API Elasticsearch Bulk

A ce moment, vous devez écrire un script shell (écrit en Bash) qui permet l'ingestion de données en masse dans Elasticsearch. L'ingestion se fait à partir de fichiers NDJSON (Newline Delimited JSON) contenant les données à indexer.

Pour ce faire, créez un fichier Bash `bulk.sh` dans lequel vous écrivez votre script. Voici le pseudo code du script à créer:

```
Si le premier argument est vide alors :
    Afficher le message d'erreur et les instructions pour l'utilisation du script suivants:
       "Usage: ./bulk_ingest.sh <index_name> [num_files]"
       "       ./bulk_ingest.sh <index_name>"
       "        |---- Ingests all .ndjson files in the current directory"
       "Options:"
          "  <index_name>: Name of the Elasticsearch index to ingest data into"
          "  <num_files>: Number of .ndjson files to ingest."
          "               Default: ingest all files in the current directory"
          
          
    Quitter le script avec un code d'erreur

Si le deuxième argument est fourni alors :
    Limite = deuxième argument
Sinon :
    Limite = nombre de fichiers .ndjson dans le répertoire courant

Afficher le message pour indiquer le nombre maximum de fichiers qui seront traités pour l'index spécifié

Initialiser i à 1

Pour chaque fichier .ndjson dans le répertoire courant :
    Si i est supérieur à la limite alors :
        Sortir de la boucle
        
    Envoyer une requête POST Elasticsearch pour indexer les données du fichier courant dans l'index spécifié
    Incrémenter i de 1


```





