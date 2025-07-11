import 'package:flutter/material.dart';

import '../theme/text_style.dart';

class BannedScreen extends StatelessWidget {
  final String? reason;

  const BannedScreen({super.key, this.reason});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Warning Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.block, size: 80, color: Colors.red.shade600),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Access Denied',
                style: TextStyles.Inter28SemiBoldBlack.copyWith(
                  color: Colors.red.shade700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Main message
              Text(
                'You have been banned due to illegal behavior',
                style: TextStyles.Lato16extraBoldBlack.copyWith(
                  color: Colors.red.shade600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your IP address has been flagged for suspicious activity. Access to this application has been restricted.',
                      style: TextStyles.Lato16regularBlack.copyWith(
                        color: Colors.red.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (reason != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Reason: $reason',
                        style: TextStyles.Lato12extraBoldBlack.copyWith(
                          color: Colors.red.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Contact support section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.support_agent,
                      size: 32,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Contact Support',
                      style: TextStyles.Lato14extraBoldBlack.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'If you believe this is an error, please contact our support team for assistance.',
                      style: TextStyles.Lato12extraBoldBlack.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
