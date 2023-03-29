## Elasticsearch Curator

Elasticsearch Curator est un outil open-source conçu pour aider à gérer les index d' Elasticsearch. Il permet aux utilisateurs de définir des règles pour automatiser les tâches de maintenance telles que la suppression ou la sauvegarde des index, ainsi que la gestion des snapshots. 

En utilisant Curator, les utilisateurs peuvent facilement configurer et automatiser les tâches de maintenance pour leurs index Elasticsearch, ce qui leur permet de gagner du temps et de réduire les erreurs potentielles associées à la gestion manuelle des index.

- Ce workshop est conçu pour fournir une introduction complète à Curator, un outil open-source utilisé pour la gestion d'index Elasticsearch. Pendant ce workshop, vous allez apprendre à installer et configurer Curator pour votre cluster Elasticsearch. 

- Vous allez également couvrir les concepts clés de la gestion d'index, y compris les snapshots et la restauration de cluster, la gestion et le management des alias, ainsi que la création et la suppression des index. 

- Tout au long de ce workshop, vous allez acquérir une compréhension approfondie de Curator et de son utilisation dans la gestion des index Elasticsearch, ainsi que des compétences pratiques pour automatiser les tâches de maintenance associées à la gestion des index.

## 1- Introduction et Installation

Pour installer *Curator*, vous pouvez choisir l'une des trois machines que vous avez ( On a choisi la machine esnode-1).

- Afin de commencer l'installation, exécutez les commandes suivantes:

```
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb [arch=amd64] https://packages.elastic.co/curator/5/debian stable main" > /etc/apt/sources.list.d/curator.list
sudo apt update
sudo apt install elasticsearch-curator
```

- Vérifiez que Curator est bien installé en tapant la commande `help`:

```
curator --help
```
- Créez le répertoire par défaut de Curator:
```
  mkdir -p ~/.curator/
```

- Créez un fichier yml de configuration de Curator:

```
vi ~/.curator/curator.yml
```
- Editez le fichier yml et ajoutez la configuration suivante:
```
client:
  hosts:
    - IP ADRESS NODE 1
    - IP ADRESS NODE 2
    - IP ADRESS NODE 3
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

pip install -U elasticsearch-curator==8.0.3

mkdir /root/.curator/
vi /root/.curator/curator.yml
