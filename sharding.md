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
 
  
  
  
  
  
  
  
  
  
