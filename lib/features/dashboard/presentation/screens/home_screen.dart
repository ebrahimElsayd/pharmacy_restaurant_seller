// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mktabte/core/comman/entitys/categories.dart';
// import 'package:mktabte/features/home/presentation/riverpods/home_river_pod/home_riverpod.dart';
// import 'package:mktabte/features/home/presentation/riverpods/home_river_pod/home_riverpod_state.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home')),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await ref.read(homeRiverpodProvider.notifier).getAllCategories();
//         },
//         child: const _HomeContent(),
//       ),
//     );
//   }
// }

// class _HomeContent extends ConsumerWidget {
//   const _HomeContent();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isLoading = ref.watch(
//       homeRiverpodProvider.select((state) => state.isLoading()),
//     );
//     final categories = ref.watch(
//       homeRiverpodProvider.select((state) => state.categories),
//     );

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : const Column(
//                 children: [
//                   Text("data"),
//                   Text("data"),
//                   Text("data"),
//                   Text("data"),
//                 ],
//               ),
//         const Text("data"),
//         if (categories != null) _CategoryList(categories: categories),
//       ],
//     );
//   }
// }

// class _CategoryList extends StatelessWidget {
//   final List<Categories> categories;

//   const _CategoryList({required this.categories});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         itemBuilder: (context, index) => _CategoryCard(
//           category: categories[index],
//         ),
//       ),
//     );
//   }
// }

// class _CategoryCard extends StatelessWidget {
//   final Categories category;

//   const _CategoryCard({required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 160,
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               category.name,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Test Description for my categories',
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
