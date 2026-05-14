import 'package:flutter/material.dart';
import '../models/task.dart';

// TaskDetailScreen receives the task object and three callback functions.
// Callbacks let the detail screen trigger actions (edit, delete, complete)
// that actually modify state in the parent TaskListScreen.
class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  static const Color _primary = Color(0xFF00695C);

  // Priority colour mapping
  Color get _priorityColor {
    switch (widget.task.priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  // Category icon mapping
  IconData get _categoryIcon {
    switch (widget.task.category) {
      case 'School':
        return Icons.school;
      case 'Health':
        return Icons.favorite;
      case 'Work':
        return Icons.work;
      case 'Finance':
        return Icons.attach_money;
      default:
        return Icons.person;
    }
  }

  bool get _isOverdue =>
      !widget.task.isCompleted &&
      widget.task.dueDate.isBefore(DateTime.now());

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${widget.task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              widget.onDelete();  // triggers deletion in parent + pops this screen
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final dateStr =
        '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          // Edit button in AppBar
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Task',
            onPressed: widget.onEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title Card ─────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overdue banner
                    if (_isOverdue)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Colors.red, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'This task is overdue!',
                              style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),

                    // Task title
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _primary,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Status chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? Colors.green[50]
                            : Colors.orange[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: task.isCompleted
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      child: Text(
                        task.isCompleted ? '✓ Completed' : '⏳ Pending',
                        style: TextStyle(
                          color: task.isCompleted
                              ? Colors.green[700]
                              : Colors.orange[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Details Card ───────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _detailRow(Icons.notes, 'Description', task.description),
                    const Divider(height: 20),
                    _detailRow(_categoryIcon, 'Category', task.category),
                    const Divider(height: 20),
                    _detailRow(
                      Icons.flag,
                      'Priority',
                      task.priority,
                      valueColor: _priorityColor,
                    ),
                    const Divider(height: 20),
                    _detailRow(
                      Icons.calendar_today,
                      'Due Date',
                      dateStr,
                      valueColor: _isOverdue ? Colors.red : null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Action Buttons ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(task.isCompleted
                    ? Icons.undo
                    : Icons.check_circle),
                label: Text(task.isCompleted
                    ? 'Mark as Incomplete'
                    : 'Mark as Complete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: task.isCompleted
                      ? Colors.orange
                      : _primary,
                ),
                onPressed: () {
                  widget.onToggleComplete();
                  setState(() {}); // refresh this screen's UI
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit, color: _primary),
                label: const Text('Edit Task',
                    style: TextStyle(color: _primary)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: widget.onEdit,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Delete Task',
                    style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _confirmDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: a row showing an icon, label, and value
  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: _primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
