/**
 * @description Classe schedulable pour la mise à jour hebdomadaire des prix des produits
 * Gère l'exécution du batch UpdateProductPricesBatch selon une planification
 */
public without sharing class ScheduleUpdateProductPrices implements Schedulable {
    /**
     * @description Méthode d'exécution de la planification
     * @param sc Contexte de la planification
     */
    public void execute(SchedulableContext sc) {
        Id standardPricebookId = getStandardPricebookId();
        Database.executeBatch(new UpdateProductPricesBatch(standardPricebookId));
    }
    /**
     * @description Récupère l'ID du catalogue de prix standard
     * @return Id de l'enregistrement Pricebook2 standard
     */
    private Id getStandardPricebookId() {
        if (Test.isRunningTest()) {
            return Test.getStandardPricebookId();
        } else {
            return [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id; //NOPMD
        }
    }
}