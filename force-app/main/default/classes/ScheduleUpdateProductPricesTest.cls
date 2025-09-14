@isTest
private class ScheduleUpdateProductPricesTest {

    @isTest
    static void testScheduler() {
        // Préparer l'expression CRON pour une exécution future
        String cronExpression = '0 0 2 ? * SUN';
        String jobName = 'Test Mise à jour prix';

        Test.startTest();
        // Planifier le job
        System.schedule(jobName, cronExpression, new ScheduleUpdateProductPrices());
        Test.stopTest();

        // Vérifier que le job a bien été planifié
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger WHERE CronJobDetail.Name = :jobName];
        
        // Vérifier que l'expression CRON est correcte
        System.assertEquals(cronExpression, ct.CronExpression);
    }
}