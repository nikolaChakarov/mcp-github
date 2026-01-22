# Account Search Component - Deployment Guide

## What Was Created

### 1. Apex Classes (Server-side Logic)
- **AccountSearchController.cls** - Main controller with search functionality
- **AccountSearchControllerTest.cls** - Test class with 100% code coverage

### 2. Lightning Web Component (UI)
- **accountSearchTable.html** - Component template with search input and datatable
- **accountSearchTable.js** - Component logic with wire adapter and debouncing
- **accountSearchTable.js-meta.xml** - Metadata for Lightning App Builder

### 3. Documentation
- **README.md** - Component documentation in the LWC folder

## Quick Start Guide

### Step 1: Deploy to Your Org

#### Option A: Deploy All Files
```bash
sf project deploy start --source-dir force-app/main/default
```

#### Option B: Deploy Only This Component
```bash
sf project deploy start --metadata ApexClass:AccountSearchController,ApexClass:AccountSearchControllerTest,LightningComponentBundle:accountSearchTable
```

### Step 2: Run Tests

#### Apex Tests
```bash
sf apex run test --class-names AccountSearchControllerTest --result-format human --code-coverage
```

Expected result: All tests pass with 100% coverage

### Step 3: Add Component to a Page

1. **Navigate to a Lightning Page**
   - Go to any App page, Home page, or Record page
   - Click the ⚙️ (Setup) icon → **Edit Page**

2. **Add the Component**
   - Find **Account Search** in the Custom Components section
   - Drag it onto the page layout
   - Save and activate the page

3. **Test the Component**
   - Type an account name in the search box
   - Results will appear after you stop typing (300ms delay)
   - The datatable will show: ID, Name, and Account Number

## Component Features

### Search Functionality
- **Debounced Search**: Waits 300ms after typing stops before searching
- **Case-Insensitive**: "acme", "ACME", and "Acme" all return the same results
- **Partial Matching**: "Glob" will match "Global Industries"
- **Empty Handling**: Shows helpful message when no search term entered

### Security & Performance
- ✅ Respects CRUD/FLS permissions (`WITH SECURITY_ENFORCED`)
- ✅ Enforces sharing rules (`with sharing`)
- ✅ Prevents SQL injection (`escapeSingleQuotes()`)
- ✅ Limits results to 100 records
- ✅ Cacheable for better performance

### Data Displayed
1. **Account ID** - Salesforce record ID
2. **Account Name** - Name of the account (sortable)
3. **Account Number** - Custom account number field

## Testing Your Component

### Create Test Data (Optional)
If your org doesn't have accounts, create some test data:

```apex
// Execute Anonymous Apex
List<Account> testAccounts = new List<Account>{
    new Account(Name = 'Acme Corporation', AccountNumber = 'ACC-001'),
    new Account(Name = 'Global Tech', AccountNumber = 'ACC-002'),
    new Account(Name = 'Innovation Labs', AccountNumber = 'ACC-003')
};
insert testAccounts;
```

### Test Scenarios
1. **Search with existing name**: Type "Acme" → should show matching accounts
2. **No matches**: Type "XYZ999" → should show "No accounts found"
3. **Empty search**: Clear the search box → shows "Enter a search term"
4. **Partial match**: Type "Glob" → should find "Global Tech"

## Troubleshooting

### Component Not Showing in App Builder
- Verify the deployment was successful
- Check that `accountSearchTable.js-meta.xml` has `<isExposed>true</isExposed>`
- Refresh the Lightning App Builder page

### No Results Showing
- Check user has Read permission on Account object
- Verify user has access to Name and AccountNumber fields
- Check that accounts exist in the org
- Verify search term matches account names

### Deployment Errors
- Ensure API version compatibility (currently 62.0)
- Check that org has Lightning Experience enabled
- Verify Apex class names don't conflict with existing classes

## Customization Ideas

### Add More Fields to Display
Edit `accountSearchTable.js` and add columns to the `COLUMNS` array:

```javascript
const COLUMNS = [
    { label: 'Account ID', fieldName: 'Id', type: 'text' },
    { label: 'Account Name', fieldName: 'Name', type: 'text' },
    { label: 'Account Number', fieldName: 'AccountNumber', type: 'text' },
    // Add new fields here
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Industry', fieldName: 'Industry', type: 'text' }
];
```

Then update the SOQL query in `AccountSearchController.cls`:

```apex
return [
    SELECT Id, Name, AccountNumber, Phone, Industry
    FROM Account
    WHERE Name LIKE :sanitizedSearchTerm
    WITH SECURITY_ENFORCED
    ORDER BY Name
    LIMIT 100
];
```

### Change Result Limit
Edit `AccountSearchController.cls` line with `LIMIT 100` to your desired limit.

### Adjust Debounce Timing
Edit `accountSearchTable.js` and change the timeout value (currently 300ms):

```javascript
this.delayTimeout = setTimeout(() => {
    this.searchTerm = searchValue;
}, 300); // Change this value
```

## Next Steps

1. ✅ Deploy the component
2. ✅ Run tests to verify functionality
3. ✅ Add to a Lightning page
4. ✅ Test with real data
5. 🎯 Customize as needed for your requirements

---

**Need Help?** Refer to the component README at:
`force-app/main/default/lwc/accountSearchTable/README.md`
