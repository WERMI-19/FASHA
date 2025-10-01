/**
 * Service métier pour la gestion des comptes
 */
public class AccountService {

    /**
     * Recalcule le chiffre d'affaires basé sur les commandes activées
     * @param accountIds IDs des comptes à mettre à jour
     */
    public static void recalculateRevenue(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) return;

        List<Account> accountsToUpdate = new List<Account>();
        
        // Récupère le total des commandes activées par compte
        Map<Id, Decimal> revenueMap = new Map<Id, Decimal>();
        for (AggregateResult ar : [SELECT AccountId, SUM(TotalAmount) total 
                                   FROM Order 
                                   WHERE AccountId IN :accountIds AND Status = 'Activated' 
                                   GROUP BY AccountId]) {
            revenueMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('total'));
        }
        
        // Prépare les mises à jour - 0 si pas de commandes
        for (Id accId : accountIds) {
            Decimal revenue = revenueMap.get(accId) != null ? revenueMap.get(accId) : 0;
            accountsToUpdate.add(new Account(Id = accId, Chiffre_d_affaire__c = revenue));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}