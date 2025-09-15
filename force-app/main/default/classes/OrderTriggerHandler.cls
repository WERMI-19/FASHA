public class OrderTriggerHandler {
    public static void handleAfterUpdate(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {
        Map<Id, Decimal> accountIdToTotalAmount = new Map<Id, Decimal>();

        // traite que les commandes dont le statut passe à 'Activated'
        for (Order newOrder : newOrders) {
            Order oldOrder = oldOrdersMap.get(newOrder.Id);
            if (newOrder.Status == 'Activated' && oldOrder.Status != 'Activated') {
                if (accountIdToTotalAmount.containsKey(newOrder.AccountId)) {
                    Decimal currentTotal = accountIdToTotalAmount.get(newOrder.AccountId);
                    accountIdToTotalAmount.put(newOrder.AccountId, currentTotal + newOrder.TotalAmount);
                } else {
                    accountIdToTotalAmount.put(newOrder.AccountId, newOrder.TotalAmount);
                }
            }
        }

        if (!accountIdToTotalAmount.isEmpty()) {
            List<Account> accountsToUpdate = [
                SELECT Id, Chiffre_d_affaire__c 
                FROM Account 
                WHERE Id IN :accountIdToTotalAmount.keySet()
            ];

            for (Account acc : accountsToUpdate) {
                Decimal amountToAdd = accountIdToTotalAmount.get(acc.Id);
                if(acc.Chiffre_d_affaire__c == null){
                    acc.Chiffre_d_affaire__c = 0;
                }
                acc.Chiffre_d_affaire__c += amountToAdd;
            }

            update accountsToUpdate;
        }
    }
}