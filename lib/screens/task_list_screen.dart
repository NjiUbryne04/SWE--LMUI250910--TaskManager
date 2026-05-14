import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  static const Color _primary = Color(0xFF00695C);

  // ── State Variables ────────────────────────────────────────────────────
  final List<Task> _tasks = [
    Task(
      title: 'Submit MAD Assignment',
      description: 'Complete and submit the Flutter task manager exercise.',
      category: 'School',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      title: 'Study Data Structures',
      description: 'Revise trees, graphs, and dynamic programming.',
      category: 'School',
      priority: 'Medium',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isCompleted: true,
    ),
    Task(
      title: 'Morning Jog',
      description: 'Run 3km every morning to stay fit.',
      category: 'Health',
      priority: 'Low',
      dueDate: DateTime.now().subtract(const Duration(days: 1)), // overdue
    ),
  ];

  String _filter = 'All'; // All | Pending | Completed
  String _sortBy = ''; // '' | 'dueDate' | 'priority'
  String _searchQuery = '';
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  // ── Computed filtered + sorted task list ───────────────────────────────
  List<Task> get _displayedTasks {
    List<Task> result = List.from(_tasks);

    // 1. Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // 2. Apply completion filter
    if (_filter == 'Pending') {
      result = result.where((t) => !t.isCompleted).toList();
    } else if (_filter == 'Completed') {
      result = result.where((t) => t.isCompleted).toList();
    }

    // 3. Apply sort
    if (_sortBy == 'dueDate') {
      result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (_sortBy == 'priority') {
      const order = {'High': 0, 'Medium': 1, 'Low': 2};
      result.sort(
          (a, b) => (order[a.priority] ?? 1).compareTo(order[b.priority] ?? 1));
    }

    return result;
  }

  // ── Task Operations ────────────────────────────────────────────────────
  void _toggleComplete(Task task) {
    setState(() => task.isCompleted = !task.isCompleted);
  }

  void _deleteTask(Task task) {
    setState(() => _tasks.remove(task));
  }

  void _clearAllTasks() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text(
            'Are you sure you want to delete ALL tasks? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _tasks.clear());
              Navigator.pop(ctx);
            },
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  // ── Add / Edit Task Bottom Sheet ───────────────────────────────────────
  void _showTaskForm({Task? existingTask}) {
    // Controllers pre-filled when editing
    final titleCtrl =
        TextEditingController(text: existingTask?.title ?? '');
    final descCtrl =
        TextEditingController(text: existingTask?.description ?? '');

    String category = existingTask?.category ?? 'School';
    String priority = existingTask?.priority ?? 'Medium';
    DateTime? dueDate = existingTask?.dueDate;
    bool showDateError = false;

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // allows bottom sheet to grow with keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        // StatefulBuilder lets us call setState inside the bottom sheet
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sheet handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        existingTask != null ? 'Edit Task' : 'Add New Task',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      TextFormField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Title is required'
                                : null,
                      ),
                      const SizedBox(height: 12),

                      // Description
                      TextFormField(
                        controller: descCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.notes),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Description is required'
                                : null,
                      ),
                      const SizedBox(height: 12),

                      // Category dropdown
                      DropdownButtonFormField<String>(
                        initialValue: category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: ['School', 'Personal', 'Health', 'Work', 'Finance']
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setSheet(() => category = v!),
                        validator: (v) =>
                            v == null ? 'Select a category' : null,
                      ),
                      const SizedBox(height: 12),

                      // Priority dropdown
                      DropdownButtonFormField<String>(
                        initialValue: priority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          prefixIcon: Icon(Icons.flag),
                        ),
                        items: ['Low', 'Medium', 'High']
                            .map((p) =>
                                DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) => setSheet(() => priority = v!),
                        validator: (v) =>
                            v == null ? 'Select a priority' : null,
                      ),
                      const SizedBox(height: 12),

                      // Date picker button
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: dueDate ?? DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setSheet(() {
                              dueDate = picked;
                              showDateError = false;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: showDateError
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 18,
                                  color: Colors.grey[600]),
                              const SizedBox(width: 10),
                              Text(
                                dueDate != null
                                    ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                                    : 'Pick Due Date *',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: dueDate != null
                                      ? Colors.black87
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (showDateError)
                        const Padding(
                          padding: EdgeInsets.only(top: 4, left: 4),
                          child: Text(
                            'Due date is required',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(existingTask != null
                              ? Icons.save
                              : Icons.add_task),
                          label: Text(
                            existingTask != null ? 'Update Task' : 'Add Task',
                          ),
                          onPressed: () {
                            final isFormValid =
                                formKey.currentState!.validate();
                            if (dueDate == null) {
                              setSheet(() => showDateError = true);
                            }
                            if (isFormValid && dueDate != null) {
                              setState(() {
                                if (existingTask != null) {
                                  // Edit: update fields of the existing task object
                                  existingTask.title = titleCtrl.text.trim();
                                  existingTask.description =
                                      descCtrl.text.trim();
                                  existingTask.category = category;
                                  existingTask.priority = priority;
                                  existingTask.dueDate = dueDate!;
                                } else {
                                  // Add: create a new Task and add to list
                                  _tasks.add(Task(
                                    title: titleCtrl.text.trim(),
                                    description: descCtrl.text.trim(),
                                    category: category,
                                    priority: priority,
                                    dueDate: dueDate!,
                                  ));
                                }
                              });
                              Navigator.pop(sheetCtx);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Sort Dialog ────────────────────────────────────────────────────────
  void _showSortMenu() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Sort Tasks By'),
        children: [
          _sortOption(ctx, 'Due Date (Earliest First)', 'dueDate'),
          _sortOption(ctx, 'Priority (High → Low)', 'priority'),
          _sortOption(ctx, 'None (Default)', ''),
        ],
      ),
    );
  }

  Widget _sortOption(BuildContext ctx, String label, String value) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() => _sortBy = value);
        Navigator.pop(ctx);
      },
      child: Row(
        children: [
          Icon(
            _sortBy == value ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: _primary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }

  // ── Statistics Bar ─────────────────────────────────────────────────────
  Widget _buildStatsBar() {
    final total = _tasks.length;
    final completed = _tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('Total', total.toString(), Colors.blueGrey),
              _statItem('Completed', completed.toString(), _primary),
              _statItem('Pending', pending.toString(), Colors.orange),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              color: _primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% complete',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // ── Filter Buttons ─────────────────────────────────────────────────────
  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: ['All', 'Pending', 'Completed']
            .map((f) => _filterChip(f))
            .toList(),
      ),
    );
  }

  Widget _filterChip(String label) {
    final selected = _filter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _filter = label),
        selectedColor: _primary,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            _filter == 'All' ? 'No tasks yet!' : 'No $_filter tasks.',
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a task.',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final tasks = _displayedTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              )
            : const Text('My Tasks'),
        actions: [
          // Search toggle
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: _isSearching ? 'Close search' : 'Search',
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchQuery = '';
                _searchController.clear();
              });
            },
          ),
          // Sort icon
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort tasks',
            onPressed: _showSortMenu,
          ),
          // Clear all icon
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear all tasks',
            onPressed: _tasks.isEmpty ? null : _clearAllTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsBar(),
          _buildFilterRow(),
          Expanded(
            child: tasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: tasks.length,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (ctx, index) {
                      final task = tasks[index];
                      return Dismissible(
                        // key must be unique per item
                        key: ValueKey(task.title + task.dueDate.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 28),
                        ),
                        confirmDismiss: (_) async {
                          // Optional confirmation before swipe-delete
                          return await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: Text(
                                  'Delete "${task.title}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  onPressed: () =>
                                      Navigator.pop(ctx, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) => _deleteTask(task),
                        child: TaskCard(
                          task: task,
                          onToggleComplete: () => _toggleComplete(task),
                          onTap: () {
                            // Navigate to detail screen, passing callbacks
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailScreen(
                                  task: task,
                                  onToggleComplete: () =>
                                      _toggleComplete(task),
                                  onDelete: () {
                                    _deleteTask(task);
                                    Navigator.pop(context);
                                  },
                                  onEdit: () {
                                    Navigator.pop(context);
                                    // Small delay to let navigation complete
                                    Future.delayed(
                                      const Duration(milliseconds: 150),
                                      () => _showTaskForm(existingTask: task),
                                    );
                                  },
                                ),
                              ),
                            ).then((_) => setState(() {}));
                            // setState on return ensures UI reflects any changes
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
