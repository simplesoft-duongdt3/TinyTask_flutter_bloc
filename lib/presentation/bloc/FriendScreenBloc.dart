import 'package:bloc/bloc.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

class FriendScreenBloc extends Bloc<FriendEvent, FriendState> {
  FriendRepository _friendRepository = diResolver.resolve();

  @override
  FriendState get initialState => InitState();

  @override
  Stream<FriendState> mapEventToState(FriendEvent event) async* {
    if (event is SendFriendRequestEvent) {
      yield LoadingState();
      await _sendFriendRequest(event._friendRequestPresentationModel);
      yield SendFriendRequestSuccessState();
    } else if (event is AcceptFriendRequestEvent) {
      yield LoadingState();
      await _acceptFriendRequest(event._acceptFriendRequestDomainModel);
      yield AcceptFriendRequestSuccessState();
    } else if (event is LoadSentFriendsEvent) {
      yield LoadingState();
      var friendRequests = await _loadSentFriendRequestList();
      yield LoadSentFriendsSuccessState(friendRequests);
    } else if (event is LoadFriendsEvent) {
      yield LoadingState();
      var friends = await _loadFriendList();
      yield LoadFriendsSuccessState(friends);
    } else if (event is LoadReceivedFriendsEvent) {
      yield LoadingState();
      var receivedFriendRequests = await _loadReceivedFriendRequestList();
      yield LoadReceivedFriendsSuccessState(receivedFriendRequests);
    }
  }

  Future<void> _sendFriendRequest(
      FriendRequestPresentationModel friendRequestPresentationModel) async {
    await _friendRepository.sendFriendRequest(FriendRequestDomainModel(
      friendRequestPresentationModel.uid,
      friendRequestPresentationModel.email,
    ));
  }

  Future<void> _acceptFriendRequest(
      AcceptFriendRequestDomainModel acceptFriendRequestDomainModel) async {
    await _friendRepository.acceptFriendRequest(acceptFriendRequestDomainModel);
  }

  Future<List<SentFriendRequestPresentationModel>>
      _loadSentFriendRequestList() async {
    var sentFriendRequests = await _friendRepository.getSendFriendRequests();
    return _mapSentFriendRequest(sentFriendRequests);
  }

  Future<List<FriendPresentationModel>> _loadFriendList() async {
    var sentFriendRequests = await _friendRepository.getFriends();
    return _mapFriend(sentFriendRequests);
  }

  List<SentFriendRequestPresentationModel> _mapSentFriendRequest(
      List<SentFriendRequestDomainModel> sentFriendRequests) {
    return sentFriendRequests
        .map((sentRequest) => SentFriendRequestPresentationModel(
            sentRequest.requestId,
            sentRequest.email,
            sentRequest.requestTime,
            sentRequest.status))
        .toList(growable: false);
  }

  List<ReceivedFriendRequestPresentationModel> _mapReceivedFriendRequest(
      List<ReceivedFriendRequestDomainModel> receivedFriendRequests) {
    return receivedFriendRequests
        .map((sentRequest) => ReceivedFriendRequestPresentationModel(
            sentRequest.requestId,
            sentRequest.email,
            sentRequest.requestTime,
            sentRequest.status))
        .toList(growable: false);
  }

  Future<List<ReceivedFriendRequestPresentationModel>>
      _loadReceivedFriendRequestList() async {
    var sentFriendRequests =
        await _friendRepository.getReceivedFriendRequests();
    return _mapReceivedFriendRequest(sentFriendRequests);
  }

  List<FriendPresentationModel> _mapFriend(
      List<FriendDomainModel> sentFriendRequests) {
    return sentFriendRequests
        .map((friend) => FriendPresentationModel(
              friend.uid,
              friend.email,
            ))
        .toList(growable: false);
  }
}


abstract class FriendEvent {

}

class SendFriendRequestEvent extends FriendEvent {
  FriendRequestPresentationModel _friendRequestPresentationModel;
  SendFriendRequestEvent(this._friendRequestPresentationModel);

  FriendRequestPresentationModel get friendRequestPresentationModel =>
      _friendRequestPresentationModel;
}

class AcceptFriendRequestEvent extends FriendEvent {
  AcceptFriendRequestDomainModel _acceptFriendRequestDomainModel;
  AcceptFriendRequestEvent(this._acceptFriendRequestDomainModel);

  AcceptFriendRequestDomainModel get acceptFriendRequestDomainModel =>
      _acceptFriendRequestDomainModel;
}

class LoadSentFriendsEvent extends FriendEvent {

}

class LoadFriendsEvent extends FriendEvent {

}

class LoadReceivedFriendsEvent extends FriendEvent {

}

abstract class FriendState {

}

class InitState extends FriendState {

}

class LoadingState extends FriendState {

}

class SomethingWrongState extends FriendState {

}

class SendFriendRequestSuccessState extends FriendState {

}

class AcceptFriendRequestSuccessState extends FriendState {

}

class LoadSentFriendsSuccessState extends FriendState {
  List<SentFriendRequestPresentationModel> _sentFriendRequests;

  LoadSentFriendsSuccessState(this._sentFriendRequests);

  List<SentFriendRequestPresentationModel> get sentFriendRequests =>
      _sentFriendRequests;
}

class LoadFriendsSuccessState extends FriendState {
  List<FriendPresentationModel> _friends;

  LoadFriendsSuccessState(this._friends);

  List<FriendPresentationModel> get friends =>
      _friends;
}

class LoadReceivedFriendsSuccessState extends FriendState {
  List<ReceivedFriendRequestPresentationModel> _receiveFriendRequests;

  LoadReceivedFriendsSuccessState(this._receiveFriendRequests);

  List<ReceivedFriendRequestPresentationModel> get receiveFriendRequests =>
      _receiveFriendRequests;
}

