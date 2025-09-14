@isTest
private class OrdersControllerTest {

    @isTest
    static void testGetSumOrders_WithActivatedOrder() {
        // --- Préparation des données ---
        Account acc = TestDataFactory.createAccount('Test Account LWC');
        Product2 prod = TestDataFactory.createProduct('Test Product LWC');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 250);
        Order ord = TestDataFactory.createOrder(acc.Id, pbe.Id);
        TestDataFactory.createOrderItem(ord.Id, pbe.Id, 2, 250); // Montant total = 500
        
        // On active la commande
        // **CORRECTION** : Re-quéter la commande pour avoir le TotalAmount à jour
        Order orderToActivate = [SELECT Id FROM Order WHERE Id = :ord.Id];
        orderToActivate.Status = 'Activated';
        update orderToActivate;

        // --- Exécution de la méthode ---
        Test.startTest();
        Decimal total = OrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();

        // --- Vérification ---
        System.assertEquals(500, total, 'Le montant total des commandes activées devrait être 500.');
    }

    @isTest
    static void testGetSumOrders_WithNoActivatedOrder() {
        // --- Préparation des données ---
        Account acc = TestDataFactory.createAccount('Test Account LWC No Order');
        Product2 prod = TestDataFactory.createProduct('Test Product LWC No Order');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 250);
        Order ord = TestDataFactory.createOrder(acc.Id, pbe.Id);
        TestDataFactory.createOrderItem(ord.Id, pbe.Id, 2, 250);

        // --- Exécution de la méthode ---
        Test.startTest();
        Decimal total = OrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();

        // --- Vérification ---
        System.assertEquals(0, total, 'Le montant total devrait être 0 car aucune commande n est activée.');
    }

    // --- NOUVEAU TEST POUR LA COUVERTURE ---
    @isTest
    static void testGetSumOrders_WithNullId() {
        // --- Exécution de la méthode ---
        Test.startTest();
        // On appelle la méthode avec un Id null
        Decimal total = OrdersController.getSumOrdersByAccount(null);
        Test.stopTest();

        // --- Vérification ---
        // Le résultat attendu est 0, comme défini dans la condition if (accountId == null)
        System.assertEquals(0, total, 'Le montant total devrait être 0 quand l accountId est null.');
    }
}