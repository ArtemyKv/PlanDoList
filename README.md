# PlanDo List
PlanDo List is an advanced task tracker and todo app 

## Features
- Create lists of task and organise them into groups
- Manage your groups in expandable reordable list divided into sections
- Set your tasks reminder and due dates, and also add them to "My day" list
- Track your tasks in four lists which filters them by different parameters: importance, myDay, reminders and due dates, income tasks with no list
- Track number of uncompleted tasks in different lists on main screen
- Track enabled task options ( subtasks, myDay, dates) in list screens
- Change appearance of your lists by choosing different color themes
- Search tasks in all lists (under development)
- Authorise in app with your email (under development)
 
 ## Screenshots
| Main screen | List screen | Task screen |
:---:|:---:|:---:
![Simulator Screen Recording - iPhone 14 Pro - 2023-04-04 at 23 09 26](https://user-images.githubusercontent.com/90643294/229880653-45341d3b-7054-4b70-b9b0-53f249f3ec99.gif) | ![Simulator Screen Recording - iPhone 14 Pro - 2023-04-04 at 23 11 02](https://user-images.githubusercontent.com/90643294/229881036-a1571307-aa93-4927-936a-d44e990041a9.gif) | ![Simulator Screen Recording - iPhone 14 Pro - 2023-04-04 at 23 15 48](https://user-images.githubusercontent.com/90643294/229882062-f2ab4c23-95f0-4dba-859b-67ce947e9555.gif)



 ## Technologies stack
 - UIKit
 - CoreData
 - MVP + Coordinator
 - SnapKit
 
 ## Description
 - Code organised in modules
 - Builder class for screen creating and injecting all dependencies
 - Protocol based programming to ease future testing
 - Coordinator pattern to remove navigation logic from view contollers and presenters
 - Programmatically-built UI (no storyboard)
 - Model layer based on CoreData
 - Expandable collection view for main screen with custom reordering feature which allows to reorder different types of items
 - Custom bottom sheet view with animations and gestures support for new task screen
 
 ## Requirements
 - iOS 14+
 - XCode 12+
