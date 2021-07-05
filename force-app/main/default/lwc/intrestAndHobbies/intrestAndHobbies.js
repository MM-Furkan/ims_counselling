import { LightningElement,track,api,wire } from 'lwc';
import getInterestAndHpobbies from "@salesforce/apex/StudentCounsellingPlatformManager.getInterestAndHpobbies";

import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class IntrestAndHobbies extends LightningElement {
    
    @api objectApiName;
    @api cardTitle;
    @api iconName;
    @api profileDiscoveryRecordId;
    @track hobbiesAndInterestrecordId;
    @api fieldArray;
    @track modaPopupTitle = 'New Interes and Hobbies'

    @track isModalOpen = false;
    @track showSpinner = true;
    @track listHobbies = null;

    constructor(){
        super();
    }
    connectedCallback(){
        setTimeout(() => {
            this.showSpinner = false;
        },1000);
        console.log('AcademicProfile ->',this.objectApiName);
        console.log('AcademicProfile ->',this.cardTitle);
        console.log('AcademicProfile ->',this.iconName);
        console.log('AcademicProfile ->',this.recordId);
        console.log('AcademicProfile ->',this.fieldArray);
        this.wiredInterestAndHpobbies();
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
        this.hobbiesAndInterestrecordId = event.target.dataset.id;
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
        this.wiredInterestAndHpobbies();
    }

    wiredInterestAndHpobbies(){
        this.showSpinner = true;
        new Promise(
            (resolve,reject) => {
            setTimeout(()=> {
                getInterestAndHpobbies({
                    profileDiscoveryRecordId : this.profileDiscoveryRecordId
                })
                .then((data) => {
                    console.log('wiredInterestAndHpobbies ==>',data);
                    if(data != null){
                        this.listHobbies = data;
                        resolve();
                        this.showSpinner = false         
                    }else{
                        this.listHobbies = null;
                        resolve();
                        this.showSpinner = false;
                    }
                }).catch((error)=>{
                    this.listHobbies = null;
                    this.showSpinner = false;
                    resolve();
                });
            },0);
        }).then(() => this.showSpinner = false);
    }

}