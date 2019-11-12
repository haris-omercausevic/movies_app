import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/users/users_bloc.dart';
import 'package:movies_app/blocs/users/users_event.dart';
import 'package:movies_app/blocs/users/users_state.dart';
import 'package:movies_app/user_interface/common/all.dart';

class UsersDetailsPage extends StatefulWidget {
  static const routeName = "/Users/Details";
  final UsersBloc usersBloc;
  //final String accountId;
  UsersDetailsPage({this.usersBloc});
  @override
  _UsersDetailsPageState createState() => _UsersDetailsPageState();
}

class _UsersDetailsPageState extends State<UsersDetailsPage> {  

  @override
  Widget build(BuildContext context) {
    return Container(      
      child: BlocBuilder<UsersBloc, UsersState>(
          bloc: widget.usersBloc,
          builder: (BuildContext context, UsersState state) {
            if (state is Loading) {
              return Loader();
            } else if (state is LoadedUser) {
              return 
              Container(                             
                padding: const EdgeInsets.all(16.0),                                                
                child: Center(                                    
                  child: Column(                  
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("My Lists", style: TextStyle(fontSize: 16),),
                      Text("List name: ${state.user.name}",style: TextStyle(fontSize: 16)),
                      Text(
                          "Average rating: ${state.user.average_rating.toString()}",style: TextStyle(fontSize: 16)),
                      Text("Number of items: ${state.user.number_of_items}",style: TextStyle(fontSize: 16)),
                      Text("Description: ${state.user.description}",style: TextStyle(fontSize: 16)),
                      Text("Adult: ${state.user.adult == 1?"Yes":"No"}",style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            }
            return ErrorPage();
          }),
    );
  }
}
