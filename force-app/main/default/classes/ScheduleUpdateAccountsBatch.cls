/**
 * @description Classe Apex planifiée (Schedulable) conçue pour lancer périodiquement
 * le processus de mise à jour en masse des comptes via une classe Batch.
 */
global class ScheduleUpdateAccountsBatch implements Schedulable {
    
    /**
     * @description Méthode exécutée automatiquement par le planificateur Salesforce.
     * Elle démarre la classe Batch 'UpdateAllAccounts' pour traiter les enregistrements.
     */
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateAccountsBatch());
    }
    
}