@isTest
private class AccountServiceTest {

    @isTest
    static void testRecalculateRevenue_WithActiveOrders() {
        // Préparation
        Account acc = TestDataFactory.createAccount('Test Service Account');
        Order ord = TestDataFactory.createOrder(acc.Id, null);
        
        // Création d'une ligne de commande avec montant
        TestDataFactory.createOrderItem(ord.Id, 
            TestDataFactory.createPricebookEntry(
                TestDataFactory.createProduct('Test Prod').Id, 250).Id, 2, 250); // Total = 500

        // Activation de la commande
        Order orderToActivate = [SELECT Id FROM Order WHERE Id = :ord.Id];
        orderToActivate.Status = 'Activated';
        update orderToActivate;

        // Exécution
        Test.startTest();
        AccountService.recalculateRevenue(new Set<Id>{ acc.Id });
        Test.stopTest();

        // Vérification
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(500, updatedAccount.Chiffre_d_affaire__c, 'Le CA devrait être de 500');
    }

    @isTest
    static void testRecalculateRevenue_WithNoActiveOrders() {
        // Compte avec CA existant mais sans commandes activées
        Account acc = TestDataFactory.createAccount('Test Service Account No Orders');
        acc.Chiffre_d_affaire__c = 999;
        update acc;

        // Exécution
        Test.startTest();
        AccountService.recalculateRevenue(new Set<Id>{ acc.Id });
        Test.stopTest();

        // Vérification que le CA est remis à 0
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, updatedAccount.Chiffre_d_affaire__c, 'Le CA devrait être remis à 0');
    }
}