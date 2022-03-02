import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_client/blocs/contact_bloc/contact_bloc.dart';
import 'package:social_network_client/repository/user_repository.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ContactBloc(userRepo: RepositoryProvider.of<UserRepository>(context)),
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactInitial) {
            BlocProvider.of<ContactBloc>(context).add(LoadContactsEvent());
          }
          return Column(
            children: [
              TextButton(
                  onPressed: () {
                    BlocProvider.of<ContactBloc>(context)
                        .add(LoadContactsEvent());
                  },
                  child: const Text("Add Contact")),
              const Center(
                child: Text('Contact Pageaa'),
              ),
            ],
          );
        },
      ),
    );
  }
}
