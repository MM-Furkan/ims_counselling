import { LightningElement, track } from 'lwc';

export default class VideoAndPresentation extends LightningElement {
    @track videoContent =[
        {name : 'A',label : 'What is an MBA? Why MBA?',Description : 'This is the first chapter from our recorded 4 days "IMS Signalling for VoLTE" course. For more information about the course please visit our website hhttps://apistraining.com/portfolio/im....',URL : '',Type: 'Video'},
        {name : 'B',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'},
        {name : 'C',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'},
        {name : 'D',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'},
        {name : 'E',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'},
        {name : 'F',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'},
        {name : 'G',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'}
    ]
    @track PdfContent =[
        {name : 'A',label : 'What is an MBA? Why MBA?',Description : 'This is the first chapter from our recorded 4 days "IMS Signalling for VoLTE" course. For more information about the course please visit our website hhttps://apistraining.com/portfolio/im....',URL : '',Type: 'Video'},
        {name : 'B',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'},
        {name : 'C',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'},
        {name : 'D',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'},
        {name : 'E',label : 'Career after MBA',Description : '',URL : '',Type: 'Video'}
    ]


    onVideoitemSelection(event){  
        console.log(event.detail);
        console.log('onVideoitemSelection -> ',JSON.parse(JSON.stringify(event)))
        //console.log('onVideoitemSelection -> ',JSON.stringify(event))
       // console.log('onVideoitemSelection -> ',JSON.stringify(this.VC))
    } 
    onPPTitemSelection(event){  
        console.log(event.detail);
        console.log('onPPTitemSelection -> ',JSON.parse(JSON.stringify(event.detail)))
    } 
}