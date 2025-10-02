@isTest
private class OrderTriggerHandlerTest {

    @isTest
    static void testHandleUpdate_bulkOrders() {
        // PRÉPARATION BULK - Seulement 5 DML au total au lieu de 151
        
        // 1. Créer un compte
        Account acc = TestDataFactory.createAccount('Test Bulk Account');
        
        // 2. Créer un seul produit
        Product2 prod = TestDataFactory.createProduct('Test Bulk Product');
        
        // 3. Créer une seule PricebookEntry
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);
        
        // 4. Créer 150 commandes en UNE DML
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < 150; i++) {
            orders.add(new Order(
                AccountId = acc.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                Pricebook2Id = Test.getStandardPricebookId()
            ));
        }
        insert orders;
        
        // 5. Créer 150 OrderItems en UNE DML
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order ord : orders) {
            orderItems.add(new OrderItem(
                OrderId = ord.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 1,
                UnitPrice = 100
            ));
        }
        insert orderItems;
        
        // Récupérer les commandes pour activation
        List<Order> ordersToUpdate = [SELECT Id, Status FROM Order WHERE Id IN :new Map<Id, Order>(orders).keySet()];
        
        // ACT - Activation massive des 150 commandes
        Test.startTest();
        OrderTriggerHandler.metrics.reset();
        
        for (Order ord : ordersToUpdate) {
            ord.Status = 'Activated';
        }
        update ordersToUpdate; // Déclenche le trigger
        
        Test.stopTest();
        
        // ASSERT - Vérification des performances
        System.debug('=== PERFORMANCE RESULTS - BULK PROCESSING ===');
        System.debug('Nombre de commandes traitées: ' + ordersToUpdate.size());
        System.debug('SOQL Queries utilisées: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('DML Statements utilisés: ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
        System.debug('CPU Time utilisé: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
        System.debug('Heap Size utilisé: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
        
        
        // Vérification des données
        Account updatedAcc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(15000, updatedAcc.Chiffre_d_affaire__c, 'CA devrait être 15000 (150 commandes × 100)');
    }
}