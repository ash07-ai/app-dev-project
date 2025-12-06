// import 'package:flutter/material.dart';
// import '../../../core/constants/colors.dart';
// class CategoryList extends StatelessWidget {
//   final List<String> categories;
//   final int selectedIndex;
//   final Function(int) onCategorySelected;
//   const CategoryList({
//     super.key,
//     required this.categories,
//     required this.selectedIndex,
//     required this.onCategorySelected,
//   });
//   // Convert "beauty" -> "Beauty", "home-decoration" -> "Home Decoration"
//   String _formatCategoryName(String category) {
//     if (category == 'All') return 'All';
//     return category
//         .split('-')
//         .map(
//           (word) =>
//               word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
//         )
//         .join(' ');
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final isSelected = selectedIndex == index;
//           return GestureDetector(
//             onTap: () => onCategorySelected(index),
//             child: Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.only(
//                 left: index == 0 ? 16 : 8,
//                 right: index == categories.length - 1 ? 16 : 0,
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: isSelected ? AppColors.primary : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color:
//                       isSelected ? AppColors.primary : AppColors.textSecondary,
//                 ),
//               ),
//               child: Text(
//                 _formatCategoryName(categories[index]),
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : AppColors.textSecondary,
//                   fontWeight:
//                       isSelected ? FontWeight.bold : FontWeight.normal,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  String _formatCategoryName(String category) {
    if (category == 'All') return 'All';
    return category
        .split('-')
        .map((word) =>
            word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42, // smaller than before
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return Padding(
            padding: EdgeInsets.only(
              right: 8,
              left: index == 0 ? 0 : 0,
            ),
            child: GestureDetector(
              onTap: () => onCategorySelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primarySoft
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    _formatCategoryName(categories[index]),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primaryDark
                          : AppColors.textSecondary,
                    ),
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
