import 'package:flutter/material.dart';

class TitleValueWidget extends StatelessWidget {
  const TitleValueWidget({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      // maxLines: 3,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title : ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
