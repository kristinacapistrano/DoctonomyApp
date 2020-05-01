// Initialize Firebase Admin
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as moment from 'moment-timezone';
moment().format('dddd, MMMM Do YYYY, HH:mm');
admin.initializeApp();

const db = admin.firestore();
const settings = { timestampsInSnapshots: true };
db.settings(settings);

exports.sendReminderPushNotif = functions.pubsub
  .schedule('every 1 minutes')
  .onRun(async (context) => {
    try {
      const remindersCollection = await db.collection('reminders').get();
      let remindersDocuments = remindersCollection.docs.map((doc) =>
        doc.data()
      );

      for (const reminderSet of remindersDocuments) {
        reminderSet.reminders.forEach(async (reminder, index) => {
          try {
            if (reminder.uid != null) {
              const user = await getUser(reminder.uid);
              console.log(
                'User: ' + require('util').inspect(user, false, null, true)
              );
              const dev_tokens: any = user['dev-tokens'];
              const tokens: any = [];
              for (const token of dev_tokens) {
                if (!tokens.includes(token)) {
                  tokens.push(token);
                }
              }

              const endDateTime = moment(reminder.endDateTime.toDate()).tz(
                'America/Phoenix'
              );
              const startDateTime = moment(reminder.startDateTime.toDate()).tz(
                'America/Phoenix'
              );
              const nextTriggerDate = moment(
                reminder.nextTriggerDate.toDate()
              ).tz('America/Phoenix');

              console.log(
                'Current Time: ' +
                  require('util').inspect(
                    moment()
                      .tz('America/Phoenix')
                      .format('dddd, MMMM Do YYYY, hh:mm a'),
                    false,
                    null,
                    true
                  )
              );

              console.log(
                'Start Date Time: ' +
                  require('util').inspect(
                    startDateTime.format('dddd, MMMM Do YYYY, hh:mm a'),
                    false,
                    null,
                    true
                  )
              );

              console.log(
                'End Date Time: ' +
                  require('util').inspect(
                    endDateTime.format('dddd, MMMM Do YYYY, hh:mm a'),
                    false,
                    null,
                    true
                  )
              );

              console.log(
                'Next Trigger Time: ' +
                  require('util').inspect(
                    nextTriggerDate.format('dddd, MMMM Do YYYY, hh:mm a'),
                    false,
                    null,
                    true
                  )
              );

              if (moment().isBetween(startDateTime, endDateTime)) {
                console.log(
                  'Difference: ' +
                    Math.abs(moment().diff(nextTriggerDate, 'minutes'))
                );
                if (Math.abs(moment().diff(nextTriggerDate, 'minutes')) <= 2) {
                  console.log('Fire Notification');
                  const payload = {
                    notification: {
                      title: 'Doctonomy Reminder',
                      body: reminder.name,
                      sound: 'default',
                    },
                    data: {
                      click_action: 'FLUTTER_NOTIFICATION_CLICK',
                      data: 'Data',
                    },
                  };
                  await sendMsg(tokens, payload);

                  const newReminder = reminder;

                  const newTriggerDate = nextTriggerDate.add(
                    reminder.interval,
                    'day'
                  );

                  newReminder.nextTriggerDate = newTriggerDate;

                  const reminders = reminderSet;
                  reminders.reminders[index] = newReminder;

                  return await db
                    .collection('reminders')
                    .doc(reminder.uid)
                    .set(reminders);
                }
              }

              return null;
            } else {
              console.log('Reminder uid is null');
            }
          } catch (e) {
            console.log('Reminder object fetch failed: ' + e);
          }
        });
      }
    } catch (e) {
      console.log('Reminders collection fetch failed ' + e);
    }

    return null;
  });

/**
Read the user document from Firestore
*/
export const getUser = async (uid: string) => {
  return await db
    .collection('users')
    .doc(uid)
    .get()
    .then((doc) => doc.data());
};

/**
Send push notification to user device
*/
const sendMsg = (tokens, payload) => {
  return admin
    .messaging()
    .sendToDevice(tokens, payload)
    .then((response) => {
      console.log('Message response: ' + response);
      return response;
    })
    .catch((err) => {
      console.log('Message error: ' + err);
      return err;
    });
};
