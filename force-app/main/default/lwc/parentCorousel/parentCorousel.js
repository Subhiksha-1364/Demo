import { LightningElement } from 'lwc';
import sachinImg from '@salesforce/resourceUrl/sachin';
import viratImg from '@salesforce/resourceUrl/virat';
import dhoniImg from '@salesforce/resourceUrl/dhoni';
export default class ParentCorousel extends LightningElement {
player1 = [
    {
        name: 'Dhoni',
        team: 'CSK',
       img: dhoniImg
    },
    {
        name: 'Virat',
        team: 'RCB',
       img: viratImg
    },
    {
        name: 'Sachin',
        team: 'MI',
        img: sachinImg
    }
];

player2=[{
        name:'FAF DU PLESIS',
        team :'SA',
        no:17,
        img: dhoniImg


    },
    {
        name:'Suresh Raina',
        team :'CSK',
        no:3,
        img:sachinImg


    },
    {
        name: 'Sachin',
        team: 'MI',
        img: sachinImg
    }]



}