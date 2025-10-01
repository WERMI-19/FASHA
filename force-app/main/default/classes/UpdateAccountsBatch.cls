/**
 * Batch de mise à jour du chiffre d'affaires des comptes
 * Utilise AccountService pour le calcul du CA
 */
global class UpdateAccountsBatch implements Database.Batchable<sObject> {
    
    /**
     * Récupère les comptes ayant au moins une commande
     */
    global Database.QueryLocator start(Database.BatchableContext info) { 
        return Database.getQueryLocator([
            SELECT Id 
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Order)
        ]);
    }
     
    /**
     * Déclenche le recalcul du CA pour les comptes du lot
     */
    global void execute(Database.BatchableContext info, List<Account> scope) {
        Set<Id> accountIds = (new Map<Id, Account>(scope)).keySet();
        AccountService.recalculateRevenue(accountIds);
    }    
     
    /**
     * Log de fin de traitement du batch
     */
    global void finish(Database.BatchableContext info) {     
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :info.getJobId()];
        System.debug('Batch UpdateAccountsBatch terminé. Statut : ' + job.Status + '. Erreurs: ' + job.NumberOfErrors);
    } 
}