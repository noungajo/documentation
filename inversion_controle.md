# Principe de l'inversionde contrôle ou injections des dépendances

Cela permet de comprendre comment créer une application fermée à la modification(si l'application évolue il ne faut pas changer le code source) et ouverte à l'extension. Pour cela il va falloir utiliser la notin de couplage faible.

## Couplage  fort et couplage faible

### Couplage fort

- Quand une classe A est liée à une classe B, on dit que la classe A est fortement couplée à la classe B.
- La classe A ne peut fonctionner qu'en présence de la classe B.
- Si une nouvelle version de la classe B(soit B2) est crée, on est obligé de modifier dans la classe A.
- Modifier une classe implique : 
   * Il faut disposer du code source.
   * Il faut recompiler, déployer et distribuer la nouvelle application aux clients.
   * Ce qui engendre un cauchemar au niveau de la maintenance de l'application.

> Problème : il réduit la flexibilité et la réutilisation du code

*Exemple :*
```java
class Moteur {
   public int puissance = 0;
   
   public int getPuissance() {
      return puissance;
   }
   public void setPuissance(int p) {
         puissance = p;
   }
}
public class Voiture {
   public static void main(String[] args) {
      Moteur obj = new Moteur();
      obj.puissance = 255; //cela provoque un couplage fort.
      System.out.println("La puissance du moteur est : " + obj.puissance);
   }
}
```
Dans l’exemple ci-dessus, le code utilise un couplage fort car la classe « Voiture » connaît les détails de la classe « Moteur », si la classe « Moteur » change la variable « puissance » en private, donc la classe « Voiture » sera brisée.

### Couplage faible

- Pour utiliser le couplage faible, nous devons utiliser les interfaces.
- Considérons une classe A qui implémenter une interface IA, et une classe B qui implémenter une interface IB.
- Si la classe A est liée à l'interface IB par une association, on dit que la classe A et la classe B sont liées par couplage faible.
- Cela signifie que la classe B peut fonctionner avec n'importe quelle classe qui implémente l'interface IA.
- En effet la classe B ne connait que l'interface IA. De ce fait n'importe quelle classe implémentant cette interface peut être associée à la classe B, sans qu'il soit nécessaire de modifier quoi que se soit dans la classe B.
- Avec le couplage faible, nous pourrons créer des applications fermées à la modification et ouvertes à l'extension.

![](scénario.png)

Au lieu de relier la classe AImpl à la classe BImpl on utilise une interface IB. Et la classe BImpl implémente l'interface IB. Ainsi elle va redéfinir les méthodes de l'interface (une version de ses méthodes). Lorsqu'une classe est liée à une interface c'est un couplage faible. Donc la classe AImpl peut implémenter n'importe quelle classe qui implémente l'interface IB. Donc s'il y a une nouvelle version, on va créer une nouvelle classe B2 qui implémente la même interface IB. et dans B2 il y aura une nouvelle définition des méthodes de l'interface IB sans eptre obligé d'apporter de modification dans la classe AImpl. C'est la notion de fermée à la modification et ouvert à l'extention(c'est créer une nouvelle classe qui implémente une interface). Donc la classe B2 qui implémente l'inetrface IB est une extention.
> Problème : à un moment donné il faut choisir qui appeler entre la classe BImpl ou B2. Cela va être règlé par ce qu'on appelle l'injection des dépendances.
> Une interface est une classe abstraite dans laquelle il n'y a que la signature des méthodes abstraites. Une classe abstraite est ue classe qui ne contient que des méthodes abstraites et ne peut être instanciée, cependant elle peut être étendue par des classes non abstraites.
> Avantage : permet de réduire les indépendances enrte les composants d'un système dans le but de réduire le risque que les changements dans un composant nécessitent des changements dans tout autre composant. Il est destiné à augmenter la flexibilité du système, à le rendre plus maintenanble et à rendre l'ensemble du framework plus stable.

*Exemple :*
```java
class Moteur {
   public int puissance = 0;
   
   public int getPuissance() {
      return puissance;
   }
   public void setPuissance(int p) {
         puissance = p;
   }
}
public class Voiture {
   public static void main(String[] args) {
      Moteur obj = new Moteur();
      obj.setPuissance(255); 
      System.out.println("La puissance du moteur est : " + obj.getPuissance());
   }
}
```

Dans l’exemple ci-dessus, le code utilise un couplage faible et est recommandé car la classe « Voiture » doit passer par la classe « Moteur » pour obtenir son état où les règles sont appliquées. Si la classe « Moteur » est modifiée en interne, la classe « Voiture » ne se brisera pas, car elle utilise uniquement la classe « Moteur » comme un moyen de communication.

### Injection des dépendances

