import { LightningElement, track, api, wire } from 'lwc';
import getaspirationId from "@salesforce/apex/StudentCounsellingPlatformManager.getaspirationId";
import getTargetAndInstitue from "@salesforce/apex/StudentCounsellingPlatformManager.getTargetAndInstitue";

import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class Aspiration extends LightningElement {
    @api objectApiName;
    @api cardTitle;
    @api iconName;
    @api recordId;
    @api fieldArray;
    @track showSpinner = true;
    @track academicProfileRecordId;
    @track isModalOpen = false;
    @track isModalOpenForTargetInstitue = false;
    @track targetInstitueIdRecordId = null;
    @track listTargetInstitue = null;

    constructor() {
        super();
    }
    connectedCallback() {
        setTimeout(() => {
            this.showSpinner = false;
        }, 1000);
        console.log('Aspiration ->', this.objectApiName);
        console.log('Aspiration ->', this.cardTitle);
        console.log('Aspiration ->', this.iconName);
        console.log('Aspiration ->', this.recordId);
        console.log('Aspiration ->', this.fieldArray);
        this.wiredAspirationId();
        
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

    wiredAspirationId() {
        this.showSpinner = true;
        new Promise(
            (resolve, reject) => {
                setTimeout(() => {
                    getaspirationId({
                        recordId: this.recordId
                    })
                        .then((data) => {
                            console.log('getaspirationId ==>', data);
                            if (data != null) {
                                this.aspirationRecordId = data;
                                resolve();
                                this.wiredTargetInstitue();
                                this.showSpinner = false
                            } else {    
                                this.academicProfileRecordId = null;
                                resolve();
                                this.showSpinner = false;
                            }
                        }).catch((error) => {
                            resolve();
                            this.showSpinner = false;
                        });
                }, 0);
            }).then(() => this.showSpinner = false);
    }

    wiredTargetInstitue(){
        this.listTargetInstitue = null;
        this.showSpinner = true;
        new Promise(
            (resolve,reject) => {
            setTimeout(()=> {
                getTargetAndInstitue({
                    aspirationRecordId : this.aspirationRecordId
                })
                .then((data) => {
                    console.log('wiredTargetInstitue ==>',data);
                    if(data != null){
                        this.listTargetInstitue = data;
                        resolve();
                        this.showSpinner = false         
                    }else{
                        this.listTargetInstitue = null;
                        resolve();
                        this.showSpinner = false;
                    }
                }).catch((error)=>{
                    this.listTargetInstitue = null;
                    this.showSpinner = false;
                    resolve();
                });
            },0);
        }).then(() => this.showSpinner = false);
    }

    openModal(event) {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        this.isModalOpenForTargetInstitue = false;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.isModalOpenForTargetInstitue = false;
    }
    openModalForTargetInstitue(event) {
        // to open modal set isModalOpen tarck value as true
        this.targetInstitueIdRecordId = event.target.dataset.id;
        this.isModalOpen = false;
        this.isModalOpenForTargetInstitue = true;
    }
    closeModalForTargetInstitue() {
        // to close modal set isModalOpen tarck value as false
        setTimeout(() => {
            this.wiredTargetInstitue();
            this.isModalOpen = false;
            this.isModalOpenForTargetInstitue = false;
        }, 10);
    }
    submitDetails() {
        this.showSpinner = true;
        this.template.querySelector('lightning-record-edit-form').submit();
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.closeModal();
    }

    submitDetailsForTargetInstitue() {
        this.showSpinner = true;
        this.template.querySelector('lightning-record-edit-form').submit();
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.closeModalForTargetInstitue();
    }

    handleSuccess(){
        this.showToast('Success','Record has been Updated','success');
        // this.wiredAcademicProfileId();
        setTimeout(() => {
            this.showSpinner = false;
        }, 100);
    }

    handleSuccessForTargetInstitue(){
        this.showToast('Success','Record has been Updated','success');
        // this.wiredAcademicProfileId();
        setTimeout(() => {
            this.showSpinner = false;
        }, 100);
    }
}