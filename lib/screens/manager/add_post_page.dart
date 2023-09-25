import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/gsheets/models/posting_model.dart';
import 'package:scrumm/gsheets/worksheets/posting_worksheet.dart';
import 'package:scrumm/screens/scrum_activities/scrum_activities_provider.dart';
import 'package:scrumm/widgets/responsive_layout.dart';

import '../home/home_provider.dart';
import 'manage_post_provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostState();
}

class _AddPostState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  PostingModel posting = PostingModel();
  late HomeProvider homeProvider;
  late ManagePostProvider postProvider;
  late ScrumActivitiesProvider scrumActivitiesProvider;
  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    scrumActivitiesProvider =
        Provider.of<ScrumActivitiesProvider>(context, listen: false);
    postProvider = Provider.of<ManagePostProvider>(context, listen: false);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        centerTitle: true,
        title: const Text('Create Scrum'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ActionChip(
              label: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                PostingWSheet.insertPosting(posting: posting).then((value) {
                  if (value) {
                    homeProvider.fetchTodayPosting();
                    scrumActivitiesProvider.fetchAllUsers();
                    Navigator.pop(context);
                  } else {
                    debugPrint('Error');
                  }
                });
              },
            ),
          )
        ],
      ),
      body: ResponsiveLayout(
        mobileView: _form(),
        tabletView: Row(
          children: [
            SizedBox(width: MediaQuery.sizeOf(context).width * .2),
            Expanded(flex: 2, child: _form()),
            SizedBox(width: MediaQuery.sizeOf(context).width * .2),
          ],
        ),
        webView: Row(
          children: [
            SizedBox(width: MediaQuery.sizeOf(context).width * .3),
            Expanded(flex: 2, child: _form()),
            SizedBox(width: MediaQuery.sizeOf(context).width * .3),
          ],
        ),
      ),
    );
  }

  _form() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          textField(
              label: 'What is your name ?',
              hintText: 'Select your name',
              readOnly: true,
              controller: nameCtrl,
              validator: (text) =>
                  text!.isEmpty ? 'Tell us your name :)' : null,
              onTap: () {
                postProvider.getAlluser();
                if (MediaQuery.sizeOf(context).width < 850) {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => _selectuserName());
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                              child: SizedBox(
                            width: MediaQuery.sizeOf(context).width < 850
                                ? null
                                : MediaQuery.sizeOf(context).width * .4,
                            child: _selectuserName(),
                          )));
                }
              },
              suffixIcon: const Icon(Icons.arrow_drop_down)),
          const Divider(
            indent: 10,
            endIndent: 10,
            height: 30,
          ),
          textField(
              label: 'What is your plan today ?',
              hintText: 'Tell us your plan',
              validator: (text) =>
                  text!.isEmpty ? 'You forgot to fill in this field :)' : null,
              onChanged: (value) =>
                  setState(() => posting = posting.copyWith(todayPlans: value)),
              maxLines: 5),
          textField(
              label: 'Anything blocking your progress ?',
              hintText: 'Tell us your problem',
              validator: (text) =>
                  text!.isEmpty ? 'You forgot to fill in this field :)' : null,
              onChanged: (value) =>
                  setState(() => posting = posting.copyWith(blocker: value)),
              maxLines: 5),
        ],
      ),
    );
  }

  _selectuserName() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.6,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close)),
                  ),
                ),
                const Text(
                  'Find your name',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 55,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: 'Search',
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.33,
                  child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'NO SCRUM - ${context.watch<ManagePostProvider>().userEnable?.length ?? 0}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        ),
                        ...List.generate(
                            context
                                    .watch<ManagePostProvider>()
                                    .userEnable
                                    ?.length ??
                                0,
                            (index) => Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          nameCtrl.text = context
                                                  .read<ManagePostProvider>()
                                                  .userEnable?[index]
                                                  .name ??
                                              '-';
                                          posting = posting.copyWith(
                                              userId: context
                                                      .read<
                                                          ManagePostProvider>()
                                                      .userEnable?[index]
                                                      .id ??
                                                  0,
                                              username: context
                                                      .read<
                                                          ManagePostProvider>()
                                                      .userEnable?[index]
                                                      .name ??
                                                  '-');
                                        });
                                        Navigator.pop(context);
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      leading: const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                      title: Text(context
                                              .watch<ManagePostProvider>()
                                              .userEnable?[index]
                                              .name ??
                                          '-'),
                                      subtitle: Text(
                                          '${context.watch<ManagePostProvider>().userEnable?[index].id ?? ""}'),
                                    ),
                                    const Divider(indent: 30, height: 0)
                                  ],
                                )),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'ALREADY CREATE - ${context.watch<ManagePostProvider>().userDisable?.length ?? 0}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        ),
                        ...List.generate(
                            context
                                    .watch<ManagePostProvider>()
                                    .userDisable
                                    ?.length ??
                                0,
                            (index) => Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        debugPrint("User already create");
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      leading: const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                      title: Text(context
                                              .watch<ManagePostProvider>()
                                              .userDisable?[index]
                                              .name ??
                                          '-'),
                                      subtitle: Text(
                                          '${context.watch<ManagePostProvider>().userDisable?[index].id ?? ""}'),
                                    ),
                                    const Divider(indent: 30, height: 0)
                                  ],
                                )),
                      ]),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  textField(
      {required String label,
      String? hintText,
      int? maxLines = 1,
      TextEditingController? controller,
      bool readOnly = false,
      Widget? suffixIcon,
      String? Function(String?)? validator,
      void Function(String value)? onChanged,
      void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: maxLines,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            readOnly: readOnly,
            onChanged: onChanged,
            onTap: onTap,
            validator: validator,
            decoration:
                InputDecoration(suffixIcon: suffixIcon, hintText: hintText),
          )
        ],
      ),
    );
  }
}
