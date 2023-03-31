# Musique

application pour permettre aux producteurs de déposer leur musique et aux personnes avec 100 ou 50 Francs d'acheter une musique. Ainsi les personnes ne payent plus de CD, le téléchargement se fait une seule fois et l'envoie n'est pas possible.

# Lancer le serveur uvicorn

> Le lancement du serveur se fait dans l'environnement virtuel

```bash
pipenv shell
```

> pour générer automatiquement le fichier requirement

```bash
pip install pipreqs

pipreqs /path/to/project
```
Une fois dans l'environnement virtuel il est possible de démarrer le serveur en spécifiant le port et l'hôte via la commande

```bash
uvicorn musique:app --host 192.168.100.34 --port 8000 --reload
uvicorn musique:app --host 192.168.43.205 --port 8000 --reload
```

Commande pour activer le mode desktop sur linux

```bash
flutter config --enable-linux-desktop
```

Il est pertinnent de spécifier l'adresse ip car pour que l'émulateur Android communique avec l'api il faut que l'adresse ip soit celle de la machine physique.
**musique** est le fichier musique.py qui est le fichier principal de l'api
**app** est l'objet crée dans le fichier musique.py : app=FastAPI()
**reload** permet de redémarrer le serveur après un changement du code.

Pour tester on peut utiliser la commande suivante 

```bash

 wget http://192.168.100.42:8000/albums
 
```

# migration avec alembic

> créer un fichier init :

```bash
alembic init alembic
```

> changer le chemin de la bd pour le chemin de la bd utilisée

```python
#mysql
SQLALCHEMY_DATABASE_URL = "mysql+pymysql://root@localhost:3306/dbname"
#postgresql 
SQLALCHEMY_DATABASE_URL = "postgresql://user:password@postgresserver/dbname"
```

> Créer le script de migration pour chaque table

```python
alembic revision -m " create tablename table"
```

> Migration proprement dite

```python
alembic upgrade head
```
# Post d'une image depuis flutter dio upload form data

on charge le formulaire de données et on spécifie le champ média pour envoyer à l'API

```dart
var formData = FormData.fromMap({
  'name': 'wendux',
  'age': 25,
  'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
});
response = await dio.post('/info', data: formData);
```

