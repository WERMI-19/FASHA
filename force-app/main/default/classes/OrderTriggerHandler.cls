/**
 * Handler pour le trigger Order - gestion des calculs métier
 */
public class OrderTriggerHandler {
    
    // Variables de performance
    public static PerformanceMetrics metrics = new PerformanceMetrics();

    /**
     * Calcule le montant net avant insertion ou mise à jour
     */
    public static void handleBeforeInsertUpdate(List<Order> newOrders) {
        metrics.startTimer('handleBeforeInsertUpdate');
        
        for (Order newOrder : newOrders) {
            Decimal totalAmount = newOrder.TotalAmount != null ? newOrder.TotalAmount : 0;
            Decimal shipmentCost = newOrder.ShipmentCost__c != null ? newOrder.ShipmentCost__c : 0;
            newOrder.NetAmount__c = totalAmount - shipmentCost;
        }
        
        metrics.stopTimer('handleBeforeInsertUpdate');
        metrics.logPerformance();
    }

    /**
     * Déclenche le recalcul du CA quand une commande est activée
     */
    public static void handleAfterUpdate(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {
        metrics.startTimer('handleAfterUpdate');
        
        Set<Id> accountsToRecalculate = new Set<Id>();

        for (Order newOrder : newOrders) {
            Order oldOrder = oldOrdersMap.get(newOrder.Id);
            if (newOrder.Status == 'Activated' && oldOrder.Status != 'Activated') {
                accountsToRecalculate.add(newOrder.AccountId);
            }
        }
        
        if (!accountsToRecalculate.isEmpty()) {
            metrics.startTimer('recalculateRevenue');
            AccountService.recalculateRevenue(accountsToRecalculate);
            metrics.stopTimer('recalculateRevenue');
        }
        
        metrics.stopTimer('handleAfterUpdate');
        metrics.logPerformance();
    }
}