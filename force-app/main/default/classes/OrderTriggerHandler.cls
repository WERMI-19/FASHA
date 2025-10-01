/**
 * Handler pour le trigger Order - gestion des calculs métier
 */
public class OrderTriggerHandler {

    /**
     * Calcule le montant net avant insertion ou mise à jour
     */
    public static void handleBeforeInsertUpdate(List<Order> newOrders) {
        for (Order newOrder : newOrders) {
            Decimal totalAmount = newOrder.TotalAmount != null ? newOrder.TotalAmount : 0;
            Decimal shipmentCost = newOrder.ShipmentCost__c != null ? newOrder.ShipmentCost__c : 0;
            newOrder.NetAmount__c = totalAmount - shipmentCost;
        }
    }

    /**
     * Déclenche le recalcul du CA quand une commande est activée
     */
    public static void handleAfterUpdate(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {
        Set<Id> accountsToRecalculate = new Set<Id>();

        for (Order newOrder : newOrders) {
            Order oldOrder = oldOrdersMap.get(newOrder.Id);
            // Recalcul du CA uniquement si la commande vient d'être activée
            if (newOrder.Status == 'Activated' && oldOrder.Status != 'Activated') {
                accountsToRecalculate.add(newOrder.AccountId);
            }
        }
        
        if (!accountsToRecalculate.isEmpty()) {
            AccountService.recalculateRevenue(accountsToRecalculate);
        }
    }
}