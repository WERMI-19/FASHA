@isTest
private class UpdateProductPricesBatchTest {

    @isTest
    static void testBatchPriceUpdate() { // NOPMD
        // --- Préparation ---
        Product2 prod = TestDataFactory.createProduct('Produit à tester');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);

        // --- Exécution ---
        Test.startTest();
        // Le test utilise la méthode de test pour obtenir l'ID...
        Id standardPricebookId = Test.getStandardPricebookId();
        //  et le passe au constructeur du batch.
        Database.executeBatch(new UpdateProductPricesBatch(standardPricebookId));

        Test.stopTest();
        // --- Vérification ---
        PricebookEntry updatedPbe = [SELECT UnitPrice FROM PricebookEntry WHERE Id = :pbe.Id];
        System.assertEquals(110, updatedPbe.UnitPrice, 'Le prix devrait avoir été augmenté à 110.');
    }
}