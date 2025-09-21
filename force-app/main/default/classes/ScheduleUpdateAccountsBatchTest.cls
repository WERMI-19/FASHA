@isTest
private class ScheduleUpdateAccountsBatchTest {

    @isTest
    static void testScheduler() {
        String cronExpression = '0 0 3 ? * SUN';
        String jobName = 'Test Mise à jour CA';

        Test.startTest();
        System.schedule(jobName, cronExpression, new ScheduleUpdateAccountsBatch());
        Test.stopTest();

        CronTrigger ct = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = :jobName];
        
        // On vérifie simplement que le job existe dans la table des jobs planifiés
        System.assertNotEquals(null, ct, 'Le job de mise à jour du CA aurait dû être planifié.');
    }
}