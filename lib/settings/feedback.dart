

// feedback()async{
//   final String recipientEmail = "shifananasreen06@gmail.com"; // Replace with the recipient's email
//   final String subject = "Subject of the email";
//   final String body = "Body of the email";

//   Future<void> _launchGmail() async {
//     String url = "mailto:$recipientEmail?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}";

//     try {
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         print('Could not launch $url');
//       }
//     } catch (e) {
//       print('Error launching email: $e');
//     }
//   }
// }
