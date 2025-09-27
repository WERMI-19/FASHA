@isTest
private class ScheduleUpdateProductPricesTest {

    @isTest
    static void testScheduler() {
        String jobName = 'Test Mise à jour des prix';
        String cronExpression = '0 0 2 ? * SUN';

        Test.startTest();
        
        //  planifie le job. La logique à l'intérieur du scheduler utilisera Test.getStandardPricebookId()
        System.schedule(jobName, cronExpression, new ScheduleUpdateProductPrices());
        
        Test.stopTest();

        // On vérifie simplement que le job a bien été ajouté à la file d'attente
        CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE CronJobDetail.Name = :jobName];
        System.assertNotEquals(null, ct, 'Le job de mise à jour des prix aurait dû être planifié.');
        System.assertEquals(cronExpression, ct.CronExpression);
    }
}