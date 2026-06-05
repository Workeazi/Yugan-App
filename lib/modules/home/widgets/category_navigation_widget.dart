import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_theme_controller.dart';

class CategoryNavigationWidget extends StatefulWidget {
  const CategoryNavigationWidget({super.key});

  @override
  State<CategoryNavigationWidget> createState() => _CategoryNavigationWidgetState();
}

class _CategoryNavigationWidgetState extends State<CategoryNavigationWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = [];
  final GlobalKey _rowKey = GlobalKey();

  double _tabLeft = 0;
  double _tabWidth = 0;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<HomeThemeController>();
    for (int i = 0; i < controller.categories.length; i++) {
      _keys.add(GlobalKey());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateTabPosition(controller.selectedIndex.value);
        setState(() {
          _isInit = true;
        });
      }
    });
  }

  void _updateTabPosition(int index) {
    if (_keys.isEmpty || index < 0 || index >= _keys.length) return;
    
    final key = _keys[index];
    if (key.currentContext != null && _rowKey.currentContext != null) {
      final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
      final RenderBox rowRenderBox = _rowKey.currentContext!.findRenderObject() as RenderBox;
      
      final position = renderBox.localToGlobal(Offset.zero, ancestor: rowRenderBox);
      
      if (_tabLeft != position.dx || _tabWidth != renderBox.size.width) {
        setState(() {
          _tabLeft = position.dx;
          _tabWidth = renderBox.size.width;
        });
      }
    }
  }

  void _scrollToCenter(int index) {
    if (_keys.isEmpty || index < 0 || index >= _keys.length) return;
    final key = _keys[index];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        alignment: 0.5,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeThemeController>(
      id: 'categoryNav',
      builder: (controller) {
        // Trigger position update seamlessly on rebuild
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _updateTabPosition(controller.selectedIndex.value);
          }
        });

        return SizedBox(
          height: 48,
          child: Stack(
            children: [
              // Continuous white bottom border line
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // The Animated Active Tab Background
                    if (_isInit)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        left: _tabLeft,
                        bottom: 0, // Sits directly on the line
                        width: _tabWidth,
                        height: 24, // Exact height of the label padding box
                        child: CustomPaint(
                          painter: _ActiveTabPainter(color: Colors.white),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      
                    // Foreground Row (Icons and Texts)
                    Row(
                      key: _rowKey,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(controller.categories.length, (index) {
                        final category = controller.categories[index];
                        final isSelected = controller.selectedIndex.value == index;
                        
                        return GestureDetector(
                          onTap: () {
                            controller.selectCategory(index);
                            _scrollToCenter(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            color: Colors.transparent, // Ensures tap area works
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icon always outside and above the tab
                                Flexible(
                                  child: Icon(
                                    category.icon,
                                    color: Colors.white,
                                    size: 20, // Reduced to prevent overflow
                                  ),
                                ),
                                const SizedBox(height: 4), // Reduced spacing
                                // Invisible alignment box, the background tab matches this size
                                Container(
                                  key: _keys[index],
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOutCubic,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? category.primaryColor
                                          : Colors.white,
                                    ),
                                    child: Text(category.label),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActiveTabPainter extends CustomPainter {
  final Color color;

  _ActiveTabPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // The width of the extended curve on the bottom left and right
    const double curve = 12.0;
    const double radius = 12.0;

    final Path path = Path();
    
    // Start way left of the actual tab box
    path.moveTo(-curve, size.height);
    
    // Concave curve connecting bottom line to the left side of tab
    path.quadraticBezierTo(
      0, size.height, 
      0, size.height - curve
    );

    // Left straight line
    path.lineTo(0, radius);

    // Top left convex rounded corner
    path.quadraticBezierTo(
      0, 0,
      radius, 0
    );

    // Top straight line
    path.lineTo(size.width - radius, 0);

    // Top right convex rounded corner
    path.quadraticBezierTo(
      size.width, 0,
      size.width, radius
    );

    // Right straight line
    path.lineTo(size.width, size.height - curve);

    // Concave curve connecting right side to bottom line
    path.quadraticBezierTo(
      size.width, size.height,
      size.width + curve, size.height
    );

    // Close the path along the bottom
    path.lineTo(-curve, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ActiveTabPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
