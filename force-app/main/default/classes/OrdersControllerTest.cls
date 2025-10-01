@isTest
private class OrdersControllerTest {

    @isTest
    static void testGetSumOrders_WithActivatedOrder() {
        // Préparation - Compte avec commande activée
        Account acc = TestDataFactory.createAccount('Test Account LWC');
        Order ord = TestDataFactory.createOrder(acc.Id, null);
        
        // Ajout d'une ligne de commande (montant total = 500)
        TestDataFactory.createOrderItem(ord.Id, 
            TestDataFactory.createPricebookEntry(
                TestDataFactory.createProduct('Test Prod').Id, 250).Id, 2, 250);
        
        // Activation de la commande
        Order orderToActivate = [SELECT Id FROM Order WHERE Id = :ord.Id];
        orderToActivate.Status = 'Activated';
        update orderToActivate;

        // Exécution
        Test.startTest();
        Decimal total = OrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();

        // Vérification
        System.assertEquals(500, total, 'Le total des commandes activées devrait être 500');
    }

    @isTest
    static void testGetSumOrders_WithNoActivatedOrder() {
        // Compte avec commande en statut Draft (non activée)
        Account acc = TestDataFactory.createAccount('Test Account LWC No Order');
        TestDataFactory.createOrder(acc.Id, null);

        // Exécution
        Test.startTest();
        Decimal total = OrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();

        // Vérification
        System.assertEquals(0, total, 'Doit retourner 0 quand aucune commande activée');
    }

    @isTest
    static void testGetSumOrders_WithNullId() {
        // Exécution avec ID null
        Test.startTest();
        Decimal total = OrdersController.getSumOrdersByAccount(null);
        Test.stopTest();

        // Vérification
        System.assertEquals(0, total, 'Doit retourner 0 quand accountId est null');
    }
}