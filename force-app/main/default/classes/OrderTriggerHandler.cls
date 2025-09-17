public class OrderTriggerHandler {
    /**
     * @description Gère la logique après la mise à jour d'une commande,
     * spécifiquement pour recalculer le chiffre d'affaires du compte parent.
     */
    public static void handleAfterUpdate(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {
        // 1. Prépare une map pour agréger les montants par ID de compte.
        Map<Id, Decimal> accountIdToTotalAmount = new Map<Id, Decimal>();

        // 2. Isole uniquement les commandes dont le statut vient de passer à 'Activated'.
        for (Order newOrder : newOrders) {
            Order oldOrder = oldOrdersMap.get(newOrder.Id);
            if (newOrder.Status == 'Activated' && oldOrder.Status != 'Activated') {
                Decimal currentTotal = accountIdToTotalAmount.get(newOrder.AccountId);
                // Agrège les montants pour éviter les requêtes multiples.
                if (currentTotal == null) {
                    currentTotal = 0;
                }
                accountIdToTotalAmount.put(newOrder.AccountId, currentTotal + newOrder.TotalAmount);
            }
        }

        if (!accountIdToTotalAmount.isEmpty()) {
            // 3. Récupère tous les comptes à modifier en une seule requête (bulkification).
            List<Account> accountsToUpdate = [
                SELECT Id, Chiffre_d_affaire__c 
                FROM Account 
                WHERE Id IN :accountIdToTotalAmount.keySet()
            ];

            // 4. Met à jour le champ du chiffre d'affaires sur chaque compte.
            for (Account acc : accountsToUpdate) {
                Decimal amountToAdd = accountIdToTotalAmount.get(acc.Id);
                if(acc.Chiffre_d_affaire__c == null){
                    acc.Chiffre_d_affaire__c = 0;
                }
                acc.Chiffre_d_affaire__c += amountToAdd;
            }

            // 5. Applique toutes les modifications en une seule opération DML.
            update accountsToUpdate;
        }
    }
}