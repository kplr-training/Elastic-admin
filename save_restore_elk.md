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
- **Retrouvez vous dans vos trois noeuds de votre cluster Elasticsearch et exécutez les consignes suivantes:** 

  dans votre fichier de configuration d'Elasticsearch `elasticsearch.yml`, vous devez ajoutez le chemin vers votre repository:
    - Créez un dossier qui sera votre repository
    - Editez le fichier elasticsearch.yml
    - Ajoutez le chemin vers le repository : `path.repo : ["chemin/vers/dossier"`]
 
![image](https://user-images.githubusercontent.com/123748165/232626507-e4ae75de-82b4-464b-ad41-da3308d6cb38.png)

    - Changez le propriètaire de votre dossier: 
    ```
    chown elasticsearch:elasticsearch CHEMIN-VERS-DOSSIER/
    ```
    - Redémarrez le service Elasticsearch : ` systemctl restart elasticsearch.service `

- Vous utilisez le chemin vers le répertoire que vous avez créer pour compléter la création du votre repo.
- Activez la compression du snapshot.

![image](https://user-images.githubusercontent.com/123748177/228501571-6812fe48-3d95-4ea6-9ca3-23ec8aadc1ac.png)

- Et vous créez votre repository.
- Vous pouvez vérifier que le repository est bien créé en vérifiant le status de connexion:

 ![image](https://user-images.githubusercontent.com/123748177/228505783-d3b3a998-bb52-4f9d-86f8-d6d9cb4ddc2e.png)

- Ensuite, vous devez créez une "Policy", pour ce faire: 
   - Choisissez un nom pour votre Policy, par exemple : `kplr-policy`
   - Choisissez un nom pour les snapshots, par exemple: `kplr-snapshot`
   - Choisissez le repository que vous venez de créer 
   - Choisissez la fréquence de vos snapshots, par exemple chaque minute
   - Ensuite, sélectionnez l'index que vous avez créer
   - Vous pouvez configurez la rétention de vos snapshots comme la durée d'expiration et le nombre maximum des snapshots à conserver.
   - Aprés la création de la "Policy", vous pouvez l'exécuter:
   
     ![image](https://user-images.githubusercontent.com/123748177/228508149-27040d3a-fdf4-45f6-966f-a0c207ae83f1.png)
     
- *Vous pouvez lister les fichiers du repository que vous avez créé dans votre machine pour vérifier que les snapshots se créent chaque minute!*

## 2- Restauration des données après perte

La restauration des données est un processus crucial pour assurer la continuité des activités et la sécurité des informations vu que les entreprises et les organisations dépendent souvent de données importantes pour leur fonctionnement quotidien.

La perte de ces données peut causer des dommages considérables, tels que des pertes financières, une perte de productivité, des impacts sur la réputation de l'entreprise et des risques pour la sécurité des informations.

La restauration des données permet de récupérer des données perdues ou endommagées à partir de sauvegardes précédemment créées. Cette procédure garantit que les données sont restaurées dans leur état précédent avant la perte ou l'endommagement, assurant ainsi la continuité des activités et la préservation de l'intégrité des données.


- Pour simuler une perte des données, vous pouvez supprimer l'index que vous avez créé à partir de "Index Management":

![image](https://user-images.githubusercontent.com/123748177/228509662-3e2315b6-efe5-405b-97ba-e3b653f8fc41.png)


![image](https://user-images.githubusercontent.com/123748177/228509849-338801ed-8a86-41ca-abb9-c68364c75275.png)

- Pour restaurer les données perdues, redirigez vous vers "Snapshot et Restore", choisissez le dernier snapshot créé et puis restaurez le:

![image](https://user-images.githubusercontent.com/123748177/228510978-ad131620-67b7-466b-ab04-bde0251e212b.png)
puis vous decocher `All data streams and indices`, pour preciser quel data stream vous souhaitez restorer.
<br>
![image](https://user-images.githubusercontent.com/123748165/232626110-f09f0d01-126c-41df-883e-184b966d4876.png)
par la suite vous continuer en appuyant sur `Next`.:
<br>
![image](https://user-images.githubusercontent.com/123748165/232626150-4f5d786b-069d-4470-8bae-cb20228caea2.png)
<br>
Puis `Restore snapshot`.
<br>
![image](https://user-images.githubusercontent.com/123748165/232625706-b3ed1efa-7e6a-4028-9727-ccaf2346e9dd.png)
<br>
*Pour le moment, vous ne changez pas la configuration de l'index à restaurer, vous devez seulement restaurer vos données.*

- Vous pouvez vérifier le status de votre restauration des données à partir de la rubrique "Restore Status", vérifiez bien que le status est "Complete"
- **Revenez au "Index Management" et vérifiez bien que les données sont restaurées 😃**

![image](https://user-images.githubusercontent.com/123748177/228512178-224cf8ca-b05e-4f19-8002-03b277fed00f.png)



