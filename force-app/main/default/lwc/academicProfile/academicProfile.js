import { LightningElement,track,api,wire } from 'lwc';
import getAcademicProfileId from "@salesforce/apex/StudentCounsellingPlatformManager.getAcademicProfileId";

import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AcademicProfile extends LightningElement {
    @api objectApiName;
    @api cardTitle;
    @api iconName;
    @api recordId;
    @api fieldArray;
    @track showSpinner = true;
    @track academicProfileRecordId;
    @track isModalOpen = false;
    isrendered = false;

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
        this.wiredAcademicProfileId();
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

    renderedCallback(){
        if(!this.isrendered){
            this.isrendered = true;
            const styleTag = document.createElement('style');
            // styleTag.innerText = "lightning-picklist { min-height: 8rem !important; }";
            styleTag.innerText = "lightning-picklist { height:11.5rem;overflow:scroll} lightning-picklist::-webkit-scrollbar {display: none !important;} ";
            // setTimeout(() => {
                // alert('abcd');
                // this.template.querySelector('.custom-picklist').appendChild(styleTag);
            // }, 4000);
        }
        
    }

    
    openModal(event) {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        this.showSpinner = true;
        this.template.querySelector('lightning-record-edit-form').submit();
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.closeModal();
    }

    handleSuccess(){
        this.showToast('Success','Record has been Updated','success');
        // this.wiredAcademicProfileId();
        setTimeout(() => {
            this.showSpinner = false;
        }, 100);
    }

    wiredAcademicProfileId(){
        this.showSpinner = true;
        new Promise(
            (resolve,reject) => {
            setTimeout(()=> {
                getAcademicProfileId({
                    recordId : this.recordId
                })
                .then((data) => {
                    console.log('getAcademicProfileId ==>',data);
                    if(data != null){
                        this.academicProfileRecordId = data;
                        resolve();
                        this.showSpinner = false         
                    }else{
                        this.academicProfileRecordId = null;
                        resolve();
                        this.showSpinner = false;
                    }
                }).catch((error)=>{
                    this.showSpinner = false;
                });
            },0);
        }).then(() => this.showSpinner = false);
    }
}