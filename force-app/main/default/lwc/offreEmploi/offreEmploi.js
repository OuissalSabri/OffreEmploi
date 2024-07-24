import { LightningElement, api, wire } from 'lwc';
import getJobOffersByCandidate from '@salesforce/apex/OffreEmploi.getJobOffersByCandidate';
import { NavigationMixin } from 'lightning/navigation';

export default class OffreEmploi extends NavigationMixin(LightningElement) {
    @api recordId; 
    jobOffers;
    error;

    @wire(getJobOffersByCandidate, { candidateId: '$recordId'})
    wiredJobOffers({ error, data }) {
        if (data) {
            this.jobOffers = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.jobOffers = undefined;
        }
    }

    handleJobOfferClick(event) {
        const jobId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: jobId,
                objectApiName: 'Offre_Emploi__c',
                actionName: 'view'
            }
        });
    }
}
