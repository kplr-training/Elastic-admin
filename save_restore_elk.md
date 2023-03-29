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

- Ensuite, cliquez sur "Snapshot et restore"
![image](https://user-images.githubusercontent.com/123748177/228497121-d0ba99ba-f633-49cb-b93e-a67c4c791932.png)

- Vous devez tout d'abord créez un repository
![image](https://user-images.githubusercontent.com/123748177/228497412-4a869741-df5d-417a-9e6e-b79ce869321b.png)

- Choisissez comme nom : `kplr`
- Choisissez comme type : ` Shared file system `
- Dans votre fichier de configuration d'Elasticsearch `elasticsearch.yml`, vous devez ajoutez le chemin vers votre repository:
    - Créez un dossier qui sera votre repository
    - Editez le fichier elasticsearch.yml
    - Ajoutez le chemin vers le repository : `path.repo : "chemin/vers/dossier"`
     ![image](https://user-images.githubusercontent.com/123748177/228501255-9683c691-58d1-47b7-8072-484b7b59d8c4.png)

    - Redémarrez le service Elasticsearch : ` systemctl restart elasticsearch.service `

- Vous utilisez le chemin vers le répertoire que vous avez créer pour compléter la création du votre repo.
- Activez la compression du snapshot.
![image](https://user-images.githubusercontent.com/123748177/228501571-6812fe48-3d95-4ea6-9ca3-23ec8aadc1ac.png)

- Et vous créez votre repository.
- Vous pouvez vérifier que le repository est bien créé en vérifiant le status de connexion:
 ![image](https://user-images.githubusercontent.com/123748177/228505783-d3b3a998-bb52-4f9d-86f8-d6d9cb4ddc2e.png)

- 




