/**
 * Service métier pour la gestion des comptes
 */
public class AccountService {

    /**
     * Recalcule le chiffre d'affaires basé sur les commandes activées
     */
    public static void recalculateRevenue(Set<Id> accountIds) {
        OrderTriggerHandler.metrics.startTimer('recalculateRevenue');
        OrderTriggerHandler.metrics.incrementCounter('accountsProcessed', accountIds.size());
        
        if (accountIds == null || accountIds.isEmpty()) {
            OrderTriggerHandler.metrics.stopTimer('recalculateRevenue');
            return;
        }

        List<Account> accountsToUpdate = new List<Account>();
        
        // Mesure de la requête SOQL
        OrderTriggerHandler.metrics.startTimer('SOQL_Aggregate');
        Map<Id, Decimal> revenueMap = new Map<Id, Decimal>();
        for (AggregateResult ar : [SELECT AccountId, SUM(TotalAmount) total 
                                   FROM Order 
                                   WHERE AccountId IN :accountIds AND Status = 'Activated' 
                                   GROUP BY AccountId]) {
            revenueMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('total'));
        }
        OrderTriggerHandler.metrics.stopTimer('SOQL_Aggregate');
        
        // Mesure du traitement des données
        OrderTriggerHandler.metrics.startTimer('dataProcessing');
        for (Id accId : accountIds) {
            Decimal revenue = revenueMap.get(accId) != null ? revenueMap.get(accId) : 0;
            accountsToUpdate.add(new Account(Id = accId, Chiffre_d_affaire__c = revenue));
        }
        OrderTriggerHandler.metrics.stopTimer('dataProcessing');

        // Mesure de l'opération DML
        if (!accountsToUpdate.isEmpty()) {
            OrderTriggerHandler.metrics.startTimer('DML_Update');
            OrderTriggerHandler.metrics.incrementCounter('DML_Statements');
            OrderTriggerHandler.metrics.incrementCounter('recordsUpdated', accountsToUpdate.size());
            update accountsToUpdate;
            OrderTriggerHandler.metrics.stopTimer('DML_Update');
        }
        
        OrderTriggerHandler.metrics.stopTimer('recalculateRevenue');
    }
}