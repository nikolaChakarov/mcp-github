import { LightningElement, wire } from 'lwc';
import getUserInfo from '@salesforce/apex/UserInfoController.getUserInfo';

export default class UserDisplay extends LightningElement {
    userName = '';
    userUsername = '';
    currentDate = '';
    error;
    
    /**
     * Wire service to fetch user information from Apex controller
     * Automatically invokes when component loads
     */
    @wire(getUserInfo)
    wiredUserInfo({ error, data }) {
        if (data) {
            // Successfully received user data
            this.userName = data.name;
            this.userUsername = data.username;
            this.currentDate = data.currentDate;
            this.error = undefined;
        } else if (error) {
            // Handle error
            this.error = 'Error loading user information: ' + (error.body?.message || error.message);
            this.userName = '';
            this.userUsername = '';
            this.currentDate = '';
        }
    }
    
    /**
     * Computed property to check if user data is loaded
     */
    get hasData() {
        return this.userName && this.userUsername && this.currentDate;
    }
    
    /**
     * Computed property for displaying user information status
     */
    get isLoading() {
        return !this.hasData && !this.error;
    }
}
