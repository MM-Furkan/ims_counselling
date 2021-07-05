import { LightningElement,track,api,wire } from 'lwc';
import getAchivements from "@salesforce/apex/StudentCounsellingPlatformManager.getAchivements";

import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class Achivements extends LightningElement {
    @api objectApiName;
    @api cardTitle;
    @api iconName;
    @api profileDiscoveryRecordId;
    @track achivementsrecordId;
    @api fieldArray;
    @track modaPopupTitle = 'New Interes and Hobbies'

    @track isModalOpen = false;
    @track showSpinner = true;
    @track listAchivements = null;

    constructor(){
        super();
    }
    connectedCallback(){
        setTimeout(() => {
            this.showSpinner = false;
        },1000);
        console.log('Achivements ->',this.objectApiName);
        console.log('Achivements ->',this.cardTitle);
        console.log('Achivements ->',this.iconName);
        console.log('Achivements ->',this.recordId);
        console.log('Achivements ->',this.fieldArray);
        this.wiredAchivements();
    }

    showToast(toastTitle,toastMsg,toastType) {
        const event = new ShowToastEvent({
          title: toastTitle,
          message: toastMsg,
          variant: toastType,
          mode: "dismissable"
        });
        this.dispatchEvent(event);
      }
    
    addInterestAndHobbies(event){
        console.log('add Interest');
    }

    openModal(event) {
        this.achivementsrecordId = event.target.dataset.id;
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        this.template.querySelector('lightning-record-edit-form').submit();
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.closeModal();
    }

    handleSuccess(){
        this.showToast('Success','Record has been Updated','success');
        this.wiredAchivements();
    }

    wiredAchivements(){
        this.showSpinner = true;
        new Promise(
            (resolve,reject) => {
            setTimeout(()=> {
                getAchivements({
                    profileDiscoveryRecordId : this.profileDiscoveryRecordId
                })
                .then((data) => {
                    console.log('wiredInterestAndHpobbies ==>',data);
                    if(data != null){
                        this.listAchivements = data;
                        resolve();
                        this.showSpinner = false         
                    }else{
                        this.listAchivements = null;
                        resolve();
                        this.showSpinner = false;
                    }
                }).catch((error)=>{
                    this.listAchivements = null;
                    this.showSpinner = false;
                    resolve();
                });
            },0);
        }).then(() => this.showSpinner = false);
    }

}