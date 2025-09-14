@isTest
public class TestDataFactory {

    // Méthode pour créer un compte
    public static Account createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc;
    }

    // Méthode pour créer un produit
    public static Product2 createProduct(String name) {
        Product2 prod = new Product2(Name = name, Family = 'Test Product Family');
        insert prod;
        return prod;
    }

    // Méthode pour créer une entrée dans le catalogue de prix standard
    public static PricebookEntry createPricebookEntry(Id productId, Decimal unitPrice) {
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productId,
            UnitPrice = unitPrice,
            IsActive = true
        );
        insert pbe;
        return pbe;
    }

    // Méthode pour créer une commande
    public static Order createOrder(Id accountId, Id pricebookEntryId) {
        Order ord = new Order(
            AccountId = accountId,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert ord;
        return ord;
    }
    
    // Méthode pour créer une ligne de commande (OrderItem)
    public static OrderItem createOrderItem(Id orderId, Id pricebookEntryId, Decimal quantity, Decimal unitPrice) {
        OrderItem oi = new OrderItem(
            OrderId = orderId,
            PricebookEntryId = pricebookEntryId,
            Quantity = quantity,
            UnitPrice = unitPrice
        );
        insert oi;
        return oi;
    }
}