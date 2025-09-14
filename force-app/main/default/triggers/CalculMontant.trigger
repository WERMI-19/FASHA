trigger CalculMontant on Order (before insert, before update) {
    // Parcourir toutes les commandes de la transaction
    for (Order newOrder : Trigger.new) {
        // S'assurer que les champs ne sont pas nuls pour éviter les erreurs
        Decimal totalAmount = newOrder.TotalAmount != null ? newOrder.TotalAmount : 0;
        Decimal shipmentCost = newOrder.ShipmentCost__c != null ? newOrder.ShipmentCost__c : 0;
        
        // Calculer le montant net
        newOrder.NetAmount__c = totalAmount - shipmentCost;
    }
}