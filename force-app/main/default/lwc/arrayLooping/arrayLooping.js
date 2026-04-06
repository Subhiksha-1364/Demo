import { LightningElement,track } from 'lwc';

export default class ArrayLooping extends LightningElement {

@track course =['Apex','Java','LWC','Aura']
newCourse;
handleCourse(event)
{
   this.newCourse = event.target.value
}

handleClick()
{
    this.course.push(this.newCourse)
   // this.course = [...this.course,this.newCourse]
}

get isArray()
{
    return this.course.length > 0;
}
}