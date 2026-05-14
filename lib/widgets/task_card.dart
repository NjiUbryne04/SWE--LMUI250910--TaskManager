import 'package:flutter/material.dart';
import '../models/task.dart';

// TaskCard is the reusable widget displayed for each task in the ListView.
// It receives the task data and two callbacks from the parent.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete; // called when checkbox tapped
  final VoidCallback onTap;            // called when card tapped → navigate to detail

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onTap,
  });

  static const Color _primary = Color(0xFF00695C);

  // Returns a colour based on priority level
  Color get _priorityColor {
    switch (task.priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  // Returns an icon based on category
  IconData get _categoryIcon {
    switch (task.category) {
      case 'School':
        return Icons.school;
      case 'Health':
        return Icons.favorite;
      case 'Work':
        return Icons.work;
      case 'Finance':
        return Icons.attach_money;
      default:
        return Icons.person; // Personal
    }
  }

  bool get _isOverdue =>
      !task.isCompleted &&
      task.dueDate.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Card(
      // Overdue tasks get a red-tinted left border
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: _isOverdue
            ? const BorderSide(color: Colors.red, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Priority colour bar on the left
              Container(
                width: 4,
                height: 56,
                decoration: BoxDecoration(
                  color: _priorityColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: task.isCompleted
                            ? Colors.grey
                            : Colors.black87,
                        // Strikethrough for completed tasks
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Description preview
                    Text(
                      task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),

                    // Chips row: category + priority + due date
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        // Category chip
                        _chip(
                          icon: _categoryIcon,
                          label: task.category,
                          color: _primary,
                        ),
                        // Priority chip
                        _chip(
                          icon: Icons.flag,
                          label: task.priority,
                          color: _priorityColor,
                        ),
                        // Due date chip — red if overdue
                        _chip(
                          icon: _isOverdue
                              ? Icons.warning_amber_rounded
                              : Icons.calendar_today,
                          label:
                              '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                          color: _isOverdue ? Colors.red : Colors.blueGrey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Checkbox on the right
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onToggleComplete(),
                activeColor: _primary,
                shape: const CircleBorder(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: small coloured chip with icon and label
  Widget _chip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
