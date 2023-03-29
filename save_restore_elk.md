## KIBANA : SAUVEGARDE ET RESTAURATION DE ELASTICSEARCH

Cette partie pratique a pour objectif de vous familiariser avec les snapshots et la restauration des données d'Elasticsearch. 
Les snapshots sont une fonctionnalité importante d'Elasticsearch qui permet de sauvegarder les données et les paramètres d'un cluster. Cela peut être particulièrement utile pour prévenir la perte de données en cas de défaillance matérielle ou de catastrophe naturelle. La restauration de ces snapshots permet de récupérer rapidement les données et de les réinsérer dans le cluster. 
Au cours de cette partie pratique, vous apprendrez à créer des snapshots, à les restaurer et à effectuer des opérations de maintenance sur les snapshots existants. Cela vous permettra de mieux comprendre comment sauvegarder et restaurer vos données Elasticsearch de manière efficace et fiable.

## 1- Création des Snapshots

Avant de commencer la création des snapshots, vous devez tout d'abord ingérer des données dans un index Elasticsearch. Pour ce faire, vous utilisez le script shell `bulk.sh` pour  l'ingestion des données.

- Créez votre index et choisissez le nombre des fichiers à ingérer ( Notez bien que 25 fichiers ~ 1 Go des données ), vous pouvez par exemple ingérer les 20 fichiers à l'aide de la commande suivante:
```
 ./bulk.sh wiki-kplr 20
```
- Vous pouvez visualiser la taille de votre index en temps réel à l'aide de la commande suivante:
```
watch -n 1 'curl -s -X GET -k -u elastic:kplr123 "https://esnode-3.elastic.kplr.fr:9200/_cat/indices" | awk -v OFS="\t" "{print \$3, \$7, \$9}"'
```
**Pour créer un snapshot, suivez les consignes suivantes:**
- Connectez vous à Kibana, puis accédez à la partie "Stack Management" :
![image](https://user-images.githubusercontent.com/123748177/228496402-0ad428c3-58d4-43b0-b531-a96f86e4d161.png)

- Ensuite, cliquez sur "Index management"
![image](https://user-images.githubusercontent.com/123748177/228496661-7a3d68c8-3a2f-42d4-997f-17d4d247766f.png)

- 
