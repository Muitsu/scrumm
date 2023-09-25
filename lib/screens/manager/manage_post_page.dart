import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/gsheets/models/posting_model.dart';
import 'package:scrumm/gsheets/worksheets/posting_worksheet.dart';
import 'package:scrumm/screens/home/home_provider.dart';
import 'package:scrumm/screens/manager/manage_post_provider.dart';
import 'package:scrumm/widgets/responsive_layout.dart';

import '../user_info/user_info_provider.dart';

class ManagePostPage extends StatefulWidget {
  const ManagePostPage({super.key});

  @override
  State<ManagePostPage> createState() => _AddPostState();
}

class _AddPostState extends State<ManagePostPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final todayPlanCtrl = TextEditingController();
  final blockerCtrl = TextEditingController();
  PostingModel posting = PostingModel();
  late HomeProvider homeProvider;
  late ManagePostProvider postProvider;
  late UserInfoProvider userInfoProvider;
  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    postProvider = Provider.of<ManagePostProvider>(context, listen: false);
    userInfoProvider = Provider.of(context, listen: false);
    posting = postProvider.posting!;
    nameCtrl.text = posting.username!;
    todayPlanCtrl.text = posting.todayPlans!;
    blockerCtrl.text = posting.blocker!;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    todayPlanCtrl.dispose();
    blockerCtrl.dispose();
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
        title: const Text('Edit Scrum'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ActionChip(
              label: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                PostingWSheet.updatePosting(posting: posting).then((value) {
                  if (value) {
                    userInfoProvider.fetchUserPostingById(
                        userId: posting.userId!);
                    homeProvider.fetchTodayPosting();
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
              enable: false,
              controller: nameCtrl,
              validator: (text) =>
                  text!.isEmpty ? 'Tell us your name :)' : null,
              suffixIcon: const Icon(Icons.arrow_drop_down)),
          const Divider(
            indent: 10,
            endIndent: 10,
            height: 30,
          ),
          textField(
              label: 'What is your plan today ?',
              hintText: 'Tell us your plan',
              controller: todayPlanCtrl,
              validator: (text) =>
                  text!.isEmpty ? 'You forgot to fill in this field :)' : null,
              onChanged: (value) =>
                  setState(() => posting = posting.copyWith(todayPlans: value)),
              maxLines: 5),
          textField(
              label: 'Anything blocking your progress ?',
              hintText: 'Tell us your problem',
              controller: blockerCtrl,
              validator: (text) =>
                  text!.isEmpty ? 'You forgot to fill in this field :)' : null,
              onChanged: (value) =>
                  setState(() => posting = posting.copyWith(blocker: value)),
              maxLines: 5),
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Delete this scrum?'),
                        content: const Text(
                            'It`s weird to delete your scrum right?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black54),
                              )),
                          TextButton(
                              onPressed: () {
                                PostingWSheet.deletePost(posting: posting)
                                    .then((value) {
                                  if (value) {
                                    homeProvider.fetchTodayPosting();
                                    userInfoProvider.fetchUserPostingById(
                                        userId: posting.userId!);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                    debugPrint('Error');
                                  }
                                });
                              },
                              child: const Text('I don`t care')),
                        ],
                      ));
            },
            child: const Text(
              'Delete Scrum',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  textField(
      {required String label,
      String? hintText,
      int? maxLines = 1,
      bool? enable,
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
            enabled: enable,
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
