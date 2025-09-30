/**
 * @description Handler pour les triggers de commandes.
 * Gère le recalcul du chiffre d'affaires sur les comptes parents
 * lorsque des commandes sont activées, modifiées ou désactivées.
 */
public with sharing class OrderTriggerHandler {

    /**
     * @description Gère la logique après la mise à jour d'une commande.
     * Identifie les comptes nécessitant un recalcul et délègue à la méthode recalculateRevenue.
     * @param newOrders Liste des nouvelles versions des commandes
     * @param oldOrdersMap Map des anciennes versions des commandes
     */
    public static void handleAfterUpdate(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {
        // 1. Collecter les Ids des comptes qui ont besoin d'un recalcul
        Set<Id> accountIdsToRecalculate = new Set<Id>();
        for (Order newOrder : newOrders) {
            Order oldOrder = oldOrdersMap.get(newOrder.Id);
            // On recalcule si :
            // - le montant total change sur une commande qui est déjà 'Activated'
            if ( (newOrder.Status == 'Activated' && oldOrder.Status != 'Activated') ||
                 (newOrder.Status != 'Activated' && oldOrder.Status == 'Activated') ||
                 (newOrder.Status == 'Activated' && newOrder.TotalAmount != oldOrder.TotalAmount) )
            {
                // On ajoute l'ID du compte à la liste des comptes à traiter
                accountIdsToRecalculate.add(newOrder.AccountId);
            }
        }

        // 2. Si des comptes sont à recalculer, on appelle la méthode robuste
        if (!accountIdsToRecalculate.isEmpty()) {
            recalculateRevenue(accountIdsToRecalculate);
        }
    }

    /**
     * @description Recalcule le chiffre d'affaires total pour un ensemble de comptes.
     * Cette méthode est la source de vérité pour le CA : elle somme TOUTES les commandes
     * activées pour chaque compte et met à jour le champ correspondant.
     * @param accountIds Set des IDs de comptes à recalculer
     */
    public static void recalculateRevenue(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        // On s'assure que l'utilisateur a les droits de lire les commandes
        if (!Schema.sObjectType.Order.isAccessible()) {
            throw new System.SecurityException('Insufficient permissions to access Order records.');
        }
        // 1. Agrégation de TOUTES les commandes activées pour les comptes concernés
        Map<Id, Decimal> accountTotalMap = new Map<Id, Decimal>();
        for (AggregateResult ar : [
            SELECT AccountId, SUM(TotalAmount) totalRevenue
            FROM Order
            WHERE AccountId IN :accountIds AND Status = 'Activated'
            GROUP BY AccountId
        ]) {
            accountTotalMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('totalRevenue'));
        }

        // 2. Préparation de la liste des comptes à mettre à jour
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            // On récupère le total calculé. S'il n'y a aucune commande activée, le total est 0.
            Decimal totalRevenue = accountTotalMap.containsKey(accountId) ? accountTotalMap.get(accountId) : 0;
            accountsToUpdate.add(new Account(
                Id = accountId,
                Chiffre_d_affaire__c = totalRevenue
            ));
        }

        // 3. Mise à jour des comptes en base de données (si la liste n'est pas vide)
        if (!accountsToUpdate.isEmpty()) {
             // On s'assure que l'utilisateur a les droits de modifier les comptes
            if (!Schema.sObjectType.Account.isUpdateable()) {
                throw new System.SecurityException('Insufficient permissions to update Account records.');
            }
            update accountsToUpdate;
        }
    }
}