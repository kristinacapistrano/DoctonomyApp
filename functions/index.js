const functions = require('firebase-functions');

exports.sendReminder = functions.firestore
  .document('reminders/{reminderId}')
  .onCreate((snap, context) => {
    // Get an object representing the document
    // e.g. {'name': 'Marie', 'age': 66}
    const reminderValue = snap.data();

    // access a particular field as you would any JS property
    const to = reminderValue.to;

    console.log(to);
  });
