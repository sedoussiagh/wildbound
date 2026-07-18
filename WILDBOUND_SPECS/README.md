# Wildbound Realms — Modular Specification Pack

Ce dossier est la source de vérité documentaire de **Wildbound Realms**. Il est
conçu pour le *spec-driven development* et pour des outils de génération de code.
Il ne suppose aucun moteur, langage ou fournisseur précis.

## Résumé du jeu

Jeu mobile 2D multijoueur tout public dans lequel chaque joueur incarne un
animal-classe personnalisable. Le monde partagé permet d’explorer, combattre au
tour par tour, socialiser, échanger et décorer une tanière. Au niveau 10, chaque
classe choisit une évolution. Une `Morphstone`, objet rare obtenu en jeu, permet
de changer de branche plus tard.

Tous les noms propres de classes, évolutions, monstres, lieux, compétences et
objets sont en anglais, quelle que soit la langue de l’interface.

## Comment utiliser ce pack

1. Toujours charger [Specification Standard](00_META/SPECIFICATION_STANDARD.md).
   Le catalogue machine/humain complet est dans le
   [Module Manifest](00_META/MODULE_MANIFEST.md).
2. Charger le module à implémenter et tous les fichiers listés dans son champ
   `depends_on`.
3. Considérer les sections `Invariants` et `Acceptance criteria` comme normatives.
4. En cas de contradiction, appliquer l’ordre de priorité défini par le standard.
5. Pour ajouter du contenu, copier un fichier de `99_TEMPLATES/` et attribuer un
   nouvel identifiant stable.

## Index des domaines

| Dossier | Contenu |
|---|---|
| `00_META` | conventions, glossaire, dépendances et gestion du changement |
| `01_PRODUCT` | vision, piliers, public, périmètre MVP |
| `02_SYSTEMS` | combat, progression, évolution, exploration, économie et social |
| `03_CLASSES` | une spécification indépendante par classe et évolution |
| `04_MONSTERS` | catalogue, familles et une spécification par monstre |
| `05_WORLD` | lore, maps, NPC et trame narrative |
| `06_CONTENT` | quêtes, objets, crafting et récompenses |
| `07_UX` | onboarding, contrôles mobiles, accessibilité et états UI |
| `08_ONLINE_SAFETY` | monde partagé, matchmaking, présence et modération |
| `09_TECHNICAL` | DAT, données, contrats réseau, sécurité et exigences qualité |
| `10_GENERATION` | brief pour générateurs, ordre d’implémentation et matrice DoD |
| `99_TEMPLATES` | modèles pour étendre le jeu sans casser les modules existants |

## Modules de contenu MVP

### Classes et évolutions

- [Wolf Guardian](03_CLASSES/wolf_guardian/CLASS.md) →
  [Iron Wolf](03_CLASSES/wolf_guardian/IRON_WOLF.md) ou
  [Shadow Wolf](03_CLASSES/wolf_guardian/SHADOW_WOLF.md)
- [Fox Mystic](03_CLASSES/fox_mystic/CLASS.md) →
  [Flame Fox](03_CLASSES/fox_mystic/FLAME_FOX.md) ou
  [Mist Fox](03_CLASSES/fox_mystic/MIST_FOX.md)
- [Bunny Healer](03_CLASSES/bunny_healer/CLASS.md) →
  [Bloom Bunny](03_CLASSES/bunny_healer/BLOOM_BUNNY.md) ou
  [Gale Bunny](03_CLASSES/bunny_healer/GALE_BUNNY.md)

### Monde

- [Oakheart Village](05_WORLD/maps/OAKHEART_VILLAGE.md)
- [Whispering Woods](05_WORLD/maps/WHISPERING_WOODS.md)
- [Moonroot Hollow](05_WORLD/maps/MOONROOT_HOLLOW.md)
- [Willow Den](05_WORLD/maps/WILLOW_DEN.md)
- [Pawstone Arena](05_WORLD/maps/PAWSTONE_ARENA.md)

### Version du pack

- Specification version : `1.0.0`
- Content version : `0.1.0`
- Protocol version : `1`
- Balance version : `1`
- MVP level cap : `20`
