@isTest
private class OrderTriggerHandlerTest {

    @isTest
    static void testHandleAfterUpdate_CallsRevenueRecalculation() {
        // Préparation - Compte avec commande
        Account acc = TestDataFactory.createAccount('Test Handler Account');
        Order ord = TestDataFactory.createOrder(acc.Id, null);
        TestDataFactory.createOrderItem(ord.Id, 
            TestDataFactory.createPricebookEntry(
                TestDataFactory.createProduct('Test Prod').Id, 150).Id, 1, 150);

        // Exécution - Activation de la commande
        Test.startTest();
        Order orderToActivate = [SELECT Id FROM Order WHERE Id = :ord.Id];
        orderToActivate.Status = 'Activated';
        update orderToActivate;
        Test.stopTest();

        // Vérification - CA mis à jour
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(150, updatedAccount.Chiffre_d_affaire__c, 'Le CA doit correspondre à la commande activée');
    }
    
    @isTest
    static void testHandleBefore_CalculatesNetAmount() {
        // Test direct du calcul du montant net
        Order testOrder = new Order(ShipmentCost__c = 25);
        List<Order> orderList = new List<Order>{ testOrder };

        // Exécution
        OrderTriggerHandler.handleBeforeInsertUpdate(orderList);

        // Vérification du calcul (0 - 25 = -25)
        System.assertEquals(-25, testOrder.NetAmount__c, 'NetAmount__c devrait être -25');
    }
}