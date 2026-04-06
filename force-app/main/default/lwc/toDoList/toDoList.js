import { LightningElement, track } from 'lwc';

export default class ToDoList extends LightningElement {

    todoList = []
    taskName;
    taskId


    handleTask(event) {
        this.taskName = event.target.value
    }

    handleAdd() {

        if (!this.taskName) {
            alert('Enter  a task to add')
            return
        }
        this.taskId = this.todoList.length + 1
        let newTaskObj

        newTaskObj = {
            taskId: this.taskId,
            taskName: this.taskName
        }

        this.todoList = [...this.todoList, newTaskObj]

        this.taskName = ''



    }

    get isList() {
        return this.todoList.length > 0
    }

    handleDelete(event)
    {
        let iconId ;
        iconId = event.target.name
        this.todoList = this.todoList.filter(task => task.taskId != iconId)
    }
}