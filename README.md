CelebrityBeerAndWings
=====================
Fun practice with core data and collection views.

Note that each of the input areas are dynamically created using a collection view. For example in the wing section this line in effect configures the section:
self.wingList = @[@"Hot",@"Medium",@"Mild",@"BBQ"]; 
You can add to this list, you can change the names, you can delete from it and the user interface will be updated to represent the changes. (Pretty cool!)
 
Persistence in this app is provided via Core Data and UIDocument. Table views are also populated using Core Data. The core data implementation style I adopted from a Stanford class example but I have modified it to work with a view controller that takes care of more than just the table view.
