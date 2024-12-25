// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/models/article_model.dart';

// class NewsCard extends StatelessWidget {
//   final Article article;
//   final bool isHorizontal;

//   const NewsCard({
//     Key? key,
//     required this.article,
//     this.isHorizontal = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (isHorizontal) {
//       return Card(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.horizontal(
//                 left: Radius.circular(4),
//               ),
//               child: Image.network(
//                 article.urlToImage,
//                 width: 120,
//                 height: 120,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     width: 120,
//                     height: 120,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.error),
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       article.title,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       article.description,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: Image.network(
//               article.urlToImage,
//               width: double.infinity,
//               height: 200,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   width: double.infinity,
//                   height: 200,
//                   color: Colors.grey[300],
//                   child: const Icon(Icons.error),
//                 );
//               },
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.transparent,
//                   Colors.black.withOpacity(0.7),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 16,
//             left: 16,
//             right: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   article.title,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   article.description,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }