import 'package:flutter/material.dart';
import 'package:sira/dashboard/dashboard_demo_data.dart';
import 'package:sira/theme/app_palette.dart';

/// A placeholder preview of a single CV, opened from [CvCard]. Demo
/// content for now — swap for the real rendered CV once the builder
/// exists.
class CvViewPage extends StatelessWidget {
  const CvViewPage({super.key, required this.cv});

  final DemoCv cv;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.screenBackground,
      appBar: AppBar(
        backgroundColor: AppPalette.screenBackground,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(cv.name),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final padding = width * 0.06;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(padding * 0.5),
                      border: Border.all(color: AppPalette.border),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: width * 0.15,
                          color: AppPalette.accent,
                        ),
                        SizedBox(height: padding * 0.6),
                        Text(
                          cv.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: padding * 0.3),
                        Text(
                          cv.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54),
                        ),
                        SizedBox(height: padding),
                        Text(
                          'This is a placeholder preview — the full CV '
                          'will render here once the builder is connected.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
