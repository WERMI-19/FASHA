global class ScheduleUpdateProductPrices implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        // Cette méthode est appelée par Salesforce à l'heure planifiée.
        // Son seul rôle est de lancer notre batch.
        Database.executeBatch(new UpdateProductPricesBatch());
    }
    
}