/**
 * @description Batch pour la mise à jour du chiffre d'affaires des comptes
 */
global class UpdateAccountsBatch implements Database.Batchable<sObject> { // NOPMD
    /**
     * @description Méthode start pour récupérer les comptes avec commandes activées
     * @param info Contexte du batch
     * @return QueryLocator des comptes à traiter
     */
    global Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator([
            SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')
        ]);
    }
    /**
     * @description Méthode execute pour traiter les comptes par lots
     * @param info Contexte du batch
     * @param scope Liste des comptes du lot courant
     */
    global void execute(Database.BatchableContext info, List<Account> scope) {
        Set<Id> setAccountIds = (new Map<Id, SObject>(scope)).keySet();
        OrderTriggerHandler.recalculateRevenue(setAccountIds);
    }
    /**
     * @description Méthode finish pour le suivi de l'exécution
     * @param info Contexte du batch
     */
    global void finish(Database.BatchableContext info) {
        AsyncApexJob job = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CompletedDate
            FROM AsyncApexJob
            WHERE Id = :info.getJobId()
        ];
        System.debug('Batch UpdateAccountsBatch terminé avec statut: ' + job.Status); // NOPMD
        System.debug('Lots traités: ' + job.JobItemsProcessed + '/' + job.TotalJobItems); // NOPMD
        System.debug('Nombre d\'erreurs: ' + job.NumberOfErrors); // NOPMD
    }
}