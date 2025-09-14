@isTest
private class UpdateProductPricesBatchTest {

    @isTest
    static void testBatchPriceUpdate() {
        // --- Préparation ---
        // Créer un produit avec un prix initial de 100
        Product2 prod = TestDataFactory.createProduct('Produit à tester');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100);

        // --- Exécution ---
        Test.startTest();
        Database.executeBatch(new UpdateProductPricesBatch());
        Test.stopTest();

        // --- Vérification ---
        // On vérifie que le prix a bien été augmenté de 10%
        PricebookEntry updatedPbe = [SELECT UnitPrice FROM PricebookEntry WHERE Id = :pbe.Id];
        System.assertEquals(110, updatedPbe.UnitPrice, 'Le prix devrait avoir été augmenté à 110.');
    }
}