/**
 * Controller class for the User Display LWC component
 * Provides server-side functionality to fetch current user information and date
 */
public with sharing class UserInfoController {
    
    /**
     * Wrapper class to return user information
     */
    public class UserInfo {
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String username { get; set; }
        @AuraEnabled public String currentDate { get; set; }
        
        public UserInfo() {
            this.name = '';
            this.username = '';
            this.currentDate = '';
        }
    }
    
    /**
     * Retrieves the current logged-in user's information and current date
     * @return UserInfo wrapper with user name, username, and formatted current date
     */
    @AuraEnabled(cacheable=true)
    public static UserInfo getUserInfo() {
        try {
            UserInfo result = new UserInfo();
            
            // Query current user information
            User currentUser = [
                SELECT Id, Name, Username 
                FROM User 
                WHERE Id = :UserInfo.getUserId() 
                WITH SECURITY_ENFORCED 
                LIMIT 1
            ];
            
            // Populate user information
            result.name = currentUser.Name;
            result.username = currentUser.Username;
            
            // Format current date (e.g., "January 22, 2026")
            result.currentDate = Datetime.now().format('MMMM dd, yyyy');
            
            return result;
            
        } catch (Exception e) {
            // Log error and throw AuraHandledException for proper LWC error handling
            System.debug('Error in getUserInfo: ' + e.getMessage());
            throw new AuraHandledException('Error retrieving user information: ' + e.getMessage());
        }
    }
}
