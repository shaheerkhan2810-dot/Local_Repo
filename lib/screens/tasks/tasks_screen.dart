import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/task_provider.dart';
import 'package:apexforge/screens/tasks/widgets/task_tile.dart';
import 'package:apexforge/screens/tasks/widgets/pomodoro_timer_widget.dart';
import 'package:apexforge/screens/tasks/widgets/add_task_sheet.dart';
import 'package:apexforge/widgets/apex_empty_state.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todaysTasks = ref.watch(todaysTasksProvider);
    final allTasksAsync = ref.watch(taskListProvider);
    final allTasks = allTasksAsync.value ?? [];
    final pomodoroState = ref.watch(pomodoroProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'TASKS',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.accentGold,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accentGold,
          labelStyle: const TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'All'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTask,
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          if (pomodoroState.phase != PomodoroPhase.idle)
            const PomodoroTimerWidget(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Today tab
                todaysTasks.isEmpty
                    ? ApexEmptyState(
                        emoji: '✅',
                        title: 'No tasks today',
                        subtitle: 'Tap + to add your first task',
                        onAction: _showAddTask,
                        actionLabel: 'Add Task',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: todaysTasks.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) =>
                            TaskTile(task: todaysTasks[index]),
                      ),
                // All tab
                allTasks.isEmpty
                    ? ApexEmptyState(
                        emoji: '📋',
                        title: 'No tasks yet',
                        subtitle: 'Create your first task',
                        onAction: _showAddTask,
                        actionLabel: 'Add Task',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: allTasks.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) =>
                            TaskTile(task: allTasks[index]),
                      ),
                // Completed tab
                Builder(builder: (context) {
                  final completed =
                      allTasks.where((t) => t.isCompleted).toList();
                  return completed.isEmpty
                      ? const ApexEmptyState(
                          emoji: '🏆',
                          title: 'No completed tasks',
                          subtitle:
                              'Complete tasks to see them here',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: completed.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) =>
                              TaskTile(task: completed[index]),
                        );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
