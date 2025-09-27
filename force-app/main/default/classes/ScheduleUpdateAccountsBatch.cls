/**
 * @description Classe Apex planifiée (Schedulable) conçue pour lancer périodiquement
 * le processus de mise à jour en masse des comptes via une classe Batch.
 */
global class ScheduleUpdateAccountsBatch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateAccountsBatch());
    }
    
}