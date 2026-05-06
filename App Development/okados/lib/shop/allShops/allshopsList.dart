// import 'package:flutter/material.dart';
// import 'package:okados/config/config.dart';
// import 'package:okados/dashboard/dashboard.dart';
// import 'package:okados/model/shopModel.dart' as shopModels;
// import 'package:shimmer/shimmer.dart';

// Widget ShopWidget(List<shopModels.Shop> shopsData) {
//   bool isLoading = shopsData.isEmpty;

//   return Container(
//     width: double.infinity,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Text(
//                 "All Restaurants",
//                 style: TextStyle(
//                   color: blackColor,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: SizedBox(
//                   width: 55,
//                   height: 25,
//                   child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         elevation: 5,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 3, vertical: 1),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15)),
//                         backgroundColor: whiteColor,
//                         textStyle: TextStyle(
//                             color: primaryColor,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w400),
//                       ),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Dashboard()));
//                         },
//                         child: Text(
//                           "All",
//                         ),
//                       )),
//                 )),
//           ],
//         ),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: isLoading
//                 ? List.generate(
//                     5,
//                     (index) => Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : shopsData.map((shop) {
//                     return Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Container(
//                         height: 100,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: shop.image.isNotEmpty
//                               ? Image.network(
//                                   shop.image[0].secureUrl,
//                                   fit: BoxFit.cover,
//                                   loadingBuilder:
//                                       (context, child, loadingProgress) {
//                                     if (loadingProgress == null) {
//                                       return child;
//                                     }
//                                     return Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   },
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Image.asset(
//                                       'assets/images/placeholder.png',
//                                       fit: BoxFit.cover,
//                                     );
//                                   },
//                                 )
//                               : Image.asset(
//                                   'assets/images/placeholder.png',
//                                   fit: BoxFit.cover,
//                                 ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//           ),
//         ),
//       ],
//     ),
//   );
// }
