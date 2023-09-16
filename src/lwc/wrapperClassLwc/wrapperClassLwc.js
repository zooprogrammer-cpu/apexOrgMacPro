import { LightningElement, track, wire } from 'lwc';
import getAccContacts from '@salesforce/apex/WrapperClassDemo.fetchAccountContactDetails';
const columns = [
    // {
    //     label: 'Account Name',
    //     field: 'AccountLink',
    //     type: 'url',
    //     typeAttributes: {
    //         label: {
    //             fieldName: 'AccountName'
    //         },
    //         target: '_blank'
    //     }
    // },
    { label: 'Name', fieldName: 'accountLink', type: 'url',
    typeAttributes: { label: { fieldName: 'accountName' }, target: '_blank'} },


    {
        label: 'Account Name',
        fieldName: 'accountName',
    },

    {
        label: 'Type',
        fieldName: 'type',
    },
    {
        label: 'Total Contacts',
        fieldName: 'totalContacts', // api name comes from wrapper class
    },
    {
        label: 'Address',
        fieldName: 'billingAddress',
    }
]

export default class WrapperClassLwc extends LightningElement {
    @track columns = columns;
    @track data;
    @track error;
    @wire(getAccContacts)
    wiredAccountData({ error, data }) {
        if (data) {
            this.data = data;

        }
        else {
            this.error = error;
        }

    }

}