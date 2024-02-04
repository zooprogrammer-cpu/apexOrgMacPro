import { LightningElement,track } from 'lwc';
import getCurrencyData from '@salesforce/apex/CurrencyConverter.retrieveCurrencyConversionrates';
const options=
[
    {label:'USD',value:'USD'},
    {label:'EUR',value:'EUR'},
    {label:'CAD',value:'CAD'},
    {label:'GBP',value:'GBP'},
    {label:'INR',value:'INR'}
];
export default class HTTPCalloutLWC extends LightningElement {
    @track fromCurrencyValue;
    @track toCurrencyValue;
    @track options = options;
    @track toCurrencyOptions = options;
    @track conversionData;

    handleFromCurrencyChange(event) {
        this.fromCurrencyValue = event.detail.value;
        console.log('this.fromCurrencyValue =>', this.fromCurrencyValue);

    }

    handleToCurrencyChange(event) {
        this.toCurrencyValue = event.detail.value;
        console.log('this.toCurrencyValue =>', this.toCurrencyValue);
    }

    handleCurrencyConversion() {
        // rest api call
        const queryValue = `function=CURRENCY_EXCHANGE_RATE&from_currency=${this.fromCurrencyValue}&to_currency=${this.toCurrencyValue}`;
        const API_KEY =  `ENNH2GLEOOFFK1V6`;
        // fetch('https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=JPY&apikey=ENNH2GLEOOFFK1V6',
        fetch(`https://www.alphavantage.co/query?${queryValue}&apikey=${API_KEY}`,
        {
            method:"GET",
            headers : {
                "Content-type" : "application/json",
                "Authorization" : "OAuth 00D4x000008ZPFe!AQsAQEwHUiz4JEHbl4XwXA8tYZkfVRdIfIfIsZsGvDXfya_3.BbkqRVrBXVFWrrnLWmWBPe99dQKQe0eRRyX2tMoTl_YorpI\n"
                }
                // we get a response
        }).then((response) => {
            // we turn that response to json format
            return response.json();
        }).then((jsonResponse)=>{
            // use that jsonResponse to create an object
            let objData = {
                From_Currency_Name : '',
                From_Currency_Code : '',
                To_Currency_Name : '',
                To_Currency_Code : '',
                Last_Refreshed : '',
                Exchange_rate : ''
            };
            window.console.log('jsonresponse ==>' , JSON.stringify(jsonResponse));
            let exchangeData = jsonResponse['Realtime Currency Exchange Rate'];
            window.console.log('exchangeData ==>' + JSON.stringify(exchangeData));

            objData.From_Currency_Code=exchangeData['1. From_Currency Code'];
            objData.From_Currency_Name=exchangeData['2. From_Currency Name'];
            objData.To_Currency_Name=exchangeData['4. To_Currency Name'];
            objData.To_Currency_Code=exchangeData['3. To_Currency Code'];
            objData.Last_Refreshed=exchangeData['6. Last Refreshed'];
            objData.Exchange_rate=exchangeData['5. Exchange Rate'];
            this.conversionData=objData;
            window.console.log('objData => '+JSON.stringify(objData));


        }).catch((error)=>{
            window.console.log('callout error' ,JSON.stringify(error));
        })
    }
}