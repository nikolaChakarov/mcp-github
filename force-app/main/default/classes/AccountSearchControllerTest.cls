/**
 * Test class for AccountSearchController
 * Covers positive and negative test scenarios for account search functionality
 */
@IsTest
private class AccountSearchControllerTest {
    
    /**
     * Setup test data - creates test Account records
     */
    @TestSetup
    static void setupTestData() {
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Acme Corporation', AccountNumber = 'ACC-001'),
            new Account(Name = 'Global Industries', AccountNumber = 'ACC-002'),
            new Account(Name = 'Acme Solutions', AccountNumber = 'ACC-003'),
            new Account(Name = 'Tech Innovations', AccountNumber = 'ACC-004'),
            new Account(Name = 'ACME Holdings', AccountNumber = 'ACC-005')
        };
        insert testAccounts;
    }
    
    /**
     * Test searching with a valid search term that matches multiple records
     */
    @IsTest
    static void testSearchAccounts_ValidSearchTerm_ReturnsMultipleResults() {
        Test.startTest();
        List<Account> results = AccountSearchController.searchAccounts('Acme');
        Test.stopTest();
        
        // Should return 3 accounts with 'Acme' in the name
        Assert.areEqual(3, results.size(), 'Should find 3 accounts with Acme in the name');
        
        // Verify results are ordered by Name
        Assert.isTrue(results[0].Name.containsIgnoreCase('Acme'), 'Results should contain Acme');
        
        // Verify fields are populated
        Assert.isNotNull(results[0].Id, 'Id should be populated');
        Assert.isNotNull(results[0].Name, 'Name should be populated');
    }
    
    /**
     * Test searching with a search term that matches one record
     */
    @IsTest
    static void testSearchAccounts_SpecificSearchTerm_ReturnsSingleResult() {
        Test.startTest();
        List<Account> results = AccountSearchController.searchAccounts('Global');
        Test.stopTest();
        
        Assert.areEqual(1, results.size(), 'Should find 1 account with Global in the name');
        Assert.areEqual('Global Industries', results[0].Name, 'Should return Global Industries');
        Assert.areEqual('ACC-002', results[0].AccountNumber, 'AccountNumber should be ACC-002');
    }
    
    /**
     * Test searching with a search term that matches no records
     */
    @IsTest
    static void testSearchAccounts_NoMatches_ReturnsEmptyList() {
        Test.startTest();
        List<Account> results = AccountSearchController.searchAccounts('NonExistentCompany');
        Test.stopTest();
        
        Assert.areEqual(0, results.size(), 'Should return empty list when no matches found');
    }
    
    /**
     * Test searching with empty string - should return default 10 records
     */
    @IsTest
    static void testSearchAccounts_EmptyString_ReturnsDefaultRecords() {
        Test.startTest();
        List<Account> results = AccountSearchController.searchAccounts('');
        Test.stopTest();
        
        // Should return all 5 test accounts (limited to 10)
        Assert.areEqual(5, results.size(), 'Should return default records for empty search term');
        
        // Verify fields are populated
        Assert.isNotNull(results[0].Id, 'Id should be populated');
        Assert.isNotNull(results[0].Name, 'Name should be populated');
    }
    
    /**
     * Test searching with null search term - should return default 10 records
     */
    @IsTest
    static void testSearchAccounts_NullSearchTerm_ReturnsDefaultRecords() {
        Test.startTest();
        List<Account> results = AccountSearchController.searchAccounts(null);
        Test.stopTest();
        
        // Should return all 5 test accounts (limited to 10)
        Assert.areEqual(5, results.size(), 'Should return default records for null search term');
        
        // Verify results are ordered by Name
        Assert.isTrue(results[0].Name <= results[1].Name, 'Results should be ordered by Name');
    }
    
    /**
     * Test that default record limit is 10
     */
    @IsTest
    static void testSearchAccounts_DefaultLimit_Returns10Records() {
        // Create 15 additional accounts (total 20)
        List<Account> additionalAccounts = new List<Account>();
        for (Integer i = 1; i <= 15; i++) {
            additionalAccounts.add(new Account(Name = 'Test Account ' + i, AccountNumber = 'TEST-' + i));
        }
        insert additionalAccounts;
        
        Test.startTest();
        List<Account> results = AccountSearchController.searchAccounts('');
        Test.stopTest();
        
        // Should return exactly 10 records
        Assert.areEqual(10, results.size(), 'Should return maximum 10 default records');
    }
    
    /**
     * Test case sensitivity - SOQL LIKE is case-insensitive
     */
    @IsTest
    static void testSearchAccounts_CaseInsensitive_ReturnsAllMatches() {
        Test.startTest();
        List<Account> lowerCaseResults = AccountSearchController.searchAccounts('acme');
        List<Account> upperCaseResults = AccountSearchController.searchAccounts('ACME');
        List<Account> mixedCaseResults = AccountSearchController.searchAccounts('AcMe');
        Test.stopTest();
        
        Assert.areEqual(3, lowerCaseResults.size(), 'Lowercase search should return 3 results');
        Assert.areEqual(3, upperCaseResults.size(), 'Uppercase search should return 3 results');
        Assert.areEqual(3, mixedCaseResults.size(), 'Mixed case search should return 3 results');
    }
    
    /**
     * Test partial matching
     */
    @IsTest
    static void testSearchAccounts_PartialMatch_ReturnsResults() {
        Test.startTest();
        List<Account> results = AccountSearchController.searchAccounts('Ind');
        Test.stopTest();
        
        Assert.areEqual(1, results.size(), 'Should find accounts with partial match');
        Assert.isTrue(results[0].Name.contains('Industries'), 'Should match partial string');
    }
    
    /**
     * Test paginated search - first page
     */
    @IsTest
    static void testSearchAccountsPaginated_FirstPage() {
        // Create additional accounts for pagination testing
        List<Account> additionalAccounts = new List<Account>();
        for (Integer i = 1; i <= 15; i++) {
            additionalAccounts.add(new Account(Name = 'Test Account ' + i, AccountNumber = 'TEST-' + i));
        }
        insert additionalAccounts;
        
        Test.startTest();
        AccountSearchController.PaginatedResult result = 
            AccountSearchController.searchAccountsPaginated('', 1, 10);
        Test.stopTest();
        
        Assert.areEqual(10, result.records.size(), 'Should return 10 records on first page');
        Assert.areEqual(20, result.totalRecords, 'Total records should be 20');
        Assert.areEqual(1, result.pageNumber, 'Page number should be 1');
        Assert.areEqual(10, result.pageSize, 'Page size should be 10');
        Assert.areEqual(2, result.totalPages, 'Total pages should be 2');
    }
    
    /**
     * Test paginated search - second page
     */
    @IsTest
    static void testSearchAccountsPaginated_SecondPage() {
        // Create additional accounts for pagination testing
        List<Account> additionalAccounts = new List<Account>();
        for (Integer i = 1; i <= 15; i++) {
            additionalAccounts.add(new Account(Name = 'Test Account ' + i, AccountNumber = 'TEST-' + i));
        }
        insert additionalAccounts;
        
        Test.startTest();
        AccountSearchController.PaginatedResult result = 
            AccountSearchController.searchAccountsPaginated('', 2, 10);
        Test.stopTest();
        
        Assert.areEqual(10, result.records.size(), 'Should return 10 records on second page');
        Assert.areEqual(20, result.totalRecords, 'Total records should be 20');
        Assert.areEqual(2, result.pageNumber, 'Page number should be 2');
    }
    
    /**
     * Test paginated search with search term
     */
    @IsTest
    static void testSearchAccountsPaginated_WithSearchTerm() {
        Test.startTest();
        AccountSearchController.PaginatedResult result = 
            AccountSearchController.searchAccountsPaginated('Acme', 1, 10);
        Test.stopTest();
        
        Assert.areEqual(3, result.records.size(), 'Should return 3 Acme accounts');
        Assert.areEqual(3, result.totalRecords, 'Total records should be 3');
        Assert.areEqual(1, result.totalPages, 'Total pages should be 1');
        
        // Verify all records contain 'Acme'
        for (Account acc : result.records) {
            Assert.isTrue(acc.Name.containsIgnoreCase('Acme'), 'All records should contain Acme');
        }
    }
    
    /**
     * Test paginated search with no results
     */
    @IsTest
    static void testSearchAccountsPaginated_NoResults() {
        Test.startTest();
        AccountSearchController.PaginatedResult result = 
            AccountSearchController.searchAccountsPaginated('NonExistent', 1, 10);
        Test.stopTest();
        
        Assert.areEqual(0, result.records.size(), 'Should return no records');
        Assert.areEqual(0, result.totalRecords, 'Total records should be 0');
        Assert.areEqual(0, result.totalPages, 'Total pages should be 0');
    }
    
    /**
     * Test paginated search with custom page size
     */
    @IsTest
    static void testSearchAccountsPaginated_CustomPageSize() {
        Test.startTest();
        AccountSearchController.PaginatedResult result = 
            AccountSearchController.searchAccountsPaginated('', 1, 3);
        Test.stopTest();
        
        Assert.areEqual(3, result.records.size(), 'Should return 3 records');
        Assert.areEqual(3, result.pageSize, 'Page size should be 3');
        Assert.areEqual(2, result.totalPages, 'Total pages should be 2 (5 records / 3 per page)');
    }
    
    /**
     * Test paginated search with null parameters defaults
     */
    @IsTest
    static void testSearchAccountsPaginated_NullParameters() {
        Test.startTest();
        AccountSearchController.PaginatedResult result = 
            AccountSearchController.searchAccountsPaginated('', null, null);
        Test.stopTest();
        
        Assert.areEqual(1, result.pageNumber, 'Page number should default to 1');
        Assert.areEqual(10, result.pageSize, 'Page size should default to 10');
    }
}
