@isTest
private class OrderTriggerHandlerTest {

    // Test du cas nominal : une seule commande est activée
    @isTest
    static void testHandleUpdate_SingleOrder() {
        // --- Préparation ---
        Account acc = TestDataFactory.createAccount('Compte Commande Simple');
        Product2 prod = TestDataFactory.createProduct('Produit Simple');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 150);
        Order order = TestDataFactory.createOrder(acc.Id, pbe.Id);
        TestDataFactory.createOrderItem(order.Id, pbe.Id, 1, 150); // Montant = 150

        // --- Exécution ---
        Test.startTest();
        
        // On re-quête la commande pour obtenir le TotalAmount qui a été calculé par Salesforce
        Order orderToActivate = [SELECT Id FROM Order WHERE Id = :order.Id];
        orderToActivate.Status = 'Activated';
        update orderToActivate;

        Test.stopTest();

        // --- Vérification ---
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(150, updatedAccount.Chiffre_d_affaire__c, 'Le CA doit correspondre au montant de la commande.');
    }

    // Test du cas complexe pour atteindre 100% de couverture
    @isTest
    static void testHandleUpdate_MultipleOrdersSameAccount() {
        // --- Préparation ---
        Account acc = TestDataFactory.createAccount('Compte Multi-Commandes');
        Product2 prod = TestDataFactory.createProduct('Produit Multi-Commandes');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);

        Order order1 = TestDataFactory.createOrder(acc.Id, pbe.Id);
        TestDataFactory.createOrderItem(order1.Id, pbe.Id, 1, 100); // Montant = 100
        
        Order order2 = TestDataFactory.createOrder(acc.Id, pbe.Id);
        TestDataFactory.createOrderItem(order2.Id, pbe.Id, 2, 100); // Montant = 200

        // --- Exécution ---
        Test.startTest();

        // On re-quête les commandes pour obtenir leurs TotalAmount
        List<Order> ordersToActivate = [SELECT Id FROM Order WHERE AccountId = :acc.Id];
        for(Order o : ordersToActivate){
            o.Status = 'Activated';
        }
        update ordersToActivate;

        Test.stopTest();

        // --- Vérification ---
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(300, updatedAccount.Chiffre_d_affaire__c, 'Le CA doit etre la somme des deux commandes activées.');
    }
}