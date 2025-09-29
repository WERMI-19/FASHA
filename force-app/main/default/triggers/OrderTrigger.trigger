trigger OrderTrigger on Order (before insert, before update, after insert, after update) { // NOPMD

    // --- Logique BEFORE ---
    // S'exécute avant la sauvegarde en base de données
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            // Ancien trigger "CalculMontant"
            for (Order newOrder : Trigger.new) {
                Decimal totalAmount = newOrder.TotalAmount != null ? newOrder.TotalAmount : 0;
                Decimal shipmentCost = newOrder.ShipmentCost__c != null ? newOrder.ShipmentCost__c : 0;
                newOrder.NetAmount__c = totalAmount - shipmentCost;
            }
        }
    }

    // --- Logique AFTER ---
    // S'exécute après la sauvegarde en base de données
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            // Ancien trigger "UpdateAccountCA"
            OrderTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}