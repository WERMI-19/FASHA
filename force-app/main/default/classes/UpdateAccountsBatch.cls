/**
 * Batch de mise à jour du chiffre d'affaires des comptes
 */
global class UpdateAccountsBatch implements Database.Batchable<sObject> {
    
    global PerformanceMetrics batchMetrics = new PerformanceMetrics();
    
    global Database.QueryLocator start(Database.BatchableContext info) { 
        batchMetrics.startTimer('batchTotal');
        return Database.getQueryLocator([
            SELECT Id FROM Account
            WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')
        ]);
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope) {
        batchMetrics.startTimer('execute');
        batchMetrics.incrementCounter('batchesProcessed');
        batchMetrics.incrementCounter('accountsInBatch', scope.size());
        
        Set<Id> accountIds = (new Map<Id, Account>(scope)).keySet();
        AccountService.recalculateRevenue(accountIds);
        
        batchMetrics.stopTimer('execute');
        batchMetrics.logPerformance();
    }    
     
    global void finish(Database.BatchableContext info) {     
        batchMetrics.stopTimer('batchTotal');
        
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                           TotalJobItems, JobItemsProcessed,
                           CreatedDate, CompletedDate
                           FROM AsyncApexJob WHERE Id = :info.getJobId()];
        
        Long totalDuration = job.CompletedDate.getTime() - job.CreatedDate.getTime();
        
        System.debug('=== BATCH PERFORMANCE SUMMARY ===');
        System.debug('Durée totale: ' + totalDuration + 'ms');
        System.debug('Statut: ' + job.Status);
        System.debug('Erreurs: ' + job.NumberOfErrors);
        System.debug('Lots traités: ' + job.JobItemsProcessed + '/' + job.TotalJobItems);
        
        batchMetrics.logPerformance();
    } 
}