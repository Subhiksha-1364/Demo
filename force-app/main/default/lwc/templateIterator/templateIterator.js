import { LightningElement } from 'lwc';

export default class templateIterator extends LightningElement {

    concepts = [

        {
            id: 1,
            topic: 'Reactivity',
            component: ['@track']

        },
        {
            id: 2,
            topic: 'Parent-Child Communication',
            component:['@api']

        },
        {
            id: 3,
            topic: 'Child -Parent Communication',
            component: ['@custom dispatch event']

        },
        {
            id: 4,
            topic: 'Life cycle hooks',
            component:  ['Constructor',  'callback ',  'renderd',  'error']
        },


        {
            id: 5,
            topic: 'Lightning Data Service',
            component:  [ '@wire']
        }
    ]


}