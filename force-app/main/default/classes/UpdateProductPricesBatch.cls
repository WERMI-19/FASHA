/**
 * @description Batch Apex pour la mise à jour hebdomadaire des prix des produits
 * Augmente de 10% les prix de toutes les entrées de catalogue actives
 */
public class UpdateProductPricesBatch implements Database.Batchable<sObject> { // NOPMD
    /**
     * @description ID du catalogue de prix à traiter
     */
    private final Id pricebookId;

    /**
     * @description Constructeur qui initialise le batch avec l'ID du catalogue de prix
     * @param standardPricebookId ID du catalogue de prix standard à traiter
     */
    public UpdateProductPricesBatch(Id standardPricebookId) {
        this.pricebookId = standardPricebookId;
    }

    /**
     * @description Méthode start qui définit la requête des enregistrements à traiter
     * @param bc Contexte du batch
     * @return QueryLocator pour les entrées de prix actives du catalogue spécifié
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND IsActive = true';
        return Database.getQueryLocator(query);
    }

    /**
     * @description Méthode execute qui traite un lot d'entrées de prix
     * @param bc Contexte du batch
     * @param scope Liste des entrées de prix à traiter dans ce lot
     */
    public void execute(Database.BatchableContext bc, List<PricebookEntry> scope) {
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
    /**
     * @description Méthode finish exécutée après le traitement de tous les lots
     * @param bc Contexte du batch
     */
    public void finish(Database.BatchableContext bc) {
        if (LoggingLevel.INFO != null) {
            System.debug(LoggingLevel.INFO, 'La mise à jour hebdomadaire des prix est terminée.'); // NOPMD
        }
    }
}