# Ce document vise à tester les APIs avec Postman
## Authentification

Un trajet est publié par un utilisateur. On aimerait :
* Seul l'utilisateur qui a publié un trajet a la capacité de le modifier cela est offert par la méthode *IsOwnerOrReadOnly*. Et seul un utilisateur connecté peut publier un trajet (POST) avec la méthode *permissions.IsAuthenticatedOrReadOnly*
views.py
```python
class TrajetViewset(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticatedOrReadOnly,IsOwnerOrReadOnly]
    queryset = Trajet.objects.all()
    serializer_class = TrajetSerializer
```
> Les services PUT, DELETE et POST sont restreints

## Login / Logout
Django rest-auth est une librairie que nous utilisons pour l'authentification des utilisateurs. un utilisateur peut se connecter et se déconnecter. Pour l'utiliser on installe la librairie via:
>* pip install dj-rest-auth
* Dans le fichier setting.py on installe l'application en ajoutant la ligne 'dj_rest_auth',
* Dans le fichier urls.py du projet on ajoute le chemin suivant path('dj-rest-auth/',include('dj_rest_auth.urls')),
* L'url de connection est http://127.0.0.1:8000/dj-rest-auth/login/
* L'url de déconnexion est http://127.0.0.1:8000/dj-rest-auth/logout/


### Session authentification
Lorsqu'on veut ajouter un trajet il faudra ajouter un token qui est arrivé via les cookies. On chosit le CSRF token, à chaque fois qu'on va vouloir faire une action qui va interagir avec la BD on va devoir copier ce token. On retourne dans les headers, on ajoute un headers qui s'appelle X-CSRFToken et on copie le CRSF qui est dans le cookie.
Pour un POST logout lorsqu'on envoie la requete ça ne marche pas. On retourne dans le headers on cré est un header X-CRSFToken, on colle le cookie et on renvoie la requete.


> NOUTCHA NGAPI Jonathan