import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';
import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';
import 'package:offline_first_service_job_manager/features/jobs/provider/jobs_provider.dart';

class JobCreateScreen extends ConsumerStatefulWidget {
  final JobModel? existingJob;
  const JobCreateScreen({super.key, this.existingJob});

  @override
  ConsumerState<JobCreateScreen> createState() => _JobCreateScreenState();
}

class _JobCreateScreenState extends ConsumerState<JobCreateScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _createdByController = TextEditingController();
  JobStatus _selectedStatus = JobStatus.open;
  bool _isSaving = false;

  bool get _isEditing => widget.existingJob != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final job = widget.existingJob!;
      _titleController.text = job.title;
      _descriptionController.text = job.description;
      _createdByController.text = job.createdBy;
      _selectedStatus = job.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _createdByController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);

    final now = DateTime.now().millisecondsSinceEpoch;
    final job = JobModel(
      id: widget.existingJob?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _selectedStatus,
      createdBy: _createdByController.text.trim().isEmpty
          ? 'field_tech'
          : _createdByController.text.trim(),
      scheuledAt: widget.existingJob?.scheuledAt ?? now,
      completedAt: widget.existingJob?.completedAt ?? 0,
      createdAt: widget.existingJob?.createdAt ?? now,
      updatedAt: now,
      version: widget.existingJob?.version ?? 0,
      isDeleted: false,
      lastSyncedAt: widget.existingJob?.lastSyncedAt ?? 0,
      syncStatus: SyncStatus.dirty,
    );

    if (_isEditing) {
      await ref.read(jobsProvider.notifier).updateJob(job);
    } else {
      await ref.read(jobsProvider.notifier).addJob(job);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 20, color: Color(0xFF9E9E9E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'EDIT JOB' : 'NEW JOB',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            letterSpacing: 3,
            color: Color(0xFFE0E0E0),
          ),
        ),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Color(0xFF00E5FF),
                      ),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _save,
                  child: const Text(
                    'SAVE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: Color(0xFF00E5FF),
                    ),
                  ),
                ),
        ],
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('JOB TITLE *'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                hint: 'e.g. Repair HVAC Unit — Floor 3',
                maxLines: 1,
              ),
              const SizedBox(height: 20),

              _label('DESCRIPTION'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _descriptionController,
                hint: 'What needs to be done?',
                maxLines: 4,
              ),
              const SizedBox(height: 20),

              _label('ASSIGNED BY'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _createdByController,
                hint: 'field_tech',
                maxLines: 1,
              ),
              const SizedBox(height: 24),

              _label('STATUS'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: JobStatus.values.map((s) {
                  final active = s == _selectedStatus;
                  final c = _statusColor(s);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedStatus = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? c.withAlpha(40)
                            : const Color(0xFF1A1A1A),
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
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 9,
        letterSpacing: 3,
        color: Color(0xFF444444),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: Color(0xFFE0E0E0),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: Color(0xFF444444),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
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
