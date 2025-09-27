global class ScheduleUpdateProductPrices implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        
        Id standardPricebookId;
        
        // Vérifie si le code est en train d'être exécuté par une classe de test
        if (Test.isRunningTest()) {
            // Si c'est un test, on utilise la méthode de test pour obtenir un ID valide
            standardPricebookId = Test.getStandardPricebookId();
        } else {
            // Sinon, en production, on exécute la requête SOQL normale
            standardPricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
        }
        
        // Lance le batch en lui passant l'ID obtenu
        Database.executeBatch(new UpdateProductPricesBatch(standardPricebookId));
    }
    
}