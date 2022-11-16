import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:movies_app_tmbd/domain/blocs/auth_bloc.dart';

enum LoaderViewCubitState{authorized,noAuthorized,unknown}

class LoaderViewCubit extends Cubit<LoaderViewCubitState>{
  final AuthBloc authBloc;
 late final StreamSubscription<AuthState> authBlocSubscription;

  LoaderViewCubit(LoaderViewCubitState initializeState,  this.authBloc) :super(initializeState){
    authBloc.add(AuthCheckEvent());
    onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(onState);
  }

  void onState(AuthState state){
    if(state is AuthAuthorizedState){
      emit(LoaderViewCubitState.authorized);
    }else if(state is AuthNoAuthorizedState){
      emit(LoaderViewCubitState.noAuthorized);
    }
  }

  @override
  Future<void> close() {
   authBlocSubscription.cancel();
    return super.close();
  }
}

