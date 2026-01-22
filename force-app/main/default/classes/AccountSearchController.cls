/**
 * Controller class for the Account Search LWC component
 * Provides server-side search functionality for Account records with pagination
 */
public with sharing class AccountSearchController {
    
    /**
     * Wrapper class to return paginated results with metadata
     */
    public class PaginatedResult {
        @AuraEnabled public List<Account> records { get; set; }
        @AuraEnabled public Integer totalRecords { get; set; }
        @AuraEnabled public Integer pageSize { get; set; }
        @AuraEnabled public Integer pageNumber { get; set; }
        @AuraEnabled public Integer totalPages { get; set; }
        
        public PaginatedResult() {
            this.records = new List<Account>();
            this.totalRecords = 0;
            this.pageSize = 10;
            this.pageNumber = 1;
            this.totalPages = 0;
        }
    }
    
    /**
     * Searches for Account records where Name contains the search term with pagination
     * @param searchTerm - The user input to search for in Account Name
     * @param pageNumber - The page number to retrieve (1-based)
     * @param pageSize - Number of records per page (default 10)
     * @return PaginatedResult with accounts and pagination metadata
     */
    @AuraEnabled(cacheable=true)
    public static PaginatedResult searchAccountsPaginated(String searchTerm, Integer pageNumber, Integer pageSize) {
        try {
            PaginatedResult result = new PaginatedResult();
            
            // Set page size (default to 10 if not provided)
            result.pageSize = (pageSize != null && pageSize > 0) ? pageSize : 10;
            result.pageNumber = (pageNumber != null && pageNumber > 0) ? pageNumber : 1;
            
            // Calculate offset for pagination
            Integer offset = (result.pageNumber - 1) * result.pageSize;
            
            // Build query based on search term
            String queryString;
            String countQuery;
            
            if (String.isBlank(searchTerm)) {
                // Query all accounts
                queryString = 'SELECT Id, Name, AccountNumber FROM Account WITH SECURITY_ENFORCED ORDER BY Name LIMIT :pageSize OFFSET :offset';
                countQuery = 'SELECT COUNT() FROM Account WITH SECURITY_ENFORCED';
            } else {
                // Sanitize search term and prepare for LIKE query
                String sanitizedSearchTerm = '%' + String.escapeSingleQuotes(searchTerm) + '%';
                queryString = 'SELECT Id, Name, AccountNumber FROM Account WHERE Name LIKE :sanitizedSearchTerm WITH SECURITY_ENFORCED ORDER BY Name LIMIT :pageSize OFFSET :offset';
                countQuery = 'SELECT COUNT() FROM Account WHERE Name LIKE :sanitizedSearchTerm WITH SECURITY_ENFORCED';
            }
            
            // Execute queries
            result.records = Database.query(queryString);
            result.totalRecords = Database.countQuery(countQuery);
            
            // Calculate total pages
            result.totalPages = result.totalRecords > 0 ? 
                (Integer) Math.ceil((Decimal) result.totalRecords / result.pageSize) : 0;
            
            return result;
            
        } catch (Exception e) {
            // Log error and throw AuraHandledException for proper LWC error handling
            System.debug('Error in searchAccountsPaginated: ' + e.getMessage());
            throw new AuraHandledException('Error searching accounts: ' + e.getMessage());
        }
    }
    
    /**
     * Legacy method for backward compatibility
     * @deprecated Use searchAccountsPaginated instead
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchTerm) {
        PaginatedResult result = searchAccountsPaginated(searchTerm, 1, 100);
        return result.records;
    }
}
