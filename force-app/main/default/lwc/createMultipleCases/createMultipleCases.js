import { LightningElement, wire, track, api } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

import Case_Object from '@salesforce/schema/Case';
import STATUS_FIELD  from '@salesforce/schema/Case.Status';
import CASE_ORIGIN from '@salesforce/schema/Case.Origin';
import CASE_Reason from '@salesforce/schema/Case.Reason';
import saveMultipleCases from '@salesforce/apex/addMultipleCasesController.saveMultipleCases';

export default class CreateMultipleCases extends LightningElement {
    @track cases=[];
    @api recordId;
    isLoading = false;

    @wire(getObjectInfo,{objectApiName:Case_Object})
    caseObjectInfo;

    @wire(getPicklistValues,{recordTypeId:'$caseObjectInfo.data.defaultRecordTypeId', fieldApiName: STATUS_FIELD})
    StatusPicklistValues;

    get getStatusPicklistValues(){
        return this.StatusPicklistValues?.data?.values;
    }

    @wire(getPicklistValues,{recordTypeId:'$caseObjectInfo.data.defaultRecordTypeId', fieldApiName: CASE_ORIGIN})
    OriginPicklistValues;

    get getOriginPicklistValues(){
        return this.OriginPicklistValues?.data?.values;
    }

    @wire(getPicklistValues,{recordTypeId:'$caseObjectInfo.data.defaultRecordTypeId', fieldApiName: CASE_Reason})
    ReasonPicklistValues;

    get getReasonPicklistValues(){
        return this.ReasonPicklistValues?.data?.values;
    }

    connectedCallback(){
        console.log('connected callback7');
        this.addNewCase();
    }
    addNewCase(event){
        this.cases.push({
            tempId:Date.now()
        })
    }

    deleteCase(event){
        console.log('delete case');
        console.log(event.target);
        console.log(event.target.dataset);
        console.log(event.target?.dataset.tempId);
        let tempId = event.target?.dataset.tempId;
        this.cases = this.cases.filter(a => a.tempId != tempId);

    }

    elementChangeHandler(event) {
        let contactRow = this.cases.find(a => a.tempId == event.target.dataset.tempId);
        if (contactRow) {
            contactRow[event.target.name] = event.target?.value;
        }
    }

    async submitClickHandler(event) {
        const allValid = this.checkControlsValidity();
        console.log('test1');
        console.log(allValid);
        if (allValid) {
            this.isLoading = true;
            this.cases.forEach(a => a.ContactId = this.recordId);
            let response = await saveMultipleCases({ cases: this.cases });
            if (response.isSuccess) {
                this.showToast('Cases saved successfully', 'Success', 'success');
                this.dispatchEvent(new CloseActionScreenEvent());
            }
            else {
                this.showToast('Something went wrong while saving cases - ' + response.message);
            }
            this.isLoading = false;
        }
        else {
            this.showToast('Please correct below errors to procced further.');
        }
    }

    checkControlsValidity() {
        let isValid = true,
            controls = this.template.querySelectorAll('lightning-input,lightning-combobox');

        controls.forEach(field => {
            if (!field.checkValidity()) {
                field.reportValidity();
                isValid = false;
            }
        });
        return isValid;
    }

    showToast(message, title = 'Error', variant = 'error') {
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }
}