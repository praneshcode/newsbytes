import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newsapp/constants/color_constants.dart';

class MySearchBar2 extends StatefulWidget {
  final Function(String)? onSubmitted;
  final Function()? sortFunction;
  const MySearchBar2(
      {super.key, required this.onSubmitted, required this.sortFunction});

  @override
  State<MySearchBar2> createState() => _MySearchBar2State();
}

class _MySearchBar2State extends State<MySearchBar2> {
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // ignore: use_build_context_synchronously
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFD0D5DD),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter:
                  const ColorFilter.mode(Color(0xFF667085), BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: textController,
                focusNode: focusNode,
                onSubmitted: widget.onSubmitted,
                style: const TextStyle(
                  color: ColorConstants.darkTextColor,
                  fontSize: 15,
                  fontFamily: 'SF Pro Text',
                  height: 1.5,
                  letterSpacing: -0.32,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search articles, topics & headlines',
                  hintStyle: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 15,
                    fontFamily: 'SF Pro Text',
                    height: 1.5,
                    letterSpacing: -0.32,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.sortFunction,
              child: SvgPicture.asset(
                'assets/icons/sort.svg',
                colorFilter:
                    const ColorFilter.mode(Color(0xFF667085), BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
