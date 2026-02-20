import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';
import 'package:offline_first_service_job_manager/core/sync/sync_status_provider.dart';
import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';
import 'package:offline_first_service_job_manager/features/jobs/provider/jobs_provider.dart';
import 'package:offline_first_service_job_manager/features/jobs/screens/job_create_screen.dart';
import 'package:offline_first_service_job_manager/features/jobs/screens/job_detail_screen.dart';

class JobsListScreen extends ConsumerWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsProvider);
    final syncStatus = ref.watch(appSyncStatusProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Column(
        children: [
          _SyncStatusBar(syncStatus: syncStatus),
          Expanded(
            child: jobsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00E5FF),
                  strokeWidth: 1.5,
                ),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFFF3D57),
                      size: 36,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'FAILED TO LOAD JOBS',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        letterSpacing: 2,
                        color: Color(0xFFFF3D57),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      e.toString(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: Color(0xFF555555),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              data: (jobs) {
                if (jobs.isEmpty) {
                  return const _EmptyState();
                }
                return RefreshIndicator(
                  color: const Color(0xFF00E5FF),
                  backgroundColor: const Color(0xFF1A1A1A),
                  onRefresh: () => ref.read(jobsProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: jobs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return _JobCard(
                        job: job,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JobDetailScreen(job: job),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JobCreateScreen()),
        ),
        backgroundColor: const Color(0xFF00E5FF),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class _SyncStatusBar extends StatelessWidget {
  final SyncStatusState syncStatus;
  const _SyncStatusBar({required this.syncStatus});

  @override
  Widget build(BuildContext context) {
    if (syncStatus.isSyncing) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        color: const Color(0xFF1A2A1A),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Color(0xFF69FF47),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'SYNCING...',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                letterSpacing: 2,
                color: Color(0xFF69FF47),
              ),
            ),
          ],
        ),
      );
    }

    if (syncStatus.lastError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        color: const Color(0xFF2A1A1A),
        child: Text(
          'SYNC ERROR · ${syncStatus.lastError!.split('\n').first}',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: 1.5,
            color: Color(0xFFFF3D57),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    if (syncStatus.lastSyncedAt != null) {
      final time = syncStatus.lastSyncedAt!;
      final label =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        color: const Color(0xFF141414),
        child: Text(
          'LAST SYNCED · $label',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: 1.5,
            color: Color(0xFF444444),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF333333), width: 1),
            ),
            child: const Icon(
              Icons.work_outline_rounded,
              color: Color(0xFF444444),
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'NO JOBS FOUND',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              letterSpacing: 3,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to create a new job',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;
  const _JobCard({required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = job.status;
    final color = _statusColor(status);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          border: Border.all(color: color.withAlpha(60), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          job.title,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE0E0E0),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _SyncBadge(syncStatus: job.syncStatus),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.description,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFF666666),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _StatusChip(status: status, color: color),
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

class _StatusChip extends StatelessWidget {
  final JobStatus status;
  final Color color;
  const _StatusChip({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80), width: 0.5),
      ),
      child: Text(
        status.displayName.toUpperCase(),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: color,
        ),
      ),
    );
  }
}

class _SyncBadge extends StatelessWidget {
  final SyncStatus syncStatus;
  const _SyncBadge({required this.syncStatus});

  @override
  Widget build(BuildContext context) {
    if (syncStatus == SyncStatus.clean) return const SizedBox.shrink();

    final (icon, color) = switch (syncStatus) {
      SyncStatus.dirty => (
        Icons.cloud_upload_outlined,
        const Color(0xFFFFD700),
      ),
      SyncStatus.syncing => (Icons.sync, const Color(0xFF00E5FF)),
      SyncStatus.error => (Icons.cloud_off_outlined, const Color(0xFFFF3D57)),
      SyncStatus.clean => (Icons.check, Colors.transparent),
    };

    return Icon(icon, size: 14, color: color);
  }
}
