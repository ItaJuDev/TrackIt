import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryControls extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onDateSelect;

  const SummaryControls({
    required this.selectedDate,
    required this.onPrev,
    required this.onNext,
    required this.onDateSelect,
    super.key,
  });

  @override
  State<SummaryControls> createState() => _SummaryControlsState();
}

class _SummaryControlsState extends State<SummaryControls> {
  late DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    _lastDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(covariant SummaryControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _lastDate = oldWidget.selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isForward = widget.selectedDate.isAfter(_lastDate);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: widget.onPrev,
          ),
          GestureDetector(
            onTap: widget.onDateSelect,
            child: SizedBox(
              width: 120,
              height: 30,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: Offset(isForward ? 1 : -1, 0),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ...previousChildren.map(
                        (child) => FadeTransition(
                          opacity: const AlwaysStoppedAnimation(0.0),
                          child: child,
                        ),
                      ),
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                child: Text(
                  DateFormat('MMM yyyy').format(widget.selectedDate),
                  key: ValueKey<String>(
                    DateFormat('MMM yyyy').format(widget.selectedDate),
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: widget.onNext,
          ),
        ],
      ),
    );
  }
}
