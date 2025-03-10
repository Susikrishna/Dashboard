import 'package:flutter/material.dart';
import 'package:dashbaord/constants/enums/lost_and_found.dart';
import 'package:dashbaord/models/lost_and_found_model.dart';
import 'package:dashbaord/utils/normal_text.dart';
import 'package:dashbaord/widgets/custom_carousel.dart';
import 'package:go_router/go_router.dart';

class LostFoundItem extends StatelessWidget {
  const LostFoundItem(
      {super.key, required this.item, required this.currentUserEmail});

  final LostAndFoundModel item;
  final String currentUserEmail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/lnf/${item.lostOrFound.name}/${item.id}', extra: {
        'currentUserEmail': currentUserEmail,
        'lostOrFound': item.lostOrFound,
      }),
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => LostAndFoundItemScreen(
      //       currentUserEmail: currentUserEmail,
      //       id: item.id,
      //       lostOrFound: item.lostOrFound,
      //     ),
      //   ),
      // ),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 200,
        ),
        width: 160, // Fixed height
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(51, 51, 51, 0.10), // Shadow color
              offset: Offset(0, 4), // Offset in the x, y direction
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Using Expanded to ensure the Carousel takes the available space
            Expanded(
              child: CustomCarousel(
                images: item.images,
                fromMemory: false,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: NormalText(
                          text: item.itemName,
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: NormalText(
                          text: item.lostOrFound == LostOrFound.lost
                              ? 'Lost'
                              : 'Found',
                          size: 16,
                          color: const Color(0xB2FE724C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
