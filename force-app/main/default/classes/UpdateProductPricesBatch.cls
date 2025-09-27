global class UpdateProductPricesBatch implements Database.Batchable<sObject> {

    // Propriété pour stocker l'ID du catalogue de prix
    private final Id pricebookId;

    // Constructeur qui reçoit l'ID lors de la création du batch
    global UpdateProductPricesBatch(Id standardPricebookId) {
        this.pricebookId = standardPricebookId;
    }

    // La méthode start utilise l'ID stocké
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND IsActive = true';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<PricebookEntry> scope) {
        List<PricebookEntry> entriesToUpdate = new List<PricebookEntry>();
        for (PricebookEntry pbe : scope) {
            Decimal newPrice = pbe.UnitPrice * 1.10;
            pbe.UnitPrice = newPrice;
            entriesToUpdate.add(pbe);
        }
        
        if (!entriesToUpdate.isEmpty()) {
            update entriesToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('La mise à jour hebdomadaire des prix est terminée.');
    }
}