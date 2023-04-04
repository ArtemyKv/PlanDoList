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
| Locations | Search | Weather Details |
:---:|:---:|:---:
![Simulator Screen Shot - iPhone 14 Pro - 2023-02-10 at 22 37 20](https://user-images.githubusercontent.com/90643294/218159027-b9c41b3d-7fe8-4693-8816-1bbdb06d96ba.png) | ![Simulator Screen Shot - iPhone 14 Pro - 2023-02-10 at 22 40 42](https://user-images.githubusercontent.com/90643294/218159427-aa01ead1-3bee-440f-92fd-c077b15f6c31.png) | ![Simulator Screen Shot - iPhone 14 Pro - 2023-02-10 at 22 41 41](https://user-images.githubusercontent.com/90643294/218159633-39562c59-816f-4d8a-b6e2-3474b1148e57.png)


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
