import 'package:flutter/material.dart';
import './dismissible-job.dart';
import './job-action-button.dart';
import '../../scoped-models/mainmodel.dart';
import '../../models/task.dart';
import '../../dictionary.dart';
import '../../globalSettings.dart';
import '../../widgets/priority-indicator.dart';

class JobslistTask extends StatefulWidget {
  final MainModel model;
  final List<Task> tasks;
  final bool showCompletedOnly;

  JobslistTask({
    this.model,
    this.tasks,
    this.showCompletedOnly,
  });

  _JobslistTaskState createState() => _JobslistTaskState();
}

class _JobslistTaskState extends State<JobslistTask> {
  final Dictionary dict = Dictionary();
  final Settings settings = Settings();

  @override
  initState() {
    super.initState();
  }

  Widget _buildListTile(Task task, MainModel model) {
    return ListTile(
      leading: PriorityIndicator(task.priority),
      title: Text(task.name),
      trailing: JobActionButton(
        job: task,
        model: model,
        showCompletedOnly: widget.showCompletedOnly,
        isTaskNotDeadline: true,
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          "/task/${task.id}",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Task List
     * If the TaskList is generated within an Expanded Tile,
     * a scrollController is needed to be scrollable.
     * Because the Expanded needs to constrain the height of the List View.
     * Otherwise there would be two infinite Widgets nested in each other
     */
    return Expanded(
        child: widget.model.areTasksLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: widget.tasks.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => DismissibleJob(
                  model: widget.model,
                  jobs: widget.tasks,
                  index: index,
                  listTileBuildFunction: _buildListTile,
                ),
              ));
  }
}
