/**
 * @description Classe de test pour OrdersController
 */
@isTest
private class OrdersControllerTest {
    /**
     * @description Teste le calcul avec une commande activée
     */
    @isTest
    static void getSumOrdersWithActivatedOrderShouldReturnTotal() { // NOPMD
        Account acc = TestDataFactory.createAccount('Test Account LWC');
        Product2 prod = TestDataFactory.createProduct('Test Product LWC');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 250);
        Order ord = TestDataFactory.createOrder(acc.Id, pbe.Id);
        TestDataFactory.createOrderItem(ord.Id, pbe.Id, 2, 250);
        ord.Status = 'Activated';
        update ord;

        Test.startTest();
        Decimal total = OrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(500, total, 'Le montant total des commandes activées devrait être 500.');
    }

    /**
     * @description Teste le calcul sans commande activée
     */
    @isTest
    static void getSumOrdersWithNoActivatedOrderShouldReturnZero() { // NOPMD
        Account acc = TestDataFactory.createAccount('Test Account LWC No Order');
        Product2 prod = TestDataFactory.createProduct('Test Product LWC No Order');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 250);
        Order ord = TestDataFactory.createOrder(acc.Id, pbe.Id);
        TestDataFactory.createOrderItem(ord.Id, pbe.Id, 2, 250);

        Test.startTest();
        Decimal total = OrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(0, total, 'Le montant total devrait être 0 car aucune commande activée.');
    }

    /**
     * @description Teste le comportement avec un ID null
     */
    @isTest
    static void getSumOrdersWithNullIdShouldReturnZero() { // NOPMD
        Test.startTest();
        Decimal total = OrdersController.getSumOrdersByAccount(null);
        Test.stopTest();

        System.assertEquals(0, total, 'Le montant total devrait être 0 quand accountId est null.');
    }
}