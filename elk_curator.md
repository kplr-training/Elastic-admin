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

## 2- Snapshot et Restauration Curator

sudo apt-get install nfs-kernel-server
sudo mkdir -p /srv/bck
sudo chmod 775 /srv/bck/
vi /etc/exports
/srv/bck 127.0.0.1(rw,sync,no_root_squash)
exportfs -r
sudo apt install nfs-client
sudo mount -t nfs 127.0.0.1:/srv/bck /tmp
sudo umount /tmp
sudo mkdir -p /exports/backup
sudo chown elasticsearch:elasticsearch /exports/backup
127.0.0.1:/srv/bck /exports/backup nfs defaults 0 0
sudo mount -a
sudo chown elasticsearch:elasticsearch /exports/backup
path.repo: ["/exports/backup"]
systemctl restart elasticsearch
curl -XPUT '127.0.0.1:9200/_snapshot/cur_backup' -H 'Content-Type: application/json' -d '{ "type": "fs", "settings": {"location": "/exports/backup","compress": true}}'
![image](https://user-images.githubusercontent.com/123748177/228602723-1fbecdc0-6d4a-4e67-82f0-be80274a7f4d.png)

![image](https://user-images.githubusercontent.com/123748177/228602055-7ab44753-0187-41f5-89f7-dad0263cd51d.png)

vi snapshot.yml

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


curator snapshot.yml

![image](https://user-images.githubusercontent.com/123748177/228607860-802d34a1-8584-4ee0-9e22-deaf88d91e5f.png)














