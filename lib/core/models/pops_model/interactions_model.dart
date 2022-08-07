class InteractionsModel {
  String imageurl;
  String name;
  String notification;
  String timing;

  InteractionsModel(
      {required this.imageurl,
      required this.name,
      required this.notification,
      required this.timing});
}

interactiondata() {
  List<InteractionsModel> interactionDetails = [];
  InteractionsModel dataModel =
      InteractionsModel(imageurl: '', name: '', notification: '', timing: '');

  // 1
  dataModel = InteractionsModel(
      imageurl:
          'https://images.unsplash.com/photo-1528183429752-a97d0bf99b5a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      name: 'Thewebions',
      notification: 'Liked your photo',
      timing: '30 minutes');
  interactionDetails.add(dataModel);

  dataModel = InteractionsModel(
      imageurl:
          'https://images.unsplash.com/photo-1528183429752-a97d0bf99b5a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      name: 'Thewebions',
      notification: 'Liked your photo',
      timing: 'Today');
  interactionDetails.add(dataModel);
  return interactionDetails;
}
