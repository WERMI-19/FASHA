/**
 * Planification pour le batch de mise à jour des comptes
 * Exécute périodiquement le processus de mise à jour en masse
 */
global class ScheduleUpdateAccountsBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateAccountsBatch());
    }
}