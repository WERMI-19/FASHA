@isTest
private class OrderTriggerHandlerTest {

    @isTest
    static void testHandleUpdate_singleOrder() { // NOPMD
        // --- Préparation ---
        Account acc = TestDataFactory.createAccount('Compte Commande Simple');
        Product2 prod = TestDataFactory.createProduct('Produit Simple');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 150);
        Order order = TestDataFactory.createOrder(acc.Id, pbe.Id);
        TestDataFactory.createOrderItem(order.Id, pbe.Id, 1, 150);

        // --- Exécution ---
        Test.startTest();
        Order orderToActivate = [SELECT Id FROM Order WHERE Id = :order.Id];
        orderToActivate.Status = 'Activated';
        update orderToActivate;
        Test.stopTest();

        // --- Vérification ---
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(150, updatedAccount.Chiffre_d_affaire__c, 'Le CA doit correspondre au montant de la commande.');
    }
    /**
     * @description Test de performance : Vérifie que le handler peut traiter
     * un grand nombre d'enregistrements (100 commandes) en une seule transaction */
    @isTest
    static void testHandleUpdate_bulkOrders() { // NOPMD
        // --- Préparation ---
        Account acc = TestDataFactory.createAccount('Bulk Test Account');
        Product2 prod = TestDataFactory.createProduct('Bulk Test Product');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 10);

        // Création des 100 commandes
        List<Order> ordersToCreate = new List<Order>();
        for (Integer i = 0; i < 100; i++) {
            ordersToCreate.add(new Order(
                AccountId = acc.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                Pricebook2Id = Test.getStandardPricebookId()
            ));
        }
        insert ordersToCreate;

        // Création des lignes de commande
        List<OrderItem> orderItemsToCreate = new List<OrderItem>();
        for(Order o : ordersToCreate) {
            orderItemsToCreate.add(new OrderItem(
                OrderId = o.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 10
            ));
        }
        insert orderItemsToCreate;

        // --- Exécution ---
        Test.startTest();
        List<Order> ordersToActivate = [SELECT Id FROM Order WHERE AccountId = :acc.Id];
        for(Order o : ordersToActivate) {
            o.Status = 'Activated';
        }
        update ordersToActivate;
        Test.stopTest();

        // --- Vérification ---
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1000, updatedAccount.Chiffre_d_affaire__c, 'Le CA devrait être la somme des 100 commandes.');
    }
}