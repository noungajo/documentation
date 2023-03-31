# Note utile sur Django

- Model et gestion de la base de donnee

     * dateline = models.DateField(auto_now=True) : permet d'ajouter automatique la date d'une action dans la table 

     * Lors d'une modification, `python manager.py migrations` permet de creer des historique de migrations.
     Il est alors possible via ses historiques de revenir a des versions anterieures de la base de donnees, via la commande :
          `python manage.py migrate name_app number_migration


- Personnalisatiion de Django Admin 

     * Dans le fichier admin d'une application, les class definis sont en relation avec les modeles de la base de donnees et permettent de modifier le comportement des donnes sur Django Admin.
     `list_display` permet de specifier les elements que l'on souhaite voir affiche
     `list_filter` permet de specifier les classes sur lesquels l'on souhaite definir un filtre
     `search_fields` permet de specifier les classes sur lesquels l'on souhaite effectuer une recherche

     * L'affichage des element par defaut ne tient pas toujours compte des syntaxes de langages, la classe `meta` definie en sous classe d'un model permet de modifier ce comportement
     class TodoList(models.Model):
          name = models.CharField(max_length=255)

          class Meta:
               verbose_name = 'Todo List'
               verbose_name_plural = 'Todo Lists'


- Test unitaire et interaction sur la BD 
 
     * Une fois le scenerio de test defini, executer vie : `python manage.py test`

     * Les tests se materialise sur differente fonctions avec les appels de fonction `self.assert...`
     Differents types d'assert sont disponibles selon les test voulus.


- API Rest

     * La logique des API Rest est de realise des API qui consomment et genere du JSON

     * Les `serializers` sont des elements qui assure l'intermediare entre un model et les fichiers JSON

     * Pour faire des filtres sur l'API, on install le package `django-filter` et on configure le `settings.py`
          INSTALLED_APPS = [
               ...
               'django_filters',
               ...
          ]
          ...
          REST_FRAMEWORK = {
               'DEFAULT_FILTER_BACKENDS':[
                    'django_filters.rest_framework.DjangoFilterBackend',
          ]

     * Pour faire des recherches filtrés sur l'API, on install le package `django-filter` et on configure le `settings.py`
          REST_FRAMEWORK = {
               'DEFAULT_FILTER_BACKENDS':[
                    'rest_framework.filters.SearchFilter',
               ]
          }

- API d'authentification

     * La gestion de l'authentification des utilisateurs utilise la bibliothèque `dj-rest-auth` et la configuration dans le `settings.py` est :
          INSTALLED_APPS = [
               ...
               'rest_framework.authtoken',
               'dj_rest_auth',
               ...
          ]

     Celle dans le `urls.py` donne :
          urlpatterns = [
               ...
               path('dj-rest-auth/', include('dj_rest_auth.urls')),
               ...
          ]


     * De plus ce package utilise des classe qui doivent être importées via une migration.

     * Une fois configurer il est alors possible de connecter (login) et deconnecter (logout) un utilisateur connu de la base de données via l'url 
     `localhost:8000/dj-rest-auth/login/` 


- Cross-Origin Resource Sharing (CORS)
 
     * En règle générale, les applications (un backend et un frontend dans notre cas) sur des domaines différents ne peuvent pas partager des ressource.
     Cela est très notable lorqu'on essaie d'interagir avec une API via JavaScript.
     
     * Une solution a ce problème dans un processus de développemnt local est le CORS (voir https://fr.wikipedia.org/wiki/Cross-origin_resource_sharing) 

     * L'utilisation d'un proxy peut également réglé ce problème (solution adopté en production)

     * Pour configurer cela, on va utiliser le package `django-cors-headers` et les confurations `settings.py`
          INSTALLED_APPS = [
               ...
               'corsheaders',
               ...
          ]
          ...
          MIDDLEWARE = [
               ...
               'corsheaders.middleware.CorsMiddleware',
               'django.middleware.common.CommonMiddleware',
               ...
          ]
          ...
          ...
          CORS_ALLOWED_ORIGINS = [
               'http://localhost:3000'
          ]

- API pour retourner un utilisateur connecté

     * On crée un serializer pour le model `User`

     * On définit la view du model sur l'héritage de `viewset.ViewSet` au lieu de `Model.ViewSet` tel que sur l'exemple :
          class MeViewSet(viewsets.ViewSet):
               
               permission_classes = (IsAuthenticated, )
               
               def list(self, request):
                    user = User.objects.get(username=request.user)
                    user_data = UserSerializer(user).data
                    return Response(user_data)

     * On configure ensuite la route correspondant dans le ``urls.py de l'application, mais avec une mention supplémentaire `basename` :
          router.register('me', MeViewSet, basename='me')

     * Le fichier `urls.py` du projet se configure normalement
 


- Etendre la classe User de Django

     * Pour définir les utilisateurs de son système, une approche est de réutiliser la classe User de Django, et l'incrémenter des attribut que l'on souhaite. Pour ce faire on va :

          # Definir une classe dans `model.py`, en relation OnetoOne avec la classe `User` importer de `django.contrib.auth.models`. C'est cette classe qui contient les attribut supplémentaires

          # Dans le `serializers.py`, on definit une classe qui sérialise le modèle que l'on a crée

          # De plus dans le si l'on a rendu les donné accessible via l'API, on référencie la source des attibuts supplémentaire sur le serialiser pour l'API comme il suit :
               profile = UserProfileSerialiser(source='userprofile')       
               NB : La classe `UserProfileSerialiser` est à titre illustratif et `userprofile` est le nom du modèle crée, en miniscule pour indexé le complémentaire de la relation `OnetoOneField` spécifié dans le model

          # Dans le `admin.py` on crée les classe qui herite de `admin.StackedInline` et `UserAdmin` avec les configuration suivante en dessous :
               class UserProfileInline(admin.StackedInline):
                    model = UserProfile
                    
                    
               class UserProfileAdmin(UserAdmin):
                    inlines = (UserProfileInline, )

                    
               admin.site.unregister(User)
               admin.site.register(User, UserProfileAdmin)

          # La classe `UserAdmin` est importé de `django.contrib.auth.admin` 



- Documentation de l'API avec Swagger

     * Installer le package `drf-yasg` et dans le fichier `settings.py`
          INSTALLED_APPS = [
               ...
               'django.contrib.staticfiles',
               'drf_yasg',
               ...
          ]
          ...
          ...
          SWAGGER_SETTINGS = {
               'LOGIN_URL': '/admin/login/',
               'LOGOUT_URL': '/admin/logout/',
          }

     * Dans le fichier `urls.py` principal ajouter :
     
          schema_view = get_schema_view(
               openapi.Info(
                    title="Test API",
                    default_version='v1',
                    description="Test description API",
                    contact=openapi.Contact(email="contact@snippets.local"),
                    license=openapi.License(name="BSD License"),
               ),
               public=True,
               permission_classes=[permissions.AllowAny],
          )
          ...
          ...
          ...
          urlpatterns = [
               ...
               re_path(r'^swagger(?P<format>\.json|\.yaml)$', schema_view.without_ui(cache_timeout=0), name='schema-json'),
               re_path(r'^swagger/$', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
               re_path(r'^redoc/$', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),  
          ]

     * Une fois les configuration faites, la documentation d'une requête de l'API se fais dans son viewSet comme ceci :
          @swagger_auto_schema(
               operations_description='Cette méthode retourne un objet User correspondant à l\'utilisateur courant connecté',
               responses={200: UserSerializer} 
          )

     * Pour plus de detail, conf. la doc https://github.com/axnsan12/drf-yasg#readme


Références utile :

     * https://www.youtube.com/playlist?list=PLJq8Yrm5l5dnJwKhsV-YvqXqc9HmWzc0B



=================================================================================================================================
=================================================================================================================================


-  year_formed = models.fields.IntegerField(
    validators=[MinValueValidator(1900), MaxValueValidator(2021)]
    )

     Permet de definir un intervalle de validation 


- models.py

     class Band(models.Model):

     class Genre(models.TextChoices):
          HIP_HOP = 'HH'
          SYNTH_POP = 'SP'
          ALTERNATIVE_ROCK = 'AR'

     ...
     genre = models.fields.CharField(choices=Genre.choices, max_length=5)
     ...

     Permet de mettre en place une liste d'enumeration pour un element 


- class Band(models.Model):
   …
   def __str__(self):
    return f'{self.name}'

     La fonction ___str__(self) permet d'editer la représentation de la chaîne de caractères du modèle


- AbstractUser

     C'est la classe heriter permettant de redefinir un utilisateur afin de conserver ses configuration (attributs et methodes) de depart, tout en y rajoutant les element que l'on souhaite
     Pour exlure un attribut preheriter avec cette methode on le definit a 'none'


- AbstractBaseUser

     C'est un equivqlent de la classe AbstractUser, mais celle-ci ne contient aucune classe predefinit en dehors du mot de passe. Ses configurations sont les suivantes :
     * USERNAME_FIELD  — indique le nom du champ devant être utilisé comme identifiant de connexion.

     * EMAIL_FIELD  — indique le nom du champ contenant l’adresse e-mail principale d’un utilisateur ('email' par défaut).

     * REQUIRED_FIELDS  — liste des champs à spécifier obligatoirement lors de l’utilisation de la commande  python manage.py createsuperuser.

     * is_active  — vaut  True  par défaut dans   AbstractBaseUser, mais vous pouvez ajouter votre propre champ si vous voulez gérer les utilisateurs actifs et inactifs.

     L'attribut USERNAME_FIELD peut etre utilise avec AbstractUser pour definir un nouveau attribut de connexion. Dans ce cas il faut desactiver le 'username' par defaut de connexion


- Une fois de classe User redefit, il faut specifier a Django qu'il doit utiliser notre nouveau modele pour ce connecter. la configuration dans settings.py s'ecrit :
        # Refinistion du model User pour l'authentification
        AUTH_USER_MODEL = 'authentication.User'



Références utile :

     * https://openclassrooms.com/fr/courses/7192416-mettez-en-place-une-api-avec-django-rest-framework/7424705-ajoutez-l-authentification-des-utilisateurs   
     
     * https://tech.serhatteker.com/post/2020-01/email-as-username-django/   


==========================================================================================================================================================
==========================================================================================================================================================



- Mise en place d'un système de cryptage basé sur Fernet (importer du package Cryptography)

     * Documentation officiel : https://cryptography.io/en/latest/fernet/ 

     La mise en place de ce système de cryptographie est relativement simple : 
     Gérération de la clé --> Encodage --> Cryptage --> Donnée cryptés --> Décryptage --> Décodage --> Donné initial
     Il consiste à suivre les étape suivante :

     * On génére une clé de chiffrement sur 128 bits via les outils de la librairie Fernet: `key = Fernet.generate_key()` 
     Puis : `fernet = Fernet(key)`

     * On encode en suite la dnnée à crypter,  : `data_encoded = data.encode()`
     Cette étape nous permet de passer la donnée en argument en evitant les problème de spécification du format binaire (indice `b`)
     Voir l'exemple de la documentation officiel pour noter la différence.

     * On encrypte ensuite la donnée : `data_crypted = fernet.encrypt(data_encoded)`
     La donnée ainsi traité peut être stocker, mais on notera la mention `b` pour binaire qui est indexé en avant (à gauche) de valeur de la donnée cryptée
     
     * Pour éviter les problèmes potentiel de convertion après un passage en base de donnée, on peut effectuer un décodage, qui va conservé la valeur crypté 
     en ommetant la mention `b` de binaire : `data_cipher = data_crypted.decoded`



     NB : Pour décrypté la donnée, il sera nécéssaire d'utiliser la même cle de chiffrerment qui avais été générée au départ (`key`). 
     Il est donc impérati de la sauvegarde de manière à ce que son intégrité ne soit pas compromise.

     * Pour le decryptage, on va procéder de manière analogue au cryptage.
     On comence par passé la clé sous notre class Fernet : `fernet = Fernet(key)`

     * On peut ensuite décrypter notre donnée : `data_decrypted = fernet.encrypt(data_cipher)`

     * Et en va decoder la donnée pour rétirer la mention binaire et récupérer le contenu inital : `data_instance = data_decrypted.decode()`


     On notera que cette implémentation a été éffectuer sur des données de type caractère via des fonctions appélés pour gérer les opérations de cyptage et/ou de décryptage. 
     Il est fait mention de crypter aussi des fichier avec cela.
