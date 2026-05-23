import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_process_button_widget/on_process_button_widget.dart';

import '../../../../core/base/widgets/text.dart';
import '../../../../core/values/app_values.dart';
import '../bloc/book_bloc.dart';
import '../bloc/book_event.dart';
import '../bloc/book_state.dart';

class ErrorView extends StatelessWidget {
  final BookError state;
  final int pageSize;

   const ErrorView({required this.state, required this.pageSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomTextBody.L(text:  'Error loading books',
            ),
          const SizedBox(height: AppValues.halfPadding),
          CustomTextBody(text: state.message,
              
              textAlign: TextAlign.center),
          const SizedBox(height: AppValues.padding),
          OnProcessButtonWidget(
            onTap: () {
              context
                .read<BookBloc>()
                .add(BookGetBooksEvent(pageSize: pageSize));
            } ,
            child: const CustomTextBody(text: 'Retry'),
          ),
        ],
      ),
    );
  }
}