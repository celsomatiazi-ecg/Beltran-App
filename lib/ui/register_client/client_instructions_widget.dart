import 'package:flutter/material.dart';

import '/ui/app_constants/app_style.dart';
import 'components/client_instructions_page_four.dart';
import 'components/client_instructions_page_one.dart';
import 'components/client_instructions_page_three.dart';
import 'components/client_instructions_page_two.dart';

class ClientInstructionsWidget extends StatefulWidget {
  const ClientInstructionsWidget({super.key});

  @override
  State<ClientInstructionsWidget> createState() =>
      _ClientInstructionsWidgetState();
}

class _ClientInstructionsWidgetState extends State<ClientInstructionsWidget>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  final ValueNotifier<int> _currentPageIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Material(
        color: Colors.white,
        child: Column(
          spacing: 20,
          children: [
            Expanded(
              child: PageView(
                controller: _pageViewController,
                children: [
                  const ClientInstructionsPageOne(),
                  const ClientInstructionsPageTwo(),
                  const ClientInstructionsPageThree(),
                  const ClientInstructionsPageFour(),
                ],
              ),
            ),

            ValueListenableBuilder(
              valueListenable: _currentPageIndex,
              builder: (context, value, child) {
                return Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PageMarkerWidget(isActive: value == 0 ? true : false),
                    PageMarkerWidget(isActive: value == 1 ? true : false),
                    PageMarkerWidget(isActive: value == 2 ? true : false),
                    PageMarkerWidget(isActive: value == 3 ? true : false),
                  ],
                );
              },
            ),

            ValueListenableBuilder(
              valueListenable: _currentPageIndex,
              builder: (context, value, child) {
                return Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: value == 0
                            ? null
                            : () {
                                _updateCurrentPageIndex(
                                  --_currentPageIndex.value,
                                );
                              },
                        child: const Text("Voltar"),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (value == 3) {
                            Navigator.pop(context);
                            return;
                          }
                          _updateCurrentPageIndex(++_currentPageIndex.value);
                        },
                        child: Text(value == 3 ? "Entendi" : "Próximo"),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PageMarkerWidget extends StatelessWidget {
  final bool isActive;

  const PageMarkerWidget({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 25 : 20,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isActive ? AppStyle.primaryColor : Colors.black12,
      ),
    );
  }
}
