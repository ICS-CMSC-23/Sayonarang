import 'package:flutter/material.dart';
import 'donor_donate.dart'; // Add the import for the donation page

class Organization {
  final String orgId;
  final String orgName;
  final String email;
  final String photoUrl;
  final String address;
  final String contactNumber;

  Organization({
    required this.orgId,
    required this.orgName,
    required this.email,
    required this.photoUrl,
    required this.address,
    required this.contactNumber,
  });
}

// class DonorHomePage extends StatefulWidget {
//   const DonorHomePage({super.key});

//   @override
//   _DonorHomePageState createState() => _DonorHomePageState();
// }

// class _DonorHomePageState extends State<DonorHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     final List<Organization> organizations = [
//       Organization(
//         orgId: '1',
//         orgName: 'John Doe',
//         email: 'johndoe@gmail.com',
//         photoUrl: 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
//         address: '123 Main St, City',
//         contactNumber: '123-456-7890',
//       ),
//       Organization(
//         orgId: '2',
//         orgName: 'Jane Smith',
//         email: 'janesmith@gmail.com',
//         photoUrl: 'https://example.com/photo2.jpg',
//         address: '456 Elm St, Town',
//         contactNumber: '987-654-3210',
//       ),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Organizations'),
//       ),
//       body: ListView.builder(
//         itemCount: organizations.length,
//         itemBuilder: (context, index) {
//           final organization = organizations[index];
//           return Padding(
//             padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DonorDonatePage(),
//                   ),
//                 );
//               },
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundImage: NetworkImage(organization.photoUrl),
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               organization.orgName,
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               children: [
//                                 Icon(Icons.location_on, color: Colors.grey),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     organization.address,
//                                     style: TextStyle(fontSize: 16),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               children: [
//                                 Icon(Icons.phone, color: Colors.grey),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   organization.contactNumber,
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               children: [
//                                 Icon(Icons.email, color: Colors.grey),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     organization.email,
//                                     style: TextStyle(fontSize: 16),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


class DonorHomePage extends StatefulWidget {
  final Function(int) onPageChange;

  const DonorHomePage({super.key, required this.onPageChange});

  @override
  _DonorHomePageState createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  @override
  Widget build(BuildContext context) {
    final List<Organization> organizations = [
      Organization(
        orgId: '1',
        orgName: 'John Doe',
        email: 'johndoe@gmail.com',
        photoUrl: 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
        address: '123 Main St, City',
        contactNumber: '123-456-7890',
      ),
      Organization(
        orgId: '2',
        orgName: 'Jane Smith',
        email: 'janesmith@gmail.com',
        photoUrl: 'https://example.com/photo2.jpg',
        address: '456 Elm St, Town',
        contactNumber: '987-654-3210',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Organizations'),
      ),
      body: ListView.builder(
        itemCount: organizations.length,
        itemBuilder: (context, index) {
          final organization = organizations[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: InkWell(
              onTap: () {
                widget.onPageChange(1); // Change to the Donate page
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(organization.photoUrl),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              organization.orgName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.grey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    organization.address,
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.phone, color: Colors.grey),
                                SizedBox(width: 8),
                                Text(
                                  organization.contactNumber,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.email, color: Colors.grey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    organization.email,
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
