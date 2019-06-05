import 'package:bloc/bloc.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Logger.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';


class AddTaskScreenBloc extends Bloc<AddTaskEvent, AddTaskState> {
  TaskRepository _eventRepository = diResolver.resolve();
  Logger _logger = diResolver.resolve();

  @override
  AddTaskState get initialState => InitState();

  @override
  Stream<AddTaskState> mapEventToState(AddTaskEvent event) async* {
    try {
      if (event is AddDailyTaskEvent) {
        yield RequestingState();
        await createDailyTask(event.addTaskPresentationModel);
        yield SuccessState();
      } else if (event is AddOneTimeTaskEvent) {
        yield RequestingState();
        await createOneTimeTask(event.addTaskPresentationModel);
        yield SuccessState();
      } else {
        yield InitState();
      }
    } catch (error, stackTrace) {
      yield FailState();
      _logger.logError(error, stackTrace);
    }
  }

  Future<void> createDailyTask(
      AddDailyTaskPresentationModel addTaskPresentationModel) async {
    await Future.delayed(Duration(seconds: 10));
    throw Exception("createDailyTask error");
    //await _eventRepository.createDailyTask(_mapDailyTask(addTaskPresentationModel));
  }

  Future<void> createOneTimeTask(
      AddOneTimeTaskPresentationModel addTaskPresentationModel) async {
    await _eventRepository
        .createOneTimeTask(_mapOneTimeTask(addTaskPresentationModel));
  }

  SaveDailyTaskDomainModel _mapDailyTask(
      AddDailyTaskPresentationModel addEventPresentationModel) {
    return SaveDailyTaskDomainModel(
      addEventPresentationModel.name,
      addEventPresentationModel.expiredHour,
      addEventPresentationModel.expiredMinute,
      addEventPresentationModel.monday,
      addEventPresentationModel.tuesday,
      addEventPresentationModel.wednesday,
      addEventPresentationModel.thursday,
      addEventPresentationModel.friday,
      addEventPresentationModel.saturday,
      addEventPresentationModel.sunday,
    );
  }

  SaveOneTimeTaskDomainModel _mapOneTimeTask(
      AddOneTimeTaskPresentationModel addTaskPresentationModel) {
    return SaveOneTimeTaskDomainModel(
      addTaskPresentationModel.name,
      addTaskPresentationModel.expiredHour,
      addTaskPresentationModel.expiredMinute,
      addTaskPresentationModel.expiredDay,
      addTaskPresentationModel.expiredMonth,
      addTaskPresentationModel.expiredYear,
    );
  }
}


abstract class AddTaskEvent {

}

class AddDailyTaskEvent extends AddTaskEvent {
  AddDailyTaskPresentationModel _addTaskPresentationModel;

  AddDailyTaskEvent(this._addTaskPresentationModel);

  AddDailyTaskPresentationModel get addTaskPresentationModel =>
      _addTaskPresentationModel;
}


class AddOneTimeTaskEvent extends AddTaskEvent {
  AddOneTimeTaskPresentationModel _addTaskPresentationModel;

  AddOneTimeTaskEvent(this._addTaskPresentationModel);

  AddOneTimeTaskPresentationModel get addTaskPresentationModel =>
      _addTaskPresentationModel;
}


abstract class AddTaskState {

}

class SuccessState extends AddTaskState {

}

class FailState extends AddTaskState {

}

class RequestingState extends AddTaskState {

}

class InitState extends AddTaskState {

}