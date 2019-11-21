class Reminder {
  String reminderTitle;
  String userTopic;
  int triggerDate;

  String get title {
    return reminderTitle;
  }

  set title(String title) {
    this.reminderTitle = title;
  }

  String get topic {
    return userTopic;
  }

  set topic(String topic) {
    this.userTopic = topic;
  }

  int get date {
    return triggerDate;
  }

  set date(int date) {
    this.triggerDate = date;
  }
}
