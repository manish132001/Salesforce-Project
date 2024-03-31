import { LightningElement, wire, api, track} from 'lwc';

import getAccountList from "@salesforce/apex/InfiniteLoading.InfiniteLoadingMethod";

const columns=[ 
    { label: 'Id', fieldName: 'Id' },
    { label: 'Name', fieldName: 'Name' }
];

export default class LazyLoading extends LightningElement {
    accounts = [
        
    ];
    columns=columns;
    rowSize=5;
    rowOffset=0;
    enableInfiniteloading=false;

    connectedCallback(){
        console.log('connected callback27');
        this.dataLoading();
        //this.wiredAccount;
    }



    async dataLoading(){
        try{
            let response = await getAccountList({limitSize : this.rowSize, offsetSize : this.rowOffset});
            console.log(response);
            console.log('response is '+response);
            console.log(Array.isArray(response));
            //if (Array.isArray(response)) {
            if(Array.isArray(response)){
                // for(let i=0;i<response.length; i++){
                //     console.log(response[i]);
                //     console.log(i);
                //     this.accounts.push(response[i]);
                // }

                // response.forEach(element => {
                //     console.log('hii '+ element);
                //     //accounts.push(element);
                // });
                // accounts=response;
                this.accounts=[...this.accounts, ...response];
                this.enableInfiniteloading=(response.length==this.rowSize || response.length!=0);
                console.log('Accounts are'+accounts);
            }
        }
        catch(error){
            console.log('Error is - ' + error);

        }
    }

    async loadMoreData(event){
        let target= event.target;
        target.isLoading=true;

        this.rowOffset = this.rowSize + this.rowOffset;
        await this.dataLoading();
        console.log('load more');

        target.isLoading=false;


    }

}