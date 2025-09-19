
-----

# Projet Fasha : Optimisation d'une Organisation Salesforce

Ce projet vise à améliorer une organisation Salesforce existante pour l'entreprise Fasha. L'objectif était de résoudre des problèmes de performance, de corriger des bugs, de refactoriser le code pour suivre les bonnes pratiques, et de mettre en place une chaîne d'intégration et de déploiement continus (CI/CD).

## Fonctionnalités et Améliorations

Ce projet inclut les améliorations suivantes par rapport à l'organisation initiale :

  * **Correction de Bugs** : Résolution des erreurs critiques dans les triggers, notamment les problèmes de "bulkification" (traitement en masse).
  * **Refactoring du Code** : Application des meilleures pratiques de développement Salesforce, telles que le pattern "Trigger Handler", des conventions de nommage claires et une usine de données de test (`TestDataFactory`).
  * **Optimisation des Performances** : Remplacement des processus lents par des Batchs Apex optimisés pour le traitement de grands volumes de données.
  * **Automatisation** : Mise en place de Schedulers Apex pour l'exécution automatique des batchs et d'un pipeline CI/CD complet avec GitHub Actions.
  * **Composant LWC Amélioré** : Correction et amélioration du composant `accountOrdersSummary` pour un affichage dynamique et fiable des données(Ciffre d'Affaire).

## Structure du Projet

L'architecture du code a été organisée pour séparer les responsabilités et améliorer la maintenabilité.

  * `OrderTrigger.trigger` (Point d'entrée unique pour toutes les logiques sur l'objet `Order`, qui appelle ensuite le handler).
  * **Classes Principales** :
      * `OrderTriggerHandler.cls` (Contient la logique métier exécutée lors des mises à jour sur les commandes).
      * `OrdersController.cls` (Fournit les données au composant LWC `accountOrdersSummary`).
  * **Batchs (Traitement en masse)** :
      * `UpdateAccountsBatch.cls` (Recalcule le chiffre d'affaires de tous les comptes de manière performante).
      * `UpdateProductPricesBatch.cls` (Met à jour les prix des produits de manière hebdomadaire).
  * **Planification (Scheduler)** :
      * `ScheduleUpdateAccounts.cls` (Planifie l'exécution hebdomadaire du batch `UpdateAccountsBatch`).
      * `ScheduleUpdateProductPrices.cls` (Planifie l'exécution hebdomadaire du batch `UpdateProductPricesBatch`).
  * **Tests** :
      * `TestDataFactory.cls` (Classe utilitaire centrale pour créer les données de test).
      * `*Test.cls` (Chaque classe possède sa propre classe de test dédiée, assurant une couverture de code élevée).

## Prérequis

  * Un compte Salesforce (Developer Edition ou Sandbox).
  * [Git](https://git-scm.com/) installé sur votre machine.
  * [Salesforce CLI (sf)](https://developer.salesforce.com/tools/sfdxcli) installée.

## Installation et Déploiement

**1. Cloner le dépôt**

```bash
git clone https://github.com/WERMI-19/FASHA.git
cd FASHA
```

**2. Connexion à votre environnement Salesforce**
Utilisez la Salesforce CLI pour autoriser votre organisation :

```bash
sf org login web --alias FashaOrg
```

**3. Déployer le projet sur Salesforce**
Cette commande déploie l'ensemble du projet et exécute tous les tests Apex pour valider le déploiement.

```bash
sf project deploy start --test-level RunLocalTests
```

## Commandes Utiles

  * **Vérifier les détails de l'organisation** :
    Pour obtenir des informations sur votre org, y compris la `Sfdx Auth Url` nécessaire pour la configuration du CI/CD.

    ```bash
    sf org display --verbose
    ```

  * **Exécuter tous les tests locaux** :

    ```bash
    sf apex run test --test-level RunLocalTests
    ```

## CI/CD - Intégration et Déploiement Continus

Ce projet est équipé d'un pipeline CI/CD utilisant **GitHub Actions**, configuré dans le fichier `.github/workflows/main_deploy.yml`.

Le pipeline se déclenche automatiquement :

1.  **À la création d'une Pull Request** vers la branche `main` pour valider la syntaxe et l'authentification.
2.  **À la fusion (merge) dans `main`** pour lancer un déploiement complet, incluant l'exécution de tous les tests Apex.

Pour que le pipeline fonctionne, le secret `SF_AUTH_URL` doit être configuré dans les paramètres du dépôt GitHub.