# DRF Writable Nested

Il s'agit d'un sérializer de modèles en profondeur pour Django Rest Framework. Il permet de créer/mettre à jour les modèles avec des données imbriquées connexes.
Les relations suivantes sont prises en charge:
* OneToOne
* ForeignKey
* ManyToMany ( à l'exception des relations m2m avec modèle traversant)
* GenericRelation

# Exigence
* Python (3.5, 3.6, 3.7, 3.8, 3.9)
* Django (2.2, 3.0, 3.1, 3.2)
* djangorestframework (3.8+)

# Installation

> pip install drf-writable-nested

# Utilisation
Par exemple, considérons la structure de modèle suivante:
```python

from django.db import models


class Site(models.Model):
    url = models.CharField(max_length=100)


class User(models.Model):
    username = models.CharField(max_length=100)


class AccessKey(models.Model):
    key = models.CharField(max_length=100)


class Profile(models.Model):
    sites = models.ManyToManyField(Site)
    # relation 1 à 1
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    # on a un clé étrangère
    access_key = models.ForeignKey(AccessKey, null=True, on_delete=models.CASCADE)


class Avatar(models.Model):
    image = models.CharField(max_length=100)
    profile = models.ForeignKey(Profile, related_name='avatars', on_delete=models.CASCADE)


```

Nous devons créer les sérializers suivant

```python

from rest_framework import serializers
from drf_writable_nested.serializers import WritableNestedModelSerializer


class AvatarSerializer(serializers.ModelSerializer):
    image = serializers.CharField()

    class Meta:
        model = Avatar
        fields = ('pk', 'image',)


class SiteSerializer(serializers.ModelSerializer):
    url = serializers.CharField()

    class Meta:
        model = Site
        fields = ('pk', 'url',)


class AccessKeySerializer(serializers.ModelSerializer):

    class Meta:
        model = AccessKey
        fields = ('pk', 'key',)


class ProfileSerializer(WritableNestedModelSerializer):
    # Relation ManyToMany directe 
    sites = SiteSerializer(many=True)

    # Relation ForeignKey inversée
    avatars = AvatarSerializer(many=True)

    # Relation ForeignKey directe
    access_key = AccessKeySerializer(allow_null=True)

    class Meta:
        model = Profile
        fields = ('pk', 'sites', 'avatars', 'access_key',)


class UserSerializer(WritableNestedModelSerializer):
    # OneToOne Relation inversée car User est parent mais le champ user est déclaré dans le modèle Profile
    profile = ProfileSerializer()

    class Meta:
        model = User
        fields = ('pk', 'profile', 'username',)

```

Vous pouvez également utiliser NestedCreateMixin ou NestedUpdateMixin de ce package si vous souhaitez prendre en charge uniquement la logique de création ou de mise à jour.

Par exemple, nous pouvons transmettre les données suivantes avec les champs imbriqués correspondants à notre sérialiseur principal :

```JSON
data = {
    'username': 'test',
    'profile': {
        'access_key': {
            'key': 'key',
        },
        'sites': [
            {
                'url': 'http://google.com',
            },
            {
                'url': 'http://yahoo.com',
            },
        ],
        'avatars': [
            {
                'image': 'image-1.png',
            },
            {
                'image': 'image-2.png',
            },
        ],
    },
}

```

```python

user_serializer = UserSerializer(data=data)
user_serializer.is_valid(raise_exception=True)
user = user_serializer.save()
```

Ce sérialiseur créera automatiquement toutes les relations imbriquées et nous recevrons une instance complète avec des données remplies.

```python
user_serializer = UserSerializer(instance=user)
print(user_serializer.data)

```
```JSON
{
    'pk': 1,
    'username': 'test',
    'profile': {
        'pk': 1,
        'access_key': {
            'pk': 1,
            'key': 'key'
        },
        'sites': [
            {
                'pk': 1,
                'url': 'http://google.com',
            },
            {
                'pk': 2,
                'url': 'http://yahoo.com',
            },
        ],
        'avatars': [
            {
                'pk': 1,
                'image': 'image-1.png',
            },
            {
                'pk': 2,
                'image': 'image-2.png',
            },
        ],
    },
}
```
Il est également possible de transmettre des valeurs aux sérialiseurs imbriqués à partir de l'appel à la méthode *save* du sérialiseur de base. Ces *kwargs* doivent être de type *dict*. Par exemple :

```python
# user_serializer créé avec les données 'data' comme au dessus
user = user_serializer.save(
    profile={
        'access_key': {'key': 'key2'},
    },
)
print(user.profile.access_key.key)

```
>'key2'

Note: La même valeur sera utilisée pour toutes les instances imbriquées comme la valeur par défaut mais avec une priorité plus élevée.

# Dynamic Nested Serialization — Django Rest Framework

premièrement nous avons besoin d'installer un package

```shell
pip install drf-flex-fields
```

Pour définir les champs étandu, il faut ajouter un dictionnaire expandable_fields à la classe Meta du sérialiseur.
Une relation s'étend ainsi:

```shell
expandable_fields = {
 'category': CategorySerializer’
}
```

Une relation à plusieur

```shell
expandable_fields = {
 'category': (CategorySerializer’, {‘many’: True})
}
```

En suppposant que nous avons une entité product qui est en relation de plusieurs avec une entité catégori, lasérialisation se fera ainsi:

```python
from rest_flex_fields import FlexFieldsModelSerializer
from .models import Product, Category


class CategorySerializer(FlexFieldsModelSerializer):
    class Meta:
        model = Category
        fields = ['pk', 'name']


class ProductSerializer(FlexFieldsModelSerializer):
    class Meta:
        model = Product
        fields = ['pk', 'name', 'content', 'created', 'updated']
        expandable_fields = {
          'category': (CategorySerializer, {'many': True})
        }
```

Option         |       Description
---------------|-----------------------------------------------
expand         | Les champs à étendre, doivent être configurés 
               | dans le serialiseur expanadable_fileds
---------------|-----------------------------------------------
fields         | chanmps qui seront inclus, tout les autres 
               | seront exclu
---------------|-----------------------------------------------
omit           | Champs qui seront exclus; tout les autres 
               | seront inclus
---------------|----------------------------------------------
Lorsqu'on entre le lien par défaut *http://127.0.0.1:8000/product/* voici le résultat

```json
[
    {
        "pk":1,
        "name":"Mercedes-Benz",
        "content":"Mercedes-Benz began revamping its sedan lineup in 2013",
        "created":"2020-10-13",
        "updated":"2020-10-13"
    },
    {
        "pk":2,
        "name":"Mercedes-Benz CLA",
        "content":"Mercedes-Benz began revamping its sedan lineup in 2019",
        "created":"2020-10-13",
        "updated":"2020-10-13"
    }
]
```

Si l'on aimerait inclure des champs spécifique, faire ***?fields=pk,name***.
L'url est *http://127.0.0.1:8000/product/?fields=pk,name*

```json
[
    {
        "pk":1,
        "name":"Mercedes-Benz"
    }
     {
        "pk":2,
        "name":"Mercedes-Benz CLA"
    }
]
```
S'il faut ommettre des champs, faire ***?omit=content:***.
Le lien est: http://127.0.0.1:8000/product/?omit=content

```json
[
    {
        "pk":1,
        "name":"Mercedes-Benz",
        "created":"2020-10-13",
        "updated":"2020-10-13"
    },
    {
        "pk":2,
        "name":"Mercedes-Benz CLA",
        "created":"2020-10-13",
        "updated":"2020-10-13"
    }
]
```

Si l'on veut étendre la relation, faire ***?expand=category:***.
Le lien est : *http://127.0.0.1:8000/product/?expand=category*


```json
[
    {
        "pk":1,
        "name":"Mercedes-Benz",
        "content":"Mercedes-Benz began revamping its sedan lineup in 2013",
        "created":"2020-10-13",
        "updated":"2020-10-13",
        "category":[
            {
                "pk":1,
                "name":"Sedan"
            },
            {
                "pk":6,
                "name":"Full Size"
            }
        ]
    },
    {
        "pk":2,
        "name":"Mercedes-Benz CLA",
        "content":"Mercedes-Benz began revamping its sedan lineup in 2019",
        "created":"2020-10-13",
        "updated":"2020-10-13",
         "category":[
            {
                "pk":1,
                "name":"Sedan"
            },
            {
                "pk":6,
                "name":"Full Size"
            }
        ]
    }
]
```
Les options précédantes sont valable lorsque la relation est étendue. On peut vouloir juste le nom du produit et le nom de la catégory *?expand=category&fields=name,category.name*

# Testing

Pour exécuter les tests unitaires, exécutez :

```python
# Configurer l'environnement virtuel
python3 -m venv envname
source envname/bin/activate

pip install django
pip install django-rest-framework
pip install -r requirements.txt

# exécuter le test
py.test

```
>  **NOUTCHA NGAPI Jonathan**