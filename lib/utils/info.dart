import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoAkfa extends StatelessWidget {
  bool uni;

  InfoAkfa({Key? key, required this.uni}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(uni ? "Akfa University" : "Najot Ta'lim"),
        8.verticalSpace,
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.blue,
            ),
            8.horizontalSpace,
            Expanded(
                child: Text(uni
                    ? "Chulpan street, Tashkent, Uzbekistan"
                    : "76P3+6G4, Tashkent 100097, Uzbekistan"))
          ],
        ),
        8.verticalSpace,
        Row(
          children: [
            const Icon(
              Icons.web,
              color: Colors.blue,
            ),
            8.horizontalSpace,
            Text(uni ? "akfauniversity.org" : "najottalim.uz")
          ],
        ),
        8.verticalSpace,
        Row(
          children: [
            const Icon(
              Icons.phone,
              color: Colors.blue,
            ),
            8.horizontalSpace,
            Text(uni ? "+998712000123" : "+998712001123")
          ],
        )
      ],
    );
  }
}
