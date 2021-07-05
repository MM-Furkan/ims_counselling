import { LightningElement,track,api,wire } from 'lwc';
import counsellingStart from '@salesforce/resourceUrl/counsellingStart';
import createCounselling from "@salesforce/apex/StudentCounsellingPlatformManager.createCounselling";


import { ShowToastEvent } from "lightning/platformShowToastEvent";

import { refreshApex } from "@salesforce/apex";

export default class StudentCounsellingPlatformManager extends LightningElement {
    @track accountName;  
    @track accountRecordId="0010k000016HgrNAAS";  
    @track centerName;  
    @track centerRecordId;  
    @track productName;  
    @track productRecordId;  

    @track firsComponentSize;

    @track Counselling_id;
    @track Counselling_Centre_id;
    @track Counselling_Program_id;
    @track Profile_Discovery_id;

    // a variable to hold the value of current step.
    @track stepCounter = 1;
    @track stepValue = 'step'+this.stepCounter;

    @track imsStartImageURL = counsellingStart;
    
    showToast(toastTitle,toastMsg,toastType) {
        const event = new ShowToastEvent({
          title: toastTitle,
          message: toastMsg,
          variant: toastType,
          mode: "dismissable"
        });
        this.dispatchEvent(event);
      }
    
    constructor(){
        super();
        console.log('Constructor');
        console.log('imsStartImageURL',this.imsStartImageURL);
    }
    connectedCallback(){
        console.log('connected callback');
        this.firsComponentSize = 4;
    }
    
    onAccountSelection(event){  
        console.log('onAccountSelection -> ',JSON.parse(JSON.stringify(event.detail)))
        this.accountName = event.detail.selectedValue;  
        this.accountRecordId = event.detail.selectedRecordId;  
    }  
    onCenterSelection(event){  
        console.log('onCenterSelection -> ',JSON.parse(JSON.stringify(event.detail)))
        this.centerName = event.detail.selectedValue;  
        this.centerRecordId = event.detail.selectedRecordId;  
    }  
    onProductSelection(event){  
        console.log('onProductSelection -> ',JSON.parse(JSON.stringify(event.detail)))
        this.productName = event.detail.selectedValue;  
        this.productRecordId = event.detail.selectedRecordId;  
    }  



    // Button Function..

    // Start Button click function -> getting the selected student Id with Center and Course Value then start the conselling (Step 2).
    handleStartClick(event){

        console.log('handleStartClick ->');
        if(this.productRecordId==null || this.productRecordId=='' || this.productRecordId==undefined || this.centerRecordId==null || this.centerRecordId=='' || this.centerRecordId==undefined || this.accountRecordId == null || this.accountRecordId=='' || this.accountRecordId==undefined){
            this.showToast('All fields are mandetory','please select all fields','info');
        }else{
            this.firsComponentSize = 4;
            this.Counselling_id = null;
            this.Counselling_Centre_id = null;
            this.Counselling_Program_id =null;
            this.Profile_Discovery_id =null;
            this.showSpinner = true;
            new Promise(
                (resolve,reject) => {
                setTimeout(()=> {
                    createCounselling({
                        accountRecordId: this.accountRecordId,
                        centerRecordId: this.centerRecordId,
                        productRecordId: this.productRecordId
                    })
                    .then((data) => {
                        console.log('createCounselling ==>',data);
                        if(data.status == true){
                            this.showToast('Counselling created','Record has been Updated',data.message);
                            resolve();
                            this.Counselling_id = data.Counselling_id;
                            this.Counselling_Centre_id = data.Counselling_Centre_id;
                            this.Counselling_Program_id = data.Counselling_Program_id;
                            this.Profile_Discovery_id = data.Profile_Discovery_id;
                            this.firsComponentSize = 3;
                            this.showSpinner = false         
                        }else{
                            resolve();
                            this.Counselling_id = null;
                            this.Counselling_Centre_id = null;
                            this.Counselling_Program_id =null;
                            this.Profile_Discovery_id =null;
                            this.firsComponentSize = 4;
                            this.showSpinner = false;
                        }
                    }).catch((error)=>{
                        this.showSpinner = false;
                        this.firsComponentSize = 4;
                    });
                },0);
            }).then(() => this.showSpinner = false);
        }
    }


    // ------------ HELPER Function's ------------ //

    // function to go on the next step..
    nextStep(stepNumber){
        this.stepCounter++;
        this.stepValue ='step'+this.stepCounter;
        console.log('nextStep ->',this.stepValue);
        switch (this.stepCounter) {
            case 1:
                this.template.querySelector('.step1').classList.remove('slds-hide');
                this.template.querySelector('.step2').classList.add('slds-hide');
                this.template.querySelector('.step3').classList.add('slds-hide');
                break;
            case 2:
                this.template.querySelector('.step1').classList.add('slds-hide');
                this.template.querySelector('.step2').classList.remove('slds-hide');
                this.template.querySelector('.step3').classList.add('slds-hide');
                break;
            case 3:
                this.template.querySelector('.step1').classList.add('slds-hide');
                this.template.querySelector('.step2').classList.add('slds-hide');
                this.template.querySelector('.step3').classList.remove('slds-hide');
                break;
            default:
                break;
        }
    }

    // function to go on the previous step..
    previousStep(stepNumber){
        if(this.stepCounter == 1){

        }else{
            this.stepCounter--;
            this.stepValue ='step'+this.stepCounter;
            console.log('previousStep ->',this.stepValue);
            console.log('nextStep ->',this.stepValue);
            switch (this.stepCounter) {
                case 1:
                    this.template.querySelector('.step1').classList.remove('slds-hide');
                    this.template.querySelector('.step2').classList.add('slds-hide');
                    this.template.querySelector('.step3').classList.add('slds-hide');
                    break;
                case 2:
                    this.template.querySelector('.step1').classList.add('slds-hide');
                    this.template.querySelector('.step2').classList.remove('slds-hide');
                    this.template.querySelector('.step3').classList.add('slds-hide');
                    break;
                case 3:
                    this.template.querySelector('.step1').classList.add('slds-hide');
                    this.template.querySelector('.step2').classList.add('slds-hide');
                    this.template.querySelector('.step3').classList.remove('slds-hide');
                    break;
                default:
                    break;
            }
        }
    }

}