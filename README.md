
-----

# **Projet Fasha : Optimisation d'une Organisation Salesforce**

Ce projet vise à améliorer une organisation Salesforce existante pour l'entreprise Fasha. L'objectif était de résoudre des problèmes de performance, de corriger des bugs, de refactoriser le code pour suivre les bonnes pratiques, et de mettre en place une chaîne d'intégration et de déploiement continus (CI/CD).

## **Fonctionnalités et Améliorations**

  * **Correction de Bugs** : Résolution des erreurs critiques dans les triggers, notamment les problèmes de "bulkification" (traitement en masse).
  * **Refactoring du Code** : Application des meilleures pratiques (Trigger Handler, Service Layer, conventions de nommage, `TestDataFactory`).
  * **Optimisation des Performances** : Remplacement des processus lents par un Batch Apex optimisé.
  * **Automatisation** : Mise en place d'un Scheduler Apex pour l'exécution automatique du batch et d'un pipeline CI/CD complet avec GitHub Actions.
  * **Composant LWC Amélioré** : Correction du composant `accountOrdersSummary` pour un affichage dynamique et fiable du Chiffre d'Affaires.

## **Structure du Projet**

L'architecture du code a été organisée en couches pour séparer les responsabilités :

  * `OrderTrigger.trigger` (Point d'entrée unique qui délègue la logique).
  * **Classes de Logique** :
      * `OrderTriggerHandler.cls` (Orchestre la logique en réponse aux événements sur les commandes).
      * `AccountService.cls` (Classe de service centrale contenant la logique réutilisable de calcul du chiffre d'affaires).
      * `OrdersController.cls` (Fournit les données au composant LWC).
  * **Batch (Traitement en masse)** :
      * `UpdateAccountsBatch.cls` (Recalcule le chiffre d'affaires de tous les comptes de manière performante en appelant `AccountService`).
  * **Planification (Scheduler)** :
      * `ScheduleUpdateAccountsBatch.cls` (Planifie l'exécution hebdomadaire du batch).
  * **Tests** :
      * `TestDataFactory.cls` (Usine centrale pour créer les données de test).
      * `*Test.cls` (Chaque classe possède sa propre classe de test dédiée).

## **Prérequis**

  * Un compte Salesforce (Developer Edition ou Sandbox).
  * [Git](https://git-scm.com/) installé sur votre machine.
  * [Salesforce CLI (sf)](https://developer.salesforce.com/tools/sfdxcli) installée.

## **Installation et Déploiement**

**1. Cloner le dépôt**

```bash
git clone https://github.com/WERMI-19/FASHA.git
cd FASHA
```

**2. Connexion à votre environnement Salesforce**

```bash
sf org login web --alias FashaOrg --set-default
```

**3. Déployer le projet sur Salesforce**
Cette commande déploie l'ensemble du projet et exécute tous les tests Apex.

```bash
sf project deploy start --test-level RunLocalTests
```

## **Commandes Salesforce CLI (sf) Utiles**

  * **Ouvrir votre organisation par défaut** :

    ```bash
    sf org open
    ```

  * **Obtenir l'URL d'authentification pour le CI/CD** :

    ```bash
    sf org display --verbose
    ```

  * **Exécuter tous les tests** :

    ```bash
    sf apex run test --test-level RunLocalTests
    ```

  * **Exécuter une seule classe de test** :

    ```bash
    sf apex run test --class-names OrderTriggerHandlerTest
    ```

  * **Voir les logs de débogage en temps réel** :

    ```bash
    sf apex tail log
    ```

## **Exemples de Requêtes SOQL**

Ces requêtes peuvent être exécutées dans l'onglet **"Query Editor"** de la Developer Console.

  * **Suivre l'exécution d'un Batch (`AsyncApexJob`)** :
    Pour voir le statut, le nombre de lots et les erreurs d'un job.

    ```sql
    SELECT Id, Status, JobType, ApexClass.Name, JobItemsProcessed, TotalJobItems, NumberOfErrors, ExtendedStatus
    FROM AsyncApexJob
    WHERE ApexClass.Name = 'UpdateAccountsBatch'
    ORDER BY CreatedDate DESC
    LIMIT 5
    ```

  * **Vérifier les jobs planifiés (`CronTrigger`)** :
    Pour voir les Schedulers qui sont configurés pour s'exécuter.

    ```sql
    SELECT Id, CronJobDetail.Name, NextFireTime, CronExpression
    FROM CronTrigger
    ORDER BY NextFireTime ASC
    ```

    *Détail du **Cron Expression** (`0 0 3 ? * SUN`) : Secondes, Minutes, Heures, Jour du mois, Mois, Jour de la semaine.*

  * **Exemple de Requête Aggrégée** :
    C'est le cœur de l'optimisation. Cette requête calcule la somme des montants par compte.

    ```sql
    SELECT AccountId, SUM(TotalAmount) total
    FROM Order
    WHERE Status = 'Activated'
    GROUP BY AccountId
    ```

  * **Vérifier les insertions (après Data Loader)** :
    Pour compter les commandes importées pour un compte spécifique.

    ```sql
    SELECT COUNT(Id)
    FROM Order
    WHERE AccountId = 'ID_DU_COMPTE' AND Name LIKE 'Commande Test Data Loader %'
    ```

  * **Vérifier la logique du Trigger (before insert)** :
    Pour vérifier que le champ `NetAmount__c` a bien été calculé à l'insertion.

    ```sql
    SELECT Name, Status, TotalAmount, ShipmentCost__c, NetAmount__c
    FROM Order
    WHERE AccountId = 'ID_DU_COMPTE'
    ORDER BY CreatedDate DESC
    LIMIT 5
    ```

## **CI/CD - Intégration et Déploiement Continus**

Ce projet utilise **GitHub Actions** pour automatiser les déploiements. Le workflow est défini dans `.github/workflows/main_deploy.yml`. Le pipeline se déclenche à chaque `push` sur la branche `main` et exécute tous les tests avant de déployer, garantissant ainsi la qualité du code. Pour qu'il fonctionne, le secret `SF_AUTH_URL` doit être configuré dans les paramètres du dépôt GitHub.