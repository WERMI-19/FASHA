/**
 * @description Classe Apex planifiée (Schedulable) conçue pour lancer périodiquement
 * le processus de mise à jour en masse des comptes via une classe Batch.
 */
global class ScheduleUpdateAccountsBatch implements Schedulable {  // NOPMD
    global void execute(SchedulableContext sc) { // NOPMD
        Database.executeBatch(new UpdateAccountsBatch());
    }
}