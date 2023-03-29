#!/bin/sh

# Vérifiez si le nom de l'index a été fourni en argument
if [ -z "$1" ]
# Affichez le message suivant
then
    echo "Usage: ./bulk_ingest.sh <index_name> [num_files]"
    echo "       ./bulk_ingest.sh <index_name>"
    echo "        |---- Ingests all .ndjson files in the current directory"
    echo "Options:"
    echo "  <index_name>: Name of the Elasticsearch index to ingest data into"
    echo "  <num_files>: Number of .ndjson files to ingest."
    echo "               Default: ingest all files in the current directory"
    exit 1
fi

# Si un deuxième argument est fourni, alors il s'agit du nombre de fichiers à ingérer
# Sinon, on récupère tous les fichiers .ndjson dans le répertoire courant
if [ "$2" ]
then
  limit=$2
else
  limit=$(ls -1q *.ndjson | wc -l)
fi

echo "Indexing up to $limit files for index $1"

i=1
############Ajoutez du code au dessous#############

# Boucle à travers chaque fichier .ndjson dans le répertoire courant
do
  # Si le nombre de fichiers maximum à ingérer est atteint, on sort de la boucle
  
  # Envoyez une requête POST Elasticsearch pour indexer les données du fichier courant dans l'index spécifié

  # Incrémente le compteur de fichiers traités
done
