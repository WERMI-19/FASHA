@isTest
public class TestDataFactory {

    /** Méthode pour créer un compte*/
    public static Account createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc;
    }

    /** Méthode pour créer plusieurs comptes en une DML */
    public static List<Account> createAccounts(List<String> names) {
        List<Account> accounts = new List<Account>();
        for (String name : names) {
            accounts.add(new Account(Name = name));
        }
        insert accounts;
        return accounts;
    }

    // Méthode pour créer un produit
    public static Product2 createProduct(String name) {
        Product2 prod = new Product2(Name = name, Family = 'Test Product Family');
        insert prod;
        return prod;
    }

    /** Méthode pour créer plusieurs produits en une DML */
    public static List<Product2> createProducts(List<String> names) {
        List<Product2> products = new List<Product2>();
        for (String name : names) {
            products.add(new Product2(Name = name, Family = 'Test Product Family'));
        }
        insert products;
        return products;
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

    /** Méthode pour créer plusieurs PricebookEntry en une DML */
    public static List<PricebookEntry> createPricebookEntries(List<Id> productIds, Decimal unitPrice) {
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Id productId : productIds) {
            pbes.add(new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = productId,
                UnitPrice = unitPrice,
                IsActive = true
            ));
        }
        insert pbes;
        return pbes;
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

    /** Méthode pour créer plusieurs commandes en une DML */
    public static List<Order> createOrders(Id accountId, Integer numberOfOrders) {
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < numberOfOrders; i++) {
            orders.add(new Order(
                AccountId = accountId,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                Pricebook2Id = Test.getStandardPricebookId()
            ));
        }
        insert orders;
        return orders;
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

    /** Méthode pour créer plusieurs OrderItems en une DML */
    public static List<OrderItem> createOrderItems(List<Id> orderIds, Id pricebookEntryId, Decimal quantity, Decimal unitPrice) {
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Id orderId : orderIds) {
            orderItems.add(new OrderItem(
                OrderId = orderId,
                PricebookEntryId = pricebookEntryId,
                Quantity = quantity,
                UnitPrice = unitPrice
            ));
        }
        insert orderItems;
        return orderItems;
    }
}