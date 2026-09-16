#import "../lib.typ": answer, command, exercise, header, key, note, paragraph, textbf, ulb-practicals
#import "@zandies/assiettes:0.0.1": *

// Les paramètres de la page de garde sont définis ici
#show: ulb-practicals.with(
  title: "Introduction au C",
  authors: (
    (
      name: "Joël Goossens",
      office: "N8.107",
    ),
    (
      name: "Olivier Markowitch",
      office: "N8.106",
    ),
    (
      name: "Arnaud Leponce",
      office: "N8.213",
    ),
    (
      name: "Attilio Discepoli",
      office: "N8.210",
    ),
    (
      name: "Alexis Reynouard",
      office: "N8.215",
    ),
  ),
  course: "INFO-F-201 — Systèmes d'exploitation",
  show_solution: true,
)


= Pourquoi le C ?

== Un programme en langage machine

Imaginez que nous voulons construire un processeur simple avec trois espaces mémoires, appelés _gauche_, _droite_ et _résultat_.
On peut connecter _gauche_ et _droite_ à un circuit électronique qui fait une addition, et stocker ce résultat dans _résultat_.
Pour ajouter plus de possibilités, on connecte aussi un circuit de soustraction à _gauche_ et _droite_, puis un _sélecteur_ qui choisit, selon une commande reçue, quel résultat utiliser stocker dans _résultat_.
Par exemple: 1 demande de stocker le résultat de l'addition et 2 celui de la soustraction.
Ces numéros sont appelées opcodes (codes d’opération).
En écrivant une suite d’opcodes (convertis en binaire), on crée un programme exécutable par la machine.

== L’assembleur: rendre les programmes lisibles

Pour faciliter la programmation, au lieu d’écrire directement ces nombres binaires, on utilise un langage appelé assembleur.
On remplace les opcodes par des noms symboliques, par exemple "ADD" pour addition.
Chaque processeur a son propre langage assembleur qui correspond aux instructions qu’il comprend.
L’assembleur est simplement une couche lisible sur le code machine.
Les premiers "compilateurs" assembleur vers code machine étaient des sortes de machine à écrire.
Sur le clavier, les touches correspondait à des opérations.
Plutôt que de déposer de l'encre sur une feuille, la machine faisait des trous dans une carte perforée.
Ces trous étaient l'opcode en binaire de l'opération voulue.

== L’évolution des langages de programmation

De nombreux autres langages sont ensuite apparus, souvent spécialisés pour un matériel ou un domaine (mathématiques, physique, etc.).
Ces langages étaient trop proches du matériel ou trop abstraits, et ne permettaient pas toujours de manipuler les données et les variables avec différentes sémantiques (valeur, référence, alias, pointeur) facilement.
En 1969, le langage B a été conçu pour combiner un bon contrôle machine avec un certain niveau d’abstraction.
Puis, en 1972, Dennis Ritchie, un des deux ingénieurs de B, a créé le langage C pour réécrire le système d’exploitation Unix, alliant _lisibilité_, _efficacité_ et _portabilité_.

== Les forces du langage C

Le langage C adopte un juste niveau d’abstraction: il permet de contrôler précisément la machine tout en offrant un code clair et efficace, utilisable sur différentes architectures.
Il offre plusieurs avantages clés :

/ Sémantique flexible des variables: On peut copier une variable (sémantique de valeur) ou prendre son adresse (sémantique de pointeur), permettant ainsi plusieurs noms pour une même donnée.)
/ Types explicites: Chaque variable a un type qui détermine sa taille en mémoire et comment interpréter ses bits. Cela permet au compilateur de choisir l’instruction machine adaptée pour effectuer les opérations, ce qui n’existait pas dans B.
/ Création de types composés: Possibilité de définir des types complexes par agrégation.
/ Portabilité efficace: La taille des types principaux n’est pas rigide, ce qui permet au même code d’être compilé efficacement sur plusieurs machines.



== Le C et les systèmes d’exploitation

C est donc idéal écrire un système d'exploitation (OS).
Mais il l'est aussi pour communiquer avec l'OS.

Un OS rend le matériel accessibles via des fonctions appelées appels système.
Ces appels sont décrits précisément en termes de mémoire, indépendamment du langage, mais leur utilisation est aisée en C.
En pratique, faire un appel système en C revient souvent à appeler une petite fonction qui s’occupe de communiquer avec le noyau de l’OS.

Le code en C est souvent très proche du langage assembleur, ce qui permet d’écrire des couches logicielles très performantes et proches du matériel, tout en restant plus lisible et maintenable que l’assembleur pur.
C’est pourquoi la majorité des noyaux modernes comme Unix, Linux, macOS ou Windows sont écrits principalement en C.

= Variables, adresses et pointeurs

== Sémantique par défaut des variables

En C, lorsqu'on déclare une variable, elle contient une valeur.
Par défaut, la sémantique des variables est une _sémantique de copie_ : cela signifie que quand on affecte une variable à une autre, ou quand on passe une variable en argument à une fonction, la valeur est copiée.

#figure(
  ```c
  int a = 5;
  int b = a; // ici la valeur 5 est copiée dans b
  b = 10;    // ceci ne modifie pas a
  ```,
  caption: "Exemple de copie de variable",
)

Ainsi, modifier la variable `b` n'a pas d'effet sur `a` puisque ce sont deux emplacements mémoire différents.

== Qu'est-ce qu'une adresse ?

Une _adresse_ est un numéro unique qui identifie un emplacement en mémoire. Chaque variable occupe un certain emplacement mémoire, et on peut accéder à cet emplacement via son adresse.

On peut obtenir l'adresse d'une variable en utilisant l'opérateur `&`.
On peut aussi parler de ce qui est à une adresse avec l'opérateur `*`.

#figure(
  ```c
  int x = 3;
  printf("Adresse de x : %p\n", (void*)&x);
  *(&x) = 4; // équivalent à "x = 4"
  ```,
  caption: "Obtenir l'adresse d'un variable",
)

== Pointeurs

Un _pointeur_ est le type d'une variable qui stocke une _adresse_ mémoire.
Ou plutôt, une variable qui stocke l'adresse d'un entier doit être de type "pointeur vers un entier".
Ceci s'écrit: `int*`.
"Pointeur" et "adresse" sont donc synonyme.

Quand l'étoile `*` est utilisée après un *type* X, elle signifie: "pointeur vers X" / "adresse d'un X". C'est la déclaration d'un type. Ce n'est pas une opération. Par exemple, pointeur vers int: `int*`.

Mais quand l'étoile est utilisée avant une *adresse* Y, elle signifie: "ce qui se trouve à l'adresse Y". (On l'appelle, opérateur de déréférencement.) C'est ce qu'on a fait dans l'exemple précédent. C'est une opération.
Donc, devant un pointeur (qui est une adresse), l'étoile permet d’accéder à la valeur pointée.


#figure(
  ```c
  int y = 7;
  int *ptr = &y;    // ptr est une variable de type pointeur vers entier
  printf("%d\n", *ptr); // affiche la valeur de y (7) via son pointeur
  ```,
  caption: "Déclaration et utilisation d'un pointeur",
)

#exercise(
  [
    Partez du fichier `exo1.c` qui se trouve sur l'UV. Compilez avec `make exo1`.
    - Déclarez deux variables entières. Affectez la valeur de l’une dans l’autre. Modifiez la deuxième variable et expliquez pourquoi la première n'est pas modifiée.
    - Affichez l'adresse de chacune de ces variables.
    - Déclarez un pointeur vers une des variables et affichez la valeur de la variable à travers le pointeur.
  ],
  solution: [
    Retrouvez la solution sur l'UV.

    Dans cet exemple, on voit que la variable `b` est indépendante de `a`, car la valeur est copiée. Les adresses imprimées montrent que `a` et `b` ne partagent pas le même emplacement mémoire. Enfin, le pointeur `ptr` contient l'adresse de `a`, et le déréférencement `*ptr` permet d'accéder à sa valeur.
  ],
)

= Structure de la mémoire
Lorsque vous utilisez des variables en C, leur contenu peut se trouver dans un de ces deux endroits de la mémoire: le _heap_ ou le _stack_.

== Le stack
Conceptuellement, le _stack_, le _call stack_ ou la pile (d'exécution) en français est la structure de données qui enregistre les informations au sujet des fonctions appelées successivement. On y trouve, entre autres, les variables locales des fonctions. Chaque appel de fonction donne lieu à un nouveau _stack frame_ sur le dessus de la pile et, inversement, chaque retour de fonction donne lieu à une suppression du _stack frame_ sur le dessus de la pile. Ce procédé est illustré par du code dans le @lst:foo et visuellement dans la @fig:stack.

#figure(
  grid(
    columns: (1fr, 1fr),

    ```c
    int main() {
        int x = 3;
        int r = foo();
        return 0;
    }
    ```,
    ```c
      int foo() {
          int y = 7;
          return y - 2;
      }
    ```,
  ),
  caption: "Exemple d'appel de fonction.",
) <lst:foo>

#figure(
  align(
    center,
    grid(
      columns: (1fr, 1fr, 1fr),
      [

        #memory-stack(
          (
            memory-cell([], stroke: (left: (dash: "dashed"), right: (dash: "dashed")), height: 57pt),
            memory-cell(
              [
                ```c
                main()
                int r;
                int x = 3;
                ```
              ],
              height: 45pt,
            ),
          ),
        )
      ],
      [
        #memory-stack(
          (
            memory-cell([], stroke: (left: (dash: "dashed"), right: (dash: "dashed"))),
            memory-cell(
              [
                ```c
                foo()
                int y = 7;
                ```
              ],
              height: 35pt,
            ),
            memory-cell(
              [
                ```c
                main()
                int r;
                int x = 3;
                ```
              ],
              height: 45pt,
            ),
          ),
        )

      ],
      [
        #memory-stack(
          (
            memory-cell([], stroke: (left: (dash: "dashed"), right: (dash: "dashed")), height: 57pt),
            memory-cell(
              [
                ```c
                main()
                int r;
                int x = 3;
                ```
              ],
              height: 45pt,
            ),
          ),
        )
      ],
    ),
  ),
  caption: "Évolution de la pile lors d’appels et retours de fonction.",
  kind: image,
) <fig:stack>

Très concrètement, le _stack_ est une zone de la mémoire dans laquelle réside la structure de données décrite plus haut. Étant donné que le _stack_ enregistre les appels successifs de fonction, il est important de noter que chaque _thread_ dispose de son propre _stack_.

Une conséquence de la manière dont le _stack_ fonctionne est que les variables qui s'y trouvent ne peuvent pas changer de taille. En effet, si une variable se trouvant dans le `main` devait grandir (en nombre de bytes), il faudrait déplacer toutes les variables qui se trouvent _au dessus_, ce qui serait très coûteux. Plus encore: la taille des variables, c'est-à-dire le nombre de bytes qu'elles occupent en mémoire, est connu au moment de la compilation.

== Le heap
Le _heap_ est lui aussi une zone en mémoire dans laquelle on peut stocker des variables dont la taille peut varier au cours du temps. Le _heap_ est géré par le système d'exploitation et il est possible de lui demander de nous attribuer de la mémoire à la demande. Cette zone mémoire est attachée à un pointeur vers la zone attribuée.

Contrairement au _stack_, le _heap_ est spécifique au processus et est partagé entre ses différents threads.
// Cela signifie que deux threads peuvent accéder et modifier des variables partagées dans le _heap_, ce qui peut mener à de nombreux problèmes auxquels nous reviendrons dans de prochains TPs.

=== Allocation de mémoire dynamique
Dans le langage C, cette demande se fait à l'aide de la fonction `malloc` comme indiqué dans le Listing~@lst:malloc. Notez qu'il existe toute une famille de fonctions d'allocation de mémoire telles que `calloc` ou `realloc`. Consultez le manuel pour plus d'informations (`man malloc`).

#figure(
  ```c
    int taille;
    scanf("\%d", &taille);
    int* tableau = (int*) malloc(sizeof(int) * taille);
    if (tableau == NULL) {
        // Si malloc échoue, il retourne 0 / NULL,
        // et change la valeur de la variable globale errno pour indiquer l'erreur.
        // La fonction perror utilise errno pour indiquer l'erreur.
        perror("L'allocation de la mémoire a échoué")
        // Sur un système en anglais, la ligne ci-dessus affiche:
        //     L'allocation de la mémoire a échoué: Cannot allocate memory
        exit(1);
    }
  ```,
  caption: [Allocation dynamique avec `malloc`],
)<lst:malloc>

Remarquez qu'il est important de vérifier la validité du pointeur alloué! Si jamais l'OS renvoie `NULL`, cela signifie probablement qu'il n'a plus de mémoire disponible, auquel cas il est urgent de terminer le programme.


#exercise(
  [
    Tous les pointeurs valides pointent-ils vers le heap~? Expliquez ou donnez un contre-exemple.  ],
  solution: [
    Non. On peut prendre l'adresse d'une variable du stack en faisant `int *p = &x;`.
  ],
)
#exercise(
  [
    Sachant que sur un système à 64 bits, une adresse tient sur 64 bits. Que renvoient `sizeof(int *)`, `sizeof(char *)` et `sizeof(int **)` ?
  ],
  solution: [
    Dans tous les cas, une adresse fait 64 bits (donc 8 bytes). La réponse est donc systématiquement 8.
  ],
)

=== Libération de mémoire dynamique

Notez que dans le langage C, la mémoire allouée dynamiquement n'est pas libérée automatiquement, c'est-à-dire qu'il n'y a pas de _garbage collector_.
Par conséquent, tant que le programme tourne, la mémoire allouée n'est pas libérée, ce qui peut causer des fuites de mémoire, ou _memory leaks_.
Lorsqu'une zone mémoire n'est plus utilisée, il faut appeler la fonction `free()` qui libère la mémoire allouée.

#figure(
  ```c
    int* tableau = (int*) malloc(sizeof(int) * taille);
    if (tableau == NULL) {
        exit(1);
    }
    /* Utilisation du tableau */
    // ...
    /* Le tableau n'est plus utilisé */
    free(tableau);
  ```,
  caption: [Libération de mémoire avec `free`],
)

#exercise(
  [
    Récupérez le fichier header `list.h` sur l'UV et écrivez un fichier `list.c` qui permet de gérer une liste dynamique d'entiers. Vous devez écrire le corps des fonctions déclarées dans `list.h`. Ensuite, écrivez un `main()` qui utilise ces fonctionnalités.
  ],
  solution: [
    Retrouvez les solutions sur l'UV dans un fichier zip.
  ],
)

#header("Introduction au terminal", description: [
  Ceci est une introduction au terminal sous Linux, ainsi qu'aux notions et outils qui y sont rattachés.
  Ces outils sont spécialement prévus pour administrer facilement le système d'exploitation et les maîtriser est indispensable.
])

#note[
  La suite contient peu d'exercices.
  Vous êtes encouragés à tester tous les exemples et à réaliser des tests pour éclaircir les ambiguïtés.
]

#counter(heading).update(0)
= Le terminal et le langage bash

Sous Linux, dans une interface graphique, le *_terminal_* se lance habituellement avec #key("ctrl", "alt", "t").
Dans cette fenêtre, vous pouvez entrer des *_commandes_* qui seront interprétées par l'interpréteur.
Par exemple, #command[echo "Hello world"] est une commande.
Ces commandes sont en fait des instructions dans un langage spécial, compatible avec le langage #command[sh] (pour _shell_).
Le langage en question dépend de l'interpréteur.
Vous pouvez voir le nom de votre interpréteur avec la commande #command[echo \$0].
Dans ce cours, nous nous concentrerons sur l'interpréteur _*#command[bash]*_ et son langage (compatible avec et très proche de #command[sh]).

#note[
  Il est vivement recommandé de faire les exercices avec bash, quel que soit l'OS utilisé.
  Les exercices sont pensés pour Linux, mais devraient être réalisables avec peu de modifications sur MacOS et Windows tant que bash est utilisé.
  Les exemples présupposent parfois une installation Debian ou Ubuntu récente.
  D'autres systèmes pourront vous dire que les programmes demandés n'existent pas ou ne sont pas installés.
  En général, il existe une commande équivalente sur le système en question.
]

Une commande shell simple, comme celles données plus haut, est formée du nom d'un programme suivi de paramètres.
Le langage est ainsi défini: si l'instruction ne commence pas par un symbole particulier ou un mot-clé, alors le premier mot est un programme à exécuter et les mots suivants sont les paramètres à lui donner.
Nous y reviendrons.

Dans le terminal, la touche #key[TAB] auto-complète la commande.
S'il y a plusieurs auto-complétions possibles, il faut appuyer une deuxième fois sur #key[TAB] pour voir les propositions.
Vous pouvez aussi effacer le contenu du terminal avec #key("Ctrl", "L") ou #command[clear].

= Se déplacer -- Le répertoire courant

Exécutez #command[ls] dans le terminal.
Vous voyez une liste de fichiers et de dossiers.
Vous devez avoir remarqué que ce sont les fichiers de votre *_dossier personnel_* (ou *home (directory)*).
C'est parce que c'est le dossier de travail par défaut de votre terminal.
À tout moment, un programme possède un _*répertoire courant*_ ou *working directory* (dossier et répertoire sont synonymes).

Vous pouvez afficher le dossier courant avec #command[echo \$PWD] (print working directory).
La commande #command[cd] permet de changer le répertoire courant.
Essayez d'aller sur votre bureau avec #command[cd Bureau]#footnote[Pour les curieux, voici une façon plus stable d'aller sur le bureau: #command[which xdg-user-dir > /dev/null \&\& cd "\$(xdg-user-dir DESKTOP)" || cd Desktop]. Prenez-la pour le moment comme une formule magique, elle deviendra plus claire plus tard.].
Vérifiez que #command[ls] et #command[echo \$PWD] réagissent correctement.
Que fait #command[cd] sans paramètres?
#answer[
  Il retourne dans le dossier personnel (#command[\$HOME]).
]

= Les chemins


Les _*chemins*_ servent de noms aux fichiers, aux dossiers (qui sont des fichiers d'un type particulier) et à toutes les choses gérées par le système de fichiers.
Nous y reviendrons plus tard.

Il existe deux formes de chemins.
#command[echo \$PWD] affiche le chemin absolu du dossier courant.
Les _*chemins absolus*_ commencent par #command[/], qui est le nom du _*répertoire racine*_ (*root directory*), puis indiquent tous les dossiers à traverser pour accéder au dossier ou fichier voulu.
Par comparaison, si le système était une maison, on pourrait imaginer les chemins absolus #command[/cuisine/placard-de-gauche/2e-tiroir/] qui serait le chemin d'un dossier et #command[/cuisine/placard-de-gauche/2e-tiroir/ciseaux] qui serait le chemin d'un fichier.
Remarquez que, dans un chemin absolu, le premier "/" représente le dossier racine alors que les autres servent de séparateur entre les dossiers.
(Si le chemin finit par "/", ce dernier sert à rendre explicite qu'il s'agit du chemin d'un dossier, mais il est facultatif).

Un _*chemin relatif*_ correspond à un chemin absolu dont on a retiré le répertoire courant.
Si on me dit #command[placard-de-gauche/], je suppose qu'il s'agit du "placard de gauche" de la pièce où je suis.
On reconnaît un chemin relatif parce qu'il ne commence pas par #command[/].

Dans un chemin, _*#command[.]*_ désigne le dossier désigné à ce moment dans le chemin et _*#command[..]*_ désigne le dossier parent (celui qui contient #command[.]).
Si je suis dans #command[/home/alexis] alors #command[..] est #command[/home].

#exercise(solution: `/home/`)[
  Simplifiez le chemin #command[/home/alexis/documents/../pictures/./../../].
]

#exercise(solution: [#command[/] et #command[cd / ; cd ..; echo \$PWD].])[Quel est le dossier parent de #command[/]?
  Comment vérifier votre réponse?]

#note[Attention: s'il y a des espaces dans les chemins, il faut les _échapper_ en les faisant précéder de #command[\\] ou en les entourant de guillemets #command["] ou #command[']. De même s'il y a un de ces caractères, il faudra aussi l'échapper.]

= Les exécutables

Nous avions dit qu'une commande commence par le nom d'un programme.
Dans #command[echo Hello], le programme est #command[echo].
En réalité un programme est un fichier exécutable et il est désigné par le premier mot de la commande, c'est-à-dire tout ce qui se trouve avant la première espace non échappée.

== La définition d'un exécutable

Un exécutable est soit un programme compilé, soit un script qui est interprété par un autre programme lui-même compilé.
Un script python est interprété par le programme compilé python.
Un script bash est interprété par le programme compilé bash.

Un programme compilé est différenciable par ses premiers octets (ce système de signature est utilisé par la quasi-totalité des types de fichiers).
De même, les octets 0x23 0x21 (correspondant aux caractères "\#!") au début d'un fichier identifient un script et sont appelés _*shebang*_.
Pour exécuter un script, l'OS passe le fichier à l'interpréteur indiqué après le shebang.

Par exemple, pour un script python, on aura ```sh #!/usr/bin/python3```. Pour un script bash, on aura ```sh #!/bin/bash```.

Ceci étant dit, il faut aussi donner la permission d'exécution à l'exécutable, ce qui se fait avec #command[chmod +x fichier].

== La recherche de l'exécutable

Pour trouver le fichier, l'interpréteur procède ainsi:
+ Si le premier mot commence par #command[/], alors c'est le chemin absolu du fichier à exécuter.
+ Sinon, si le premier mot contient un #command[/], c'est un chemin relatif du fichier à exécuter.
+ Sinon, il faut chercher le fichier exécutable dans des dossiers prédéfinis qui forment le #command[\$PATH].
Ceci explique pourquoi pour exécuter #command[mon-script.py] qui se trouve dans le répertoire courant, il faut écrire #command[./mon-script.py].

