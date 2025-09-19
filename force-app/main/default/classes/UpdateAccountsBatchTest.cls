@isTest
private class UpdateAccountsBatchTest {

    @isTest static void testBatchExecution() {
        // 1. Création des données via la TestDataFactory
        Account acc = TestDataFactory.createAccount('Test Account Batch');
        Product2 prod = TestDataFactory.createProduct('Test Product Batch');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);
        Order ord = TestDataFactory.createOrder(acc.Id, pbe.Id);
        TestDataFactory.createOrderItem(ord.Id, pbe.Id, 5, 100); // 5 * 100 = 500

        // 2. Mettre à jour la commande pour qu'elle soit "Activée"
        ord.Status = 'Activated';
        update ord;

        // 3. Exécuter le batch
        Test.startTest();
        Database.executeBatch(new UpdateAllAccounts());
        Test.stopTest();

        // 4. Vérifier le résultat
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        // Le CA doit être égal au montant total de la commande
        System.assertEquals(500, updatedAccount.Chiffre_d_affaire__c, 'Le chiffre d affaire du compte devrait etre mis a jour.');
    }
}