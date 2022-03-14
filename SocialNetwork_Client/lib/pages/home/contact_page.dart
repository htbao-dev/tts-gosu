import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/contact_bloc/contact_bloc.dart';
import 'package:social_network_client/pages/widgets/user_widget.dart';
import 'package:social_network_client/repository/user_repository.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ContactBloc(userRepo: RepositoryProvider.of<UserRepository>(context)),
      child: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ContactInitial) {
            BlocProvider.of<ContactBloc>(context).add(LoadContactsEvent());
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ContactLoadedState) {
            return ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) =>
                    ListViewUserTile(state.contacts[index], state.userId));
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}