Pour exécuter #command[echo Hello], l'interpréteur:
+ prend le premier mot, #command[echo]
+ reconnaît le troisième cas
+ regarde le _path_ (visible avec #command[echo \$PATH])
+ cherche #command[echo] dans chacun des dossiers indiqués dans #command[ \$PATH]

La commande #command[which] affiche justement le résultat de cette recherche.
#exercise[Essayez #command[which echo]]
// % /usr/bin/echo ou /bin/echo

*Pourquoi ne pas ajouter #command[.] au #command[\$PATH] ?*
#footnote[Cette remarque ne fait pas partie de la matière à connaître].
Cela permettrait d'écrire #command[mon-script.py] plutôt que #command[./mon-script.py].

C'est tout à fait envisageable, mais, dans un système utilisé par plusieurs personnes, avoir le dossier courant dans son #command[\$PATH] représente un risque de sécurité.
// Pour le faire, il faut que #command[\$PATH] contienne #command[.] ou un chemin vide.
// Ainsi, si #command[\$PATH] commence ou finit par #command[:], contient #command[::], commence par #command[.:], finit par #command[:.] ou contient #command[:.:], alors bash cherchera aussi dans le dossier courant les exécutables disponibles.

En pratique, il faut exécuter #command[echo \"export PATH+=\$PATH:.\" >> \~/.bashrc \&\& source \~/.bashrc].
La liste des commandes disponibles changent désormais avec le répertoire actuel.
Il faut donc être davantage prudent pour ne pas lancer par erreur un mauvais programme.


#pagebreak()
= Quelques utilitaires

Nous allons voir quelques utilitaires de base pour le travail en terminal.

#paragraph[cd] change le répertoire courant (_*c*hange *d*irectory_).
#command[cd "chemin"] va dans #command[chemin].
#command[cd] seul revient dans le _home directory_.
#command[cd] n'est pas un exécutable comme les autres mais une commande spéciale directement reconnue et exécutée par bash.

#paragraph[pwd] affiche le dossier courant.


#paragraph[echo] affiche tout ce qu'on lui donne.
Pour exécuter #command[echo \$PWD], bash _substitue_ la variable #command[PWD] par son contenu et passe le contenu comme paramètre(s) à #command[echo].
Ce n'est pas #command[echo] qui remplace la variable par son contenu.

#paragraph[mkdir] crée un dossier.
#command[mkdir foo] crée un dossier appelé "foo" dans le dossier courant.

#paragraph[rmdir] supprime un dossier.
#command[rmdir foo] supprime le dossier appelé "foo" dans le dossier courant, si celui-ci est vide (pratique pour éviter les erreurs).

#paragraph[touch] crée un fichier.
#command[touch foo] crée un fichier vide appelé "foo" dans le dossier courant.
Si ce fichier existe, cela change la date de dernière modification (le *ctime*).

#paragraph[rm] supprime un fichier ou un dossier.

#command[rm -r foo] supprime le fichier ou le dossier "foo" dans le dossier courant. Si "foo" est un dossier, tout le contenu est supprimé. L'option #command[-i] demande confirmation avant suppression.\ *Attention*, `rm` ne passe pas par la corbeille!

#paragraph[mv, cp] déplace ou copie un fichier ou un dossier.
#command[mv a b] renomme le fichier (ou dossier) "a" en "b".
#command[mv documents/a images/] déplace le fichier (ou dossier) "documents/a" et le met dans "images/".
#command[mv documents/a images/b] déplace et renomme le fichier (ou dossier) “documents/a” en “images/b”...
Vous avez compris: renommer et déplacer sont la même chose pour le système.
Attention, si la destination d'un déplacement existe déjà, celle-ci est remplacée (donc perdue).
L'option #command[-i] demande confirmation avant d'écraser (c'est le terme pour dire “remplacer”) quelque chose.

#command[cp a b] fonctionne comme #command[mv a b] mais copie au lieu de déplacer.
Si “a” est un dossier, il faut utiliser l'option #command[-r] _(recursive)_.

#paragraph[cat, less, more] affichent le contenu d'un fichier.
#command[cat fichier] affiche le contenu dans la console.
#command[less fichier] et #command[more fichier] sont des *pagers*, ces programmes permettent de naviguer dans le fichier.
Ils sont spécialement utiles dans les consoles qui ne possèdent pas de barre de défilement.
Les _pagers_ permettent de chercher (vers le bas) avec #command[/], de revenir en haut avec #command[g] et de quitter avec #command[q].

#paragraph[head, tail] affichent une partie d'un fichier.
#command[head fichier] affiche le début du fichier.
#command[tail fichier] affiche la fin. L'option #command[-n <n>] permet d'indiquer combien de lignes afficher.

#paragraph[grep, sed, awk, cut] sont des utilitaires très pratiques pour travailler avec du texte.
#command[grep 'regex' fichier] affiche les lignes du fichier qui correspondent à l'expression régulière #command[regex].

#paragraph[man, apropos] affichent de l'aide sur les commandes.
#command[man echo] affiche l'aide sur #command[echo] et #command[man man] affiche l'aide sur #command[man].
Le #textbf[man]uel est divisé en sections.
#command[man 1 printf] affiche le manuel de la commande #command[printf] alors que #command[man 3 printf] affiche le manuel de la fonction C #command[printf].
Les commandes se trouvent dans les sections 1 et 8.

La commande #command[apropos foo] affiche les commandes dont la description mentionne "foo".

#paragraph[nano] est un éditeur de texte en console.
Vous pouvez aussi lancer un éditeur graphique depuis la console.
Avec gnome, essayez #command[gedit].
Avec mate, essayez #command[pluma].
Avec Cinnamon, essayez #command[xed].

#paragraph[xdg-open] permet d'ouvrir un fichier avec le programme par défaut.

#exercise[
  Essayez #command[xdg-open fichier] avec différents fichiers, puis #command[xdg-open https://duckduckgo.com] et #command[xdg-open mailto:user\@mail.com].
]
