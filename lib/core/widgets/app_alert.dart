import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AlertType {
  success,
  error,
  warning,
  info,
}

class AppAlert {
  static void show(
      BuildContext context, {
        required String message,
        AlertType type = AlertType.success,
        String? title,
        Duration duration = const Duration(seconds: 2),
      }) {

    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _AppAlertWidget(
        message: message,
        title: title ?? _defaultTitle(type),
        type: type,
        onDone: () => entry.remove(),
        duration: duration,
      ),
    );

    overlay.insert(entry);
  }


  static String _defaultTitle(AlertType type) {

    switch (type) {

      case AlertType.success:
        return "Success";

      case AlertType.error:
        return "Error";

      case AlertType.warning:
        return "Warning";

      case AlertType.info:
        return "Info";
    }
  }
}


// ==================================================
// ALERT WIDGET
// ==================================================

class _AppAlertWidget extends StatefulWidget {

  final String message;
  final String title;
  final AlertType type;
  final VoidCallback onDone;
  final Duration duration;


  const _AppAlertWidget({
    required this.message,
    required this.title,
    required this.type,
    required this.onDone,
    required this.duration,
  });


  @override
  State<_AppAlertWidget> createState() =>
      _AppAlertWidgetState();

}



class _AppAlertWidgetState extends State<_AppAlertWidget>
    with SingleTickerProviderStateMixin {


  late AnimationController _controller;

  late Animation<double> _fade;

  late Animation<Offset> _slide;



  @override
  void initState() {

    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );


    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );


    _slide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );


    _controller.forward();


    Future.delayed(
      widget.duration,
      _dismiss,
    );

  }



  void _dismiss() async {

    if (!mounted) return;


    await _controller.reverse();


    widget.onDone();

  }



  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }




  Color get _backgroundColor {

    switch(widget.type){

      case AlertType.success:
        return const Color(0xFFECFDF5);

      case AlertType.error:
        return const Color(0xFFFEF2F2);

      case AlertType.warning:
        return const Color(0xFFFFFBEB);

      case AlertType.info:
        return const Color(0xFFEFF6FF);

    }
  }





  Color get _accentColor {

    switch(widget.type){

      case AlertType.success:
        return AppColors.income;

      case AlertType.error:
        return AppColors.expense;

      case AlertType.warning:
        return const Color(0xFFF59E0B);

      case AlertType.info:
        return AppColors.primary;

    }

  }





  IconData get _icon {

    switch(widget.type){

      case AlertType.success:
        return Icons.check_circle_rounded;

      case AlertType.error:
        return Icons.cancel_rounded;

      case AlertType.warning:
        return Icons.warning_rounded;

      case AlertType.info:
        return Icons.info_rounded;

    }

  }





  @override
  Widget build(BuildContext context) {


    return Positioned(

      top: MediaQuery.of(context).padding.top + 16,

      left: 20,

      right: 20,


      child: FadeTransition(

        opacity: _fade,


        child: SlideTransition(

          position: _slide,


          child: Material(

            color: Colors.transparent,


            child: GestureDetector(

              onTap: _dismiss,


              child: Container(

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),


                decoration: BoxDecoration(

                  color: _backgroundColor,


                  borderRadius:
                  BorderRadius.circular(16),


                  border: Border.all(

                    color: _accentColor.withValues(
                      alpha: 0.25,
                    ),

                    width: 1.2,

                  ),



                  boxShadow: [

                    BoxShadow(

                      color: _accentColor.withValues(
                        alpha: 0.12,
                      ),

                      blurRadius: 20,

                      offset:
                      const Offset(0,6),

                    ),


                    const BoxShadow(

                      color: Color(0x0F000000),

                      blurRadius: 10,

                      offset:
                      Offset(0,2),

                    ),

                  ],


                ),



                child: Row(

                  children: [


                    Container(

                      width: 40,

                      height: 40,


                      decoration: BoxDecoration(

                        color:
                        _accentColor.withValues(
                          alpha: 0.12,
                        ),


                        borderRadius:
                        BorderRadius.circular(12),

                      ),


                      child: Icon(
                        _icon,
                        color: _accentColor,
                        size:22,
                      ),

                    ),



                    const SizedBox(width:12),



                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        mainAxisSize:
                        MainAxisSize.min,


                        children: [


                          Text(

                            widget.title,

                            style: TextStyle(

                              fontSize:13.5,

                              fontWeight:
                              FontWeight.w700,

                              color:_accentColor,

                            ),

                          ),



                          const SizedBox(height:2),



                          Text(

                            widget.message,

                            style:
                            const TextStyle(

                              fontSize:12.5,

                              color:
                              AppColors.textSec,

                              fontWeight:
                              FontWeight.w500,

                            ),

                          ),


                        ],

                      ),

                    ),




                    GestureDetector(

                      onTap:_dismiss,


                      child: Icon(

                        Icons.close,

                        size:16,


                        color:
                        _accentColor.withValues(
                          alpha:0.5,
                        ),

                      ),

                    )

                  ],

                ),

              ),

            ),

          ),

        ),

      ),

    );

  }

}