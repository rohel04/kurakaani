part of 'network_bloc.dart';

@immutable
abstract class NetworkEvent {}

class NetworkCheckEvent extends NetworkEvent{

}
class NetworkGainedEvent extends NetworkEvent{

}
class NetworkLossEvent extends NetworkEvent{

}
