@isTest
private class UpdateAccountsBatchTest {

    @isTest
    static void testBatchExecution_CallsRevenueRecalculation() {
        // Préparation - Compte avec commande activée
        Account acc = TestDataFactory.createAccount('Test Batch Account');
        Order ord = TestDataFactory.createOrder(acc.Id, null);
        TestDataFactory.createOrderItem(ord.Id, 
            TestDataFactory.createPricebookEntry(
                TestDataFactory.createProduct('Test Prod').Id, 500).Id, 1, 500);
        
        // Activation de la commande
        Order orderToActivate = [SELECT Id FROM Order WHERE Id = :ord.Id];
        orderToActivate.Status = 'Activated';
        update orderToActivate;

        // Exécution du batch
        Test.startTest();
        Database.executeBatch(new UpdateAccountsBatch());
        Test.stopTest();

        // Vérification que le CA a été mis à jour
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(500, updatedAccount.Chiffre_d_affaire__c, 'Le CA devrait être mis à jour par le batch');
    }
}