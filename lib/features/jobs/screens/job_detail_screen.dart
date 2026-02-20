import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';
import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';
import 'package:offline_first_service_job_manager/features/jobs/provider/jobs_provider.dart';
import 'package:offline_first_service_job_manager/features/jobs/screens/job_create_screen.dart';

class JobDetailScreen extends ConsumerWidget {
  final JobModel job;
  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(job.status);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Color(0xFF9E9E9E),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'JOB DETAIL',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            letterSpacing: 3,
            color: Color(0xFFE0E0E0),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: Color(0xFF00E5FF),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => JobCreateScreen(existingJob: job),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: statusColor.withAlpha(80),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    job.status.displayName.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              job.title,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              job.description,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Color(0xFF9E9E9E),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),

            // Info Grid
            const _SectionLabel('DETAILS'),
            const SizedBox(height: 12),
            _InfoRow(label: 'Created by', value: job.createdBy),
            _InfoRow(label: 'Version', value: '#${job.version}'),
            _InfoRow(label: 'Sync Status', value: job.syncStatus.displayName),
            if (job.lastSyncedAt > 0)
              _InfoRow(
                label: 'Last synced',
                value: DateTime.fromMillisecondsSinceEpoch(
                  job.lastSyncedAt,
                ).toLocal().toString().substring(0, 16),
              ),

            const SizedBox(height: 32),

            // Status Update Section
            const _SectionLabel('UPDATE STATUS'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: JobStatus.values.map((s) {
                final active = s == job.status;
                final c = _statusColor(s);
                return GestureDetector(
                  onTap: active
                      ? null
                      : () async {
                          final updated = job.copyWith(
                            status: s,
                            updatedAt: DateTime.now().millisecondsSinceEpoch,
                          );
                          await ref
                              .read(jobsProvider.notifier)
                              .updateJob(updated);
                          if (context.mounted) Navigator.pop(context);
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: active ? c.withAlpha(40) : const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: active ? c : const Color(0xFF333333),
                        width: active ? 1.5 : 0.5,
                      ),
                    ),
                    child: Text(
                      s.displayName.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: active ? c : const Color(0xFF666666),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(JobStatus status) {
    switch (status) {
      case JobStatus.open:
        return const Color(0xFF00E5FF);
      case JobStatus.assigned:
        return const Color(0xFF7B68EE);
      case JobStatus.inProgress:
        return const Color(0xFFFFD700);
      case JobStatus.done:
        return const Color(0xFF69FF47);
      case JobStatus.cancelled:
        return const Color(0xFFFF3D57);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 9,
        letterSpacing: 3,
        color: Color(0xFF444444),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Color(0xFF555555),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Color(0xFFB0B0B0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
