## Greeting Tracker

An App by Mchael Rowe, the goal of this app is to create an easy to use way of tracking the various greeting cards you may send out; while also helping me learn SwiftData.

I am opensourcing the code, in order to learn from others.  Note there are two package Dependencies, that I would like to remove over time.

### Known bugs:
1. Bug in macOS - can’t access Camera even if setting says permitted
2. Bag in macOS - if you change the name of a card, you lose the picture and can’t update

### Things to Test:
1. You can now create a new event when adding a card to the gallery.  What do you think of the User Experience? (feature - Add to both the Event and Card Pickers in the Recipient view - ability to add a new item)

### Things yet to come:
1. Correct VisionOS layout issues
2. Resolve issue with Receipient Title, with Cards Sent, changing from color to black
3. Bug Fix - on the delete for the Card App - Issue is that the Events list needs to remove the array element after the Child is deleted
4. Update the slide view to fill the slide with the card image and make the click on the image give you the full screen view
5. Paper cut fix - do not allow the URL text field to capitalize things automatically

### Potential Features to develop:
1. Add filter by name option in the Card picker view
2. Add card name to the add Card to receipient view
3. Add classification to card app. And the group by it. Ie work, family, friends. Etc.
4. Add an app intent to show a gallery of a specific event type’s cards
5. Add ability to click on a card in the gallery and see all the people it was sent to and when
6. Add a date range to the PDF Print option so you can print all Christmas cards for a specific year (as an example)
7. Add pop-up menus for edit on address
8. Change Card overlays to be pop-up menus
9. Add overlay information on name, vendor etc. to full screen card
