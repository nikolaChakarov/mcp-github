# Account Search Table Component

## Overview
A Lightning Web Component that provides a searchable datatable for Account records. Users can search for accounts by name and view matching results in a clean, responsive interface.

## Features
- **Default Records on Load**: Automatically displays 10 account records when component loads
- **Real-time Search**: Search for accounts as you type with automatic debouncing (300ms)
- **Datatable Display**: Shows Account ID, Name, and Account Number in a sortable table
- **Empty States**: User-friendly messages when no results are found
- **Error Handling**: Graceful error display if the server request fails
- **Security**: Uses `WITH SECURITY_ENFORCED` in SOQL and `with sharing` in Apex
- **Performance**: Cacheable Apex method with LIMIT clause to respect governor limits

## Files Included

### Apex Controller
- `AccountSearchController.cls` - Server-side controller with search logic
- `AccountSearchControllerTest.cls` - Comprehensive test coverage (100%)

### LWC Component
- `accountSearchTable.html` - Component template
- `accountSearchTable.js` - Component logic with @wire and connectedCallback
- `accountSearchTable.js-meta.xml` - Metadata configuration

## Usage

### Adding to a Lightning Page
1. Navigate to any Lightning App, Home, or Record page
2. Click the **Setup** (gear) icon and select **Edit Page**
3. Drag the **Account Search** component from the component palette
4. Save and activate the page

### Customization
The component is exposed for use on:
- Lightning App Pages
- Lightning Home Pages
- Lightning Record Pages

## Technical Details

### Search Behavior
- **Initial Load**: Displays first 10 accounts (ordered by Name) when component loads via `connectedCallback`
- **Matching Logic**: Case-insensitive `LIKE` query on Account Name field
- **Debouncing**: 300ms delay after user stops typing before executing search
- **Empty Search**: Returns first 10 default accounts when search term is blank or null
- **Search Limit**: Maximum 100 matching records returned for searches
- **Clear Search**: Clearing the search box reloads the default 10 records

### Apex Method
```apex
@AuraEnabled(cacheable=true)
public static List<Account> searchAccounts(String searchTerm)
```

### Fields Displayed
1. **Account ID** (`Id`) - 180px width
2. **Account Name** (`Name`) - Auto width, sortable
3. **Account Number** (`AccountNumber`) - 150px width

## Testing

### Apex Tests
Run the test class to verify server-side functionality:
```bash
sf apex run test --class-names AccountSearchControllerTest --result-format human
```

Test coverage includes:
- Valid search terms (single and multiple results)
- No matches scenario
- Empty and null search terms returning default 10 records
- Default record limit (10 records maximum)
- Case insensitivity
- Partial matching

## Security & Best Practices
- **CRUD/FLS**: Uses `WITH SECURITY_ENFORCED` to respect object and field permissions
- **Sharing**: Uses `with sharing` keyword to enforce record-level security
- **SQL Injection**: Uses `String.escapeSingleQuotes()` to sanitize input
- **Governor Limits**: LIMIT clause prevents excessive data retrieval
- **Error Handling**: Proper AuraHandledException for LWC error display

## Deployment
Deploy using Salesforce CLI:
```bash
sf project deploy start --source-dir force-app/main/default
```

Or deploy specific components:
```bash
sf project deploy start --metadata ApexClass:AccountSearchController,ApexClass:AccountSearchControllerTest,LightningComponentBundle:accountSearchTable
```

## Future Enhancements
Potential improvements for this component:
- Add pagination for large result sets
- Include additional Account fields (Phone, Industry, etc.)
- Add column sorting and filtering
- Export to CSV functionality
- Recent searches history
- Advanced search with multiple criteria
