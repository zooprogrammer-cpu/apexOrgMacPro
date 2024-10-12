import { LightningElement, track } from 'lwc';
import createZoomMeeting from '@salesforce/apex/ZoomController.createZoomMeeting';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class AppointmentRegistration extends LightningElement {
    @track userName;
    @track userEmail;
    @track scheduledUserName;

    handleUserNameChange(event) {
        this.userName = event.target.value;
    }

    handleUserEmailChange(event) {
        this.userEmail = event.target.value;
    }

    handleScheduledUserNameChange(event) {
        this.scheduledUserName = event.target.value;
    }

    registerAppointment() {
        // Call Apex method to create Zoom meeting and generate Zoom URL
        createZoomMeeting({
            userName: this.userName,
            userEmail: this.userEmail,
            scheduledUserName: this.scheduledUserName
        })
          .then((zoomUrl) => {
              // Display the generated Zoom URL to the user
              this.showToast('Success', `Your Zoom URL: ${zoomUrl}`, 'success');
          })
          .catch((error) => {
              // Handle error
              this.showToast('Error', 'An error occurred', 'error');
          });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}