/**
 * @description Classe Batch Apex conçue pour recalculer et mettre à jour en masse
 * le champ Chiffre d'affaires sur les enregistrements de Compte.
 * Elle est optimisée pour ne traiter que les comptes pertinents.
 */
global class UpdateAccountsBatch implements Database.Batchable<AggregateResult> {
    
    /**
     * @description Méthode START : Collecte les données à traiter.
     * Retourne directement les résultats agrégés.
     */
    global Iterable<AggregateResult> start(Database.BatchableContext info) { 
        return [
            SELECT AccountId, SUM(TotalAmount) total 
            FROM Order 
            WHERE Status = 'Activated' 
            GROUP BY AccountId
            HAVING SUM(TotalAmount) > 0
        ];
    }
     
    /**
     * @description Méthode EXECUTE : Traite chaque lot de données.
     * Elle reçoit bien une liste d'AggregateResult, comme promis par l'interface.
     */
    global void execute(Database.BatchableContext info, List<AggregateResult> scope) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for (AggregateResult ar : scope) {
            accountsToUpdate.add(new Account(
                Id = (Id) ar.get('AccountId'),
                Chiffre_d_affaire__c = (Decimal) ar.get('total')
            ));
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }    
     
    /**
     * @description Méthode FINISH : Exécutée une fois que tous les lots sont traités.
     * Affiche un résumé de l'exécution dans les logs pour la surveillance.
     */
    global void finish(Database.BatchableContext info) {     
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Name 
                            FROM AsyncApexJob 
                            WHERE Id = :info.getJobId()];

        // Écrit un message de résumé dans les logs
        System.debug('Batch UpdateAccountsBatch terminé.');
        System.debug('    Statut : ' + job.Status);
        System.debug('    Lots traités : ' + job.JobItemsProcessed + '/' + job.TotalJobItems);
        System.debug('    Erreurs : ' + job.NumberOfErrors);
    } 
}