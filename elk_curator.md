## Elasticsearch Curator

Elasticsearch Curator est un outil open-source conçu pour aider à gérer les index d' Elasticsearch. Il permet aux utilisateurs de définir des règles pour automatiser les tâches de maintenance telles que la suppression ou la sauvegarde des index, ainsi que la gestion des snapshots. 

En utilisant Curator, les utilisateurs peuvent facilement configurer et automatiser les tâches de maintenance pour leurs index Elasticsearch, ce qui leur permet de gagner du temps et de réduire les erreurs potentielles associées à la gestion manuelle des index.

- Ce workshop est conçu pour fournir une introduction complète à Curator, un outil open-source utilisé pour la gestion d'index Elasticsearch. Pendant ce workshop, vous allez apprendre à installer et configurer Curator pour votre cluster Elasticsearch. 

- Vous allez également couvrir les concepts clés de la gestion d'index, y compris les snapshots et la restauration de cluster, la gestion et le management des alias, ainsi que la création et la suppression des index. 

- Tout au long de ce workshop, vous allez acquérir une compréhension approfondie de Curator et de son utilisation dans la gestion des index Elasticsearch, ainsi que des compétences pratiques pour automatiser les tâches de maintenance associées à la gestion des index.

## 1- Introduction et Installation Curator

Pour installer *Curator*, vous pouvez choisir l'une des trois machines que vous avez ( On a choisi la machine esnode-1).

- Afin de commencer l'installation, exécutez les commandes suivantes:

```
apt install python3-pip
pip install -U elasticsearch-curator==8.0.3
```

- Vérifiez que Curator est bien installé en tapant la commande `help`:

```
curator --help
```
- Créez le répertoire par défaut de Curator:
```
  mkdir /root/.curator/
```

- Créez un fichier yml de configuration de Curator:

```
vi /root/.curator/curator.yml
```
- Editez le fichier yml et ajoutez la configuration suivante:
```
client:
  hosts:
    - 127.0.0.1
  port: 9200
  url_prefix:
  use_ssl: False
  certificate:
  client_cert:
  client_key:
  ssl_no_validate: False
  http_auth:
  timeout: 30
  master_only: False

logging:
  loglevel: INFO
  logfile:
  logformat: default
  blacklist: ['elasticsearch', 'urllib3']

```
- Vérifiez que Curator s'exécute correctement en essayant d'afficher les indices existants:
```
curator_cli show-indices
```
**Vous aurez comme résultat la liste des indices déjà créés.**

## 2- Gestion et Management des Alias:

**Les Alias**

Les *alias Elasticsearch* sont des noms symboliques qui permettent de faire référence à un ou plusieurs index dans Elasticsearch. Ils sont souvent utilisés pour faciliter la gestion des index dans un environnement Elasticsearch en constante évolution.

Les alias d'index peuvent être utilisés pour référencer un ou plusieurs index et permettent de changer rapidement l'index de référence pour une requête donnée. Par exemple, vous pouvez créer un alias pour votre index de production et un autre pour votre index de test, puis basculer entre eux en fonction de vos besoins.

Les alias peuvent également être utilisés pour gérer les versions d'index. Par exemple, si vous souhaitez conserver une copie de votre index actuel pour référence future, vous pouvez créer un alias pour cet index. Cela vous permet de continuer à indexer de nouveaux documents dans votre index actuel tout en conservant une copie statique pour référence.

En somme, les alias sont un moyen utile pour faciliter la gestion et la manipulation des index dans Elasticsearch, en leur donnant des noms symboliques qui sont plus facilement identifiables et manipulables que les noms d'index complexes.

**La réindexation**

La réindexation dans Elasticsearch est un processus qui permet de copier des données d'un index existant vers un nouvel index, tout en apportant des modifications à la structure ou au contenu des données. 

Ce processus peut être utile dans de nombreuses situations, notamment pour optimiser les performances de recherche, corriger des erreurs d'indexation ou mettre à jour les données avec de nouvelles informations.

**Objectifs**

Cette partie du workshop est spécifiquement dédié à la gestion et au management des alias Elasticsearch. Vous aurez l'opportunité de découvrir les différents types d'alias, notamment les alias d'index et les alias de filtres.

Vous explorerez les avantages de l'utilisation d'alias, tels que la simplification de la recherche et la gestion des index, ainsi que la facilitation de la réindexation des données. 
 
Vous acquerrez une compréhension approfondie de la gestion des alias dans Elasticsearch, ainsi que des compétences pratiques pour l'utilisation efficace des alias pour leur cluster. Que vous soyez débutant ou utilisateur expérimenté, ce workshop vous permettra d'explorer et de maîtriser la gestion des alias dans Elasticsearch.

**Manipulation**

Pour commencez votre manipulation, vous allez réindexer l'index `new_index` plusieurs fois pour avoir plusieurs copies.

Pour ce faire, vous utilisez la commande suivant dans la console de Kibana:
```
POST _reindex
{
  
  "source": {
    "index": "new_index"
  },
  "dest": {
    "index": "new_index-2023-03-XX" #Changer le jour XX pour avoir plusieurs versions
  }
    
  
}

```

![image](https://user-images.githubusercontent.com/123748177/228627128-db5ba54a-51dd-4c6c-b8e5-4277a9c219cb.png)

-Pour vérifier la bonne création des indices de réindexation, utiliser la commande suivante:

```
curl 127.0.0.1:9200/_cat/indices
```

Maintenant, vous allez créer un fichier yml `alias.yml` ou vous allez ajouter vos actions pour créer votre premier alias.

Vous devez tout d'abord préciser le nom de l'action et puis la nommé `mynewalias`. Ensuite, vous précisez que vous voulez faire un `add` donc vous ajoutez un nouveau alias.

Vous pouvez décrire un ou plusieurs filtres imbriquées.Dans le cas de ce workshop vous allez créer un seul filtre de type `pattern` et son but est de faire un filtre par le préfixe qui a comme valeur `new_index` puisque tous les indexs qu'on a créé commence par ce préfixe:

```
actions :
  1:
    action: alias
    description: "add index to mynewalias"
    options:
      name: mynewalias
    add:
      filters:
      - filtertype: pattern
        kind: prefix
        value: new_index
```
- Pour exécuter cet action, tapez la commande suivante: 
```
curator alias.yml

```
- Vérifiez que l'alias est bien créé en tapant la commande suivante:
```
 curl 127.0.0.1:9200/_cat/aliases
```

![image](https://user-images.githubusercontent.com/123748177/228628435-f86071a6-1e8f-48db-8fd2-70fc71d43021.png)

- Pour supprimer un alias, vous pouvez remplacez l'action `add` par `remove`
```
actions :
  1:
    action: alias
    description: "add index to mynewalias"
    options:
      name: mynewalias
    remove:
      filters:
      - filtertype: pattern
        kind: prefix
        value: new_index
        
```

- Pour exécuter cet action, tapez la commande suivante: 
```
curator alias.yml

```
- Vérifiez que l'alias est bien créé en tapant la commande suivante:
```
 curl 127.0.0.1:9200/_cat/aliases
```
![image](https://user-images.githubusercontent.com/123748177/228628903-03b0a834-bd7c-411b-96c2-59de444be2cf.png)

- Dans cette partie, vous allez créer un alias en ajoutant un autre filtre de type `age` pour créer un alias seulement pour les indexes réindexés dans les derniers 2 jours:

```
actions :
  1:
    action: alias
    description: "add index to mynewalias"
    options:
      name: mynewalias
    add:
      filters:
      - filtertype: pattern
        kind: prefix
        value: new_index

      - filtertype: age
        direction: younger
        source: name
        timestring: '%Y-%m-%d'
        unit: days
        unit_count: 2
 ```      
    
- Si vous vérifiez le résultat, vous voyez que seul l'index qui a une date dans l'intervalle des derniers 2 jours a été ajouté à l'alias :

![image](https://user-images.githubusercontent.com/123748177/228630422-05b9a4d0-21d7-4b3f-9fb6-1af21419794a.png)


## 3- Snapshot et Restauration Curator

**Serveur NFS** 
Un serveur NFS (Network File System) est un service de partage de fichiers utilisé pour permettre à plusieurs ordinateurs d'accéder et de partager des fichiers sur un réseau. Il permet à un ordinateur (le serveur NFS) de rendre un ou plusieurs répertoires disponibles aux autres ordinateurs du réseau, qui peuvent alors accéder à ces fichiers comme s'ils étaient stockés localement sur leur propre système. 

Le serveur NFS est souvent utilisé dans les environnements de serveurs Linux pour partager des fichiers entre des systèmes Linux ou Unix, mais il peut également être utilisé avec d'autres systèmes d'exploitation. Les avantages du serveur NFS sont sa simplicité d'utilisation, sa flexibilité et sa capacité à permettre à plusieurs utilisateurs d'accéder aux mêmes fichiers en même temps, sans avoir besoin de les copier localement sur chaque système.

**Objectifs** 

Dans cette partie pratique, vous allez installer un serveur NFS parce que qui dit backup dit externaliser les backup et sauvegarder les données ailleurs et non pas comme vous avez fait dans le précédent workshop, c'est à dire avoir les snapshots sur les mêmes serveurs que vos machines de production. 

**Manipulation** 

Vous allez commencer par l'installation de votre serveur NFS: 
- Installez tout d'abord le kernel du serveur NFS:
```
sudo apt-get install nfs-kernel-server
```
- Créez un répertoire de stockage du backup dans le serveur:
```
sudo mkdir -p /srv/bck
```
- Changez les permissions d'accès du répertoire:
```
sudo chmod 775 /srv/bck/
```
- Modifiez le fichier exports: 
```
vi /etc/exports
```
- Ajoutez la ligne suivante pour préciser le répertoire de backup à partager: 
```
/srv/bck 127.0.0.1(rw,sync,no_root_squash)
```
- Exécutez la commande suivante pour exporter le répertoire de backup via le protocole NFS:
```
exportfs -r
```
- Ensuite, vous installez le client NFS: 
```
sudo apt install nfs-client
```
- Exécutez les commandes suivantes pour monter un partage NFS sur le système local:
```
sudo mount -t nfs 127.0.0.1:/srv/bck /tmp
sudo umount /tmp
```
- Créez le répertoire suivant:
```
sudo mkdir -p /exports/backup
```
- Changez  du nouveau les permissions d'accès du répertoire:
```
sudo chown elasticsearch:elasticsearch /exports/backup
```
- Ajoutez la ligne suivante dans le fichier `/etc/fstab`: 

Le fichier /etc/fstab contient des informations sur les systèmes de fichiers qui doivent être montés, ainsi que les options de montage associées, telles que les options de sécurité, les options de lecture/écriture et les options de performance.
```
127.0.0.1:/srv/bck /exports/backup nfs defaults 0 0
```
- Tapez la commande suivante: 
```
sudo mount -a
```
*La commande "mount -a" est utilisée pour monter tous les systèmes de fichiers définis dans le fichier de configuration /etc/fstab qui ne sont pas encore montés.*
- Changez  du nouveau les permissions d'accès du répertoire:
```
sudo chown elasticsearch:elasticsearch /exports/backup
```
- Dans votre fichier de configuration principale d'Elasticsearch, ajoutez le chemin vers le repository:
```
path.repo: ["/exports/backup"]
```
- Relancez Elasticsearch: 
```
systemctl restart elasticsearch
```
- Ensuite, vous créez votre repository à l'aide de la commande curl:
```
curl -XPUT '127.0.0.1:9200/_snapshot/cur_backup' -H 'Content-Type: application/json' -d '{ "type": "fs", "settings": {"location": "/exports/backup","compress": true}}'
```
![image](https://user-images.githubusercontent.com/123748177/228602723-1fbecdc0-6d4a-4e67-82f0-be80274a7f4d.png)

- Vérifiez que le repository est bien créé: 
![image](https://user-images.githubusercontent.com/123748177/228602055-7ab44753-0187-41f5-89f7-dad0263cd51d.png)

**Maintenant, après avoir créez votre repository, vous pouvez créez des snapshots de vos indices.**

- Pour ce faire, créez un fichier yml pour créez une action:
```
vi snapshot.yml
```
Le code suivant est une configuration YAML pour une action de snapshot dans Elasticsearch Curator. Plus précisément, cette action permet de créer un snapshot d'un index spécifique ("new_index") et de le stocker dans un référentiel de sauvegarde nommé "cur_backup".

Les options définies incluent le nom de l'instantané ("bck-kplr-%Y%m%d%H%M%S") qui inclut une horodatage, l'indication de ne pas ignorer les index indisponibles, l'inclusion de l'état global, l'attente de la fin de l'action avant de continuer, et l'exécution de l'action. 

Les filtres spécifient le type de filtre (filtre de modèle), le genre de filtre (préfixe) et la valeur du filtre (new_index).

```
actions:
  1:
    action: snapshot
    description: snap new_index
    options:
      repository: cur_backup
      name: bck-kplr-%Y%m%d%H%M%S
      ignore_unavailable: False
      include_global_state: True
      partial: False
      wait_for_completion: True
      skip_repo_fs_check: False
      disable_action: False
    filters:
      - filtertype: pattern
        kind: prefix
        value: new_index
```
- Pour exécuter cet action, tapez la commande suivante:  
```
curator snapshot.yml
```
- Vous pouvez vérifier que le snapshot est bien créer:
![image](https://user-images.githubusercontent.com/123748177/228607860-802d34a1-8584-4ee0-9e22-deaf88d91e5f.png)

- **Maintenant, vous ajoutez une autre action pour faire une restauration des données:**

L'action suivante permet de restaurer un index spécifique ("new_index") à partir d'un snapshot précédemment créé et stocké dans un référentiel de sauvegarde nommé "cur_backup".

Les options définies incluent le nom du référentiel de sauvegarde ("cur_backup"), le nom de l'instantané à utiliser (le plus récent par date), le nom de l'index à restaurer ("new_index"), le fait de ne pas inclure les alias, de ne pas exécuter une restauration partielle, de renommer l'index restauré en ajoutant le préfixe "restored_", et l'attente de la fin de l'action avant de continuer.

Les filtres spécifient le type de filtre (filtre de modèle) et la valeur du filtre (bck-kplr), ainsi qu'un autre type de filtre (filtre d'état) qui spécifie que la restauration ne doit être exécutée que si l'action précédente a réussi (état SUCCESS).
```
 2:
    action: restore
    description: restore new_index
    options:
      repository: cur_backup
      # If name is blank, the most recent snapshot by age will be selected
      name:
      # If indices is blank, all indices in the snapshot will be restored
      indices: ["new_index"]
      include_aliases: False
      ignore_unavailable: False
      include_global_state: False
      partial: False
      rename_pattern: '(.+)'
      rename_replacement: 'restored_$1'
      extra_settings:
      wait_for_completion: True
      skip_repo_fs_check: True
      disable_action: False

    filters:
      - filtertype: pattern
        kind: prefix
        value: bck-kplr

      - filtertype: state
        state: SUCCESS
 ``` 
 - Vous pouvez vérifier que la restauration est bien exécuté:
 
  ![image](https://user-images.githubusercontent.com/123748177/228619212-8d839a65-20db-4304-870d-63ccff079c1d.png)

- **Vous pouvez ajouter une autre action pour supprimer l'ancienne restauration des données avant de créer une nouvelle:**
```
  3_delete_old_test:
    action: delete_indices
    description: delete test index
    options:
      continue_if_exception: True
      ignore_empty_list: True
    filters:
      - filtertype: pattern
        kind: prefix
        value: restored_new_index
      - filtertype: age
        source: creation_date
        direction: younger
        unit: days
        unit_count: 2
```


