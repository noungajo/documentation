# bash shell

ces fichiers propose du code bash pour teester les endpoints d'une API de e-commerce. Elle permet d'exécuter les endpoints ci-dessous:
- login
- choix d'un article
- création d'un panier
- ajout de l'article au panier
- adressage du panier
- selection de la methode de paiement
- selection de la methode de livraison
- finalisation de la commande
> NB: le modèle utilisé ici est Sylius.

## Observation
- dans sylius, le produit permet de déterminer le type de livraison : domicile ou point de retrais
- l'adresse par defaut, détermine où sera livré le produit : douala ou yaoundé
- lorsqu'on ajoute un produit au panier, ça détermine si la commande sera livrée à domicile ou à un point de retrait. c'est après l'adressage de la commande que l'utilisateur est informé sur la localisation de livraison.
- la méthode de paiement ne dépend pas de la commande. lorsque la commande est adressée, la méthode de paiement fournie est juste un objet instancié qui sera modifié. il va falloir fournir toutes les méthodes de paiement pris en charge par l'application et l'utilisateur fera son choix. En fournissant le code de la méthode de paiement parmis celles qui existent et en maintenant l'id de la méthode de paiement qui est dans la commande.
- la notion de street et city sont deux notions conjoinctes, la source de données sera fournie par le endpoint qui présente toutes les zones.
