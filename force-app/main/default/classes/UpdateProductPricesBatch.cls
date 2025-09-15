global class UpdateProductPricesBatch implements Database.Batchable<sObject> {

    // La méthode start récupère toutes les entrées du catalogue de prix standard
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, UnitPrice 
            FROM PricebookEntry 
            WHERE Pricebook2Id = :Test.getStandardPricebookId() AND IsActive = true
        ]);
    }

    // La méthode execute applique la nouvelle logique de prix
    global void execute(Database.BatchableContext bc, List<PricebookEntry> scope) {
        List<PricebookEntry> entriesToUpdate = new List<PricebookEntry>();
        for (PricebookEntry pbe : scope) {
            // Logique de mise à jour : ici, on augmente le prix de 10%
            Decimal newPrice = pbe.UnitPrice * 1.10;
            pbe.UnitPrice = newPrice;
            entriesToUpdate.add(pbe);
        }
        
        if (!entriesToUpdate.isEmpty()) {
            update entriesToUpdate;
        }
    }

    global void finish(Database.BatchableContext bc) {
        // Envoyer un email pour confirmer que la mise à jour des prix est terminée
        System.debug('La mise à jour hebdomadaire des prix est terminée.');
    }
}