import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const fcm = admin.messaging();

export const sendReminder = functions.firestore
  .document('reminders/{reminderId}')
  .onCreate(async snapshot => {
    const reminderValue = snapshot.data();

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Doctonomy Reminder',
        body: `${reminderValue.reminderTitle}`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic(reminderValue.userTopic, payload);
  });
