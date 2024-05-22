import 'package:chat_wave/extension/widget_extension.dart';
import 'package:chat_wave/feature/main/bloc/homepage_load_bloc.dart';
import 'package:chat_wave/router/navigation_helper.dart';
import 'package:chat_wave/router/route_collector.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/property.dart';

class SelectionSheet extends StatefulWidget {
  const SelectionSheet({
    super.key,
  });

  @override
  State<SelectionSheet> createState() => _SelectionSheetState();
}

class _SelectionSheetState extends State<SelectionSheet> {

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 50,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.onSurface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.only(bottom: 8),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Text(
                  'Test With the Test Accout',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextFormField(
                autofocus: false,
                enabled: false,
                initialValue: 'TUHDY6854FYRFD345CVH',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  color: context.theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  border: customBorder,
                  enabledBorder: customBorder,
                  disabledBorder: customBorder ,
                  focusedBorder:customBorder,
                  focusedErrorBorder: customBorder,
                  errorBorder: customBorder,
                  filled: true,
                  fillColor: context.theme.colorScheme.surface,
                  //隐藏下划线
                  //border: InputBorder.none,
                  hintStyle: const TextStyle(fontSize: 15, color: Color(0xffAEAEAE)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _enterHomePage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.colorScheme.onSurface,
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  'Enter',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    color: context.theme.colorScheme.surface,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => launchUrl(
                  Uri.parse(
                    'https://example.com',
                  ),
                ),
                child: Text(
                  'learn about the project',
                  style: context.theme.textTheme.labelMedium!.copyWith(
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _enterHomePage(){
    GetIt.I<HomePageLoadBloc>().add(const StartLoadHomePage());
    NavigationHelper.popAllAndPushNamed(RouteCollector.home);
  }
}