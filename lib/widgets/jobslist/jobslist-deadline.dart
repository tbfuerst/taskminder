import 'package:flutter/material.dart';
import './dismissible-job.dart';
import './job-action-button.dart';
import '../../scoped-models/mainmodel.dart';
import '../../models/deadline.dart';
import '../../dictionary.dart';
import '../../globalSettings.dart';
import '../../widgets/priority-indicator.dart';

class JobslistDeadline extends StatefulWidget {
  final MainModel model;
  final List<Deadline> deadlines;
  final bool showCompletedOnly;

  JobslistDeadline({this.model, this.deadlines, this.showCompletedOnly});

  _JobslistDeadlineState createState() => _JobslistDeadlineState();
}

class _JobslistDeadlineState extends State<JobslistDeadline> {
  final Dictionary dict = Dictionary();
  final Settings settings = Settings();
  final ScrollController _scroll2Controller = ScrollController();
  final isTask = false;

  @override
  initState() {
    super.initState();
  }

  Future<Null> updateCompletionStatus(
      Deadline _task, MainModel model, bool completedStatus) {
    _task.isCompleted = completedStatus;
    return model.updateDeadline(_task.id, _task);
  }

  Widget _buildListTile(Deadline task, MainModel model) {
    return ListTile(
      leading: PriorityIndicator(task.calculatedPriority),
      title: Text(task.name),
      subtitle: Text(task.getFormattedDeadline()[0].toString() +
          " " +
          dict.displayWord('days', settings.language) +
          ", " +
          task.getFormattedDeadline()[1].toString() +
          " " +
          dict.displayWord('hours', settings.language) +
          " " +
          dict.displayWord('remaining', settings.language) +
          "\n" +
          task.description),
      isThreeLine: true,
      trailing: JobActionButton(
        job: task,
        model: model,
        showCompletedOnly: widget.showCompletedOnly,
        isTaskNotDeadline: false,
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          "/deadlinedetail/${task.id}",
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
    return SingleChildScrollView(
      controller: _scroll2Controller,
      child: widget.model.areTasksLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: widget.deadlines.length,
              controller: _scroll2Controller,
              shrinkWrap: true,
              itemBuilder: (context, index) => DismissibleJob(
                model: widget.model,
                jobs: widget.deadlines,
                index: index,
                listTileBuildFunction: _buildListTile,
              ),
            ),
    );
  }
}
