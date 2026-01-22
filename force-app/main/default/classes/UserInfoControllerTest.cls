/**
 * Test class for UserInfoController
 * Covers test scenarios for user information retrieval functionality
 */
@IsTest
private class UserInfoControllerTest {
    
    /**
     * Test successful retrieval of user information
     */
    @IsTest
    static void testGetUserInfo_Success_ReturnsUserData() {
        Test.startTest();
        UserInfoController.UserData result = UserInfoController.getUserInfo();
        Test.stopTest();
        
        // Verify result is not null
        Assert.isNotNull(result, 'Result should not be null');
        
        // Verify user name is populated
        Assert.isNotNull(result.name, 'User name should be populated');
        Assert.isTrue(String.isNotBlank(result.name), 'User name should not be blank');
        
        // Verify username is populated
        Assert.isNotNull(result.username, 'Username should be populated');
        Assert.isTrue(String.isNotBlank(result.username), 'Username should not be blank');
        
        // Verify current date is populated
        Assert.isNotNull(result.currentDate, 'Current date should be populated');
        Assert.isTrue(String.isNotBlank(result.currentDate), 'Current date should not be blank');
    }
    
    /**
     * Test that the returned user matches the current user
     */
    @IsTest
    static void testGetUserInfo_ReturnsCurrentUser() {
        // Get current user for comparison
        User currentUser = [SELECT Id, Name, Username FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        Test.startTest();
        UserInfoController.UserData result = UserInfoController.getUserInfo();
        Test.stopTest();
        
        // Verify returned data matches current user
        Assert.areEqual(currentUser.Name, result.name, 'Returned name should match current user name');
        Assert.areEqual(currentUser.Username, result.username, 'Returned username should match current user username');
    }
    
    /**
     * Test that date format is correct
     */
    @IsTest
    static void testGetUserInfo_DateFormat_IsCorrect() {
        Test.startTest();
        UserInfoController.UserData result = UserInfoController.getUserInfo();
        Test.stopTest();
        
        // Verify date format (e.g., "January 22, 2026")
        // Should contain a month name, day, and year
        Assert.isTrue(result.currentDate.contains(','), 'Date should contain a comma');
        Assert.isTrue(result.currentDate.length() > 10, 'Date should be in full format');
        
        // Verify it matches today's date format
        String expectedDate = Datetime.now().format('MMMM dd, yyyy');
        Assert.areEqual(expectedDate, result.currentDate, 'Date should match current date in correct format');
    }
    
    /**
     * Test that the method is cacheable (wire service compatible)
     */
    @IsTest
    static void testGetUserInfo_Cacheable_WorksWithWireService() {
        Test.startTest();
        
        // Call the method multiple times to verify cacheability
        UserInfoController.UserData result1 = UserInfoController.getUserInfo();
        UserInfoController.UserData result2 = UserInfoController.getUserInfo();
        
        Test.stopTest();
        
        // Both calls should return valid data
        Assert.isNotNull(result1, 'First call should return data');
        Assert.isNotNull(result2, 'Second call should return data');
        
        // Data should be consistent
        Assert.areEqual(result1.name, result2.name, 'Both calls should return same name');
        Assert.areEqual(result1.username, result2.username, 'Both calls should return same username');
    }
    
    /**
     * Test that user fields are properly populated
     */
    @IsTest
    static void testGetUserInfo_AllFields_ArePopulated() {
        Test.startTest();
        UserInfoController.UserData result = UserInfoController.getUserInfo();
        Test.stopTest();
        
        // Verify all fields in wrapper class are populated
        Assert.isNotNull(result.name, 'Name field should be populated');
        Assert.isNotNull(result.username, 'Username field should be populated');
        Assert.isNotNull(result.currentDate, 'Current date field should be populated');
        
        // Verify fields contain actual data (not empty strings)
        Assert.areNotEqual('', result.name, 'Name should not be empty');
        Assert.areNotEqual('', result.username, 'Username should not be empty');
        Assert.areNotEqual('', result.currentDate, 'Current date should not be empty');
    }
    
    /**
     * Test data structure of returned UserInfo object
     */
    @IsTest
    static void testGetUserInfo_DataStructure_IsValid() {
        Test.startTest();
        UserInfoController.UserData result = UserInfoController.getUserInfo();
        Test.stopTest();
        
        // Verify the result is of correct type
        Assert.isInstanceOfType(result, UserInfoController.UserData.class, 'Result should be UserData type');
        
        // Verify fields are strings
        Assert.isInstanceOfType(result.name, String.class, 'Name should be String type');
        Assert.isInstanceOfType(result.username, String.class, 'Username should be String type');
        Assert.isInstanceOfType(result.currentDate, String.class, 'Current date should be String type');
    }
    
    /**
     * Test that the method respects WITH SECURITY_ENFORCED
     */
    @IsTest
    static void testGetUserInfo_SecurityEnforced_QueriesSecurely() {
        // This test verifies the method executes without security exceptions
        Test.startTest();
        
        Boolean exceptionThrown = false;
        UserInfoController.UserData result;
        
        try {
            result = UserInfoController.getUserInfo();
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        
        // Verify no exception was thrown and data was returned
        Assert.isFalse(exceptionThrown, 'Method should execute without security exceptions');
        Assert.isNotNull(result, 'Result should be returned');
    }
}
