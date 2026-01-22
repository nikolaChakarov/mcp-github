import { LightningElement } from 'lwc';
import searchAccountsPaginated from '@salesforce/apex/AccountSearchController.searchAccountsPaginated';

// Define datatable columns
const COLUMNS = [
    { 
        label: 'Account ID', 
        fieldName: 'Id', 
        type: 'text',
        initialWidth: 180
    },
    { 
        label: 'Account Name', 
        fieldName: 'Name', 
        type: 'text',
        sortable: true
    },
    { 
        label: 'Account Number', 
        fieldName: 'AccountNumber', 
        type: 'text',
        initialWidth: 150
    }
];

const PAGE_SIZE = 10;

export default class AccountSearchTable extends LightningElement {
    searchTerm = '';
    columns = COLUMNS;
    accounts = [];
    error;
    
    // Pagination properties
    currentPage = 1;
    pageSize = PAGE_SIZE;
    totalRecords = 0;
    totalPages = 0;
    
    /**
     * Load default records when component initializes
     */
    connectedCallback() {
        this.loadAccounts();
    }
    
    /**
     * Load account records with pagination
     */
    loadAccounts() {
        searchAccountsPaginated({ 
            searchTerm: this.searchTerm, 
            pageNumber: this.currentPage,
            pageSize: this.pageSize
        })
            .then(result => {
                this.accounts = result.records;
                this.totalRecords = result.totalRecords;
                this.totalPages = result.totalPages;
                this.currentPage = result.pageNumber;
                this.error = undefined;
            })
            .catch(error => {
                this.error = 'Error loading accounts: ' + (error.body?.message || error.message);
                this.accounts = [];
                this.totalRecords = 0;
                this.totalPages = 0;
            });
    }
    
    /**
     * Handle search input change with debouncing
     * Updates searchTerm after user stops typing (300ms delay)
     */
    handleSearchChange(event) {
        // Clear any existing timeout
        if (this.delayTimeout) {
            clearTimeout(this.delayTimeout);
        }
        
        const searchValue = event.target.value;
        
        // Debounce the search - wait 300ms after user stops typing
        this.delayTimeout = setTimeout(() => {
            this.searchTerm = searchValue;
            this.currentPage = 1; // Reset to first page on new search
            this.loadAccounts();
        }, 300);
    }
    
    /**
     * Handle previous page button click
     */
    handlePreviousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.loadAccounts();
        }
    }
    
    /**
     * Handle next page button click
     */
    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.loadAccounts();
        }
    }
    
    /**
     * Computed property to check if there are records to display
     */
    get hasRecords() {
        return this.accounts && this.accounts.length > 0;
    }
    
    /**
     * Computed property for record count display
     */
    get recordCountDisplay() {
        if (this.totalRecords === 0) return 'No records';
        
        const startRecord = ((this.currentPage - 1) * this.pageSize) + 1;
        const endRecord = Math.min(this.currentPage * this.pageSize, this.totalRecords);
        
        return `Showing ${startRecord}-${endRecord} of ${this.totalRecords} records`;
    }
    
    /**
     * Computed property for empty state message
     */
    get emptyStateMessage() {
        if (this.searchTerm) {
            return `No accounts found matching "${this.searchTerm}"`;
        }
        return 'No accounts available';
    }
    
    /**
     * Computed property to disable previous button
     */
    get isPreviousDisabled() {
        return this.currentPage <= 1;
    }
    
    /**
     * Computed property to disable next button
     */
    get isNextDisabled() {
        return this.currentPage >= this.totalPages || this.totalPages === 0;
    }
    
    /**
     * Computed property for pagination info
     */
    get paginationInfo() {
        return `Page ${this.currentPage} of ${this.totalPages}`;
    }
}
