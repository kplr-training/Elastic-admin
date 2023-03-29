
import json
import os

# Définir le dossier où se trouvent les fichiers .json
folder = "."

# Parcourir tous les fichiers dans le dossier
Pour chaque fichier dans le dossier:
    # Vérifier si le fichier se termine par .json
    if    :
        # Ouvrir le fichier .json
        with open(os.path.join(  , ), 'r') as f:
        
            # Charger les données JSON à partir du fichier
            data = 

        # Créer une liste vide pour stocker les données à envoyer à Elasticsearch
        bulk_data = []
        
        # Parcourir chaque document dans les données JSON
        for doc in data:
        
            # Créer une action de type "index" pour chaque document
            action = {"index":{}}
            # Ajouter l'action à la liste des données
            
            # Ajouter le document à la liste des données


        # Ajouter un caractère de nouvelle ligne à la fin de la requête
        bulk_data.append('\n')

        # Écrire les données en vrac dans un fichier .ndjson
        with open(os.path.join(  , ) + '  ', 'w') as f:
        
            # Joindre toutes les lignes de données en une seule chaîne de caractères
            # séparées par des caractères de nouvelle ligne
            

        # Afficher un message indiquant que le traitement du fichier est terminé
        print("done.")
