import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../widgets/buttons/custom_radio_button.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  List<int> selectedRadioIndexes = List.generate(11, (index) => -1);
  List<bool> expanded = List.generate(11, (index) => false);
  final TextEditingController contentController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  final Map<String, List<String>> options = {
    "It's hate speech": ["Race or ethnicity", "Gender identity", "Sexual orientation", "Cultural identify", "Disability", "Other (please provide more details below)"],
    "It's terrorist or extremist content": ["Terrorist content", "Extremist content (e.g. Neo-nazi content)", "Glorification of terrorist group/terrorist leader", "Legal organization", "Other (please provide more details below)"],
    "It's graphics or violent": ["Inciting violence", "Graphic violence", "Animal harm", "Self-harm", "Promotion of suicide", "Content promoting eating disorders", "Violent threat", "Other (please provide more details below)"],
    "It's abuse/ harassment": ["Abuse. Harassment directed at me", "Stalking", "Abuse/Harassment directed at someone else"],
    "It contains nudity or pornographic content": ["Pornographic content (audit)", "Sexual exploitation or solicitation (audit)", "Non-consensual intimate image or recording of me"],
    "Protection on minors": ["It's my child's account/Minor", "Child sexual abuse material", "Grooming/sexual enticement of minors"],
    "It's privacy violation": ["it is violating my privacy", "It's violating someone else's privacy"],
    "It's misrepresentation or misleading": ["It's impersonating me", "It's impersonating someone else", "It's not what it says it is/misleading"],
    "It's selling restricted items": ["It's selling dangerous substances (e.g. narcotics)", "It's selling weapons"],
    "Something else": ["This member is deceased", "It's defaming me", "It's infringing my trademark", "It's a scam/fraud", "It's misinformation"],
    "I just don't like it": [],
  };

  void _onRadioSelected(int mainIndex) {
    setState(() {
      selectedRadioIndexes = List.generate(selectedRadioIndexes.length, (index) => -1);
      selectedRadioIndexes[mainIndex] = mainIndex;
      expanded = List.generate(expanded.length, (index) => index == mainIndex ? expanded[index] : false);
    });
  }

  void _toggleExpanded(int index) {
    setState(() {
      expanded[index] = !expanded[index];
    });
  }

  void _onSubOptionSelected(int mainIndex, int subIndex) {
    setState(() {
      selectedRadioIndexes[mainIndex] = subIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(centerTitle: false),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(AppImages.logo, width: 150),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 6, bottom: 6),
                  child: InkWell(
                    onTap: () {},
                    splashColor: AppColors.blue.withAlpha((0.3 * 255).toInt()),
                    highlightColor: AppColors.blue.withAlpha((0.3 * 255).toInt()),
                    child: Text('Report Copyright Infringement', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Report Content to Maestro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.3)),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 6),
                  child: Text('Reason for Reporting', style: TextStyle(fontSize: AppSizes.fontSizeMd)),
                ),
                const SizedBox(height: 15),
                for (var i = 0; i < options.keys.length; i++) ...[
                  InkWell(
                    onTap: () {
                      _onRadioSelected(i);
                      _toggleExpanded(i);
                    },
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    child: Row(
                      children: [
                        CustomRadioButton(
                          selected: selectedRadioIndexes[i] == i || options.values.elementAt(i).any(
                              (subOption) => selectedRadioIndexes[i] == options.values.elementAt(i).indexOf(subOption)),
                          label: options.keys.elementAt(i),
                          onPressed: () {
                            _onRadioSelected(i);
                            _toggleExpanded(i);
                          },
                        ),
                      ],
                    ),
                  ),
                  if (expanded[i])
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          for (var subOption in options.values.elementAt(i)) ...[
                            InkWell(
                              onTap: () {
                                int subOptionIndex = options.values.elementAt(i).indexOf(subOption);
                                _onSubOptionSelected(i, subOptionIndex);
                              },
                              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                              child: Row(
                                children: [
                                  CustomRadioButton(
                                    selected: selectedRadioIndexes[i] == options.values.elementAt(i).indexOf(subOption),
                                    label: subOption,
                                    onPressed: () {
                                      int subOptionIndex = options.values.elementAt(i).indexOf(subOption);
                                      _onSubOptionSelected(i, subOptionIndex);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 16),
                  child: Text('Please provide more detail as to why you\'re reposting this content', style: TextStyle(fontSize: AppSizes.fontSizeMd)),
                ),
                _buildTextField(contentController, 'Content report details'),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Your name', style: TextStyle(fontSize: AppSizes.fontSizeMd)),
                ),
                _buildTextField(nameController, 'Name'),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Your email address', style: TextStyle(fontSize: AppSizes.fontSizeMd)),
                ),
                _buildTextField(emailController, 'Email address'),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Please provide a link (URL) to the piece of content on Maestro that you want to report. Please only input one link per report.', style: TextStyle(fontSize: AppSizes.fontSizeMd)),
                ),
                _buildTextField(emailController, 'URL', isEnabled: false, isFloatingLabelAlways: true),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Select where the violation occurs (select as many as necessary)', style: TextStyle(fontSize: AppSizes.fontSizeMd)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool isEnabled = true, bool isFloatingLabelAlways = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextSelectionTheme(
          data: TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
          selectionHandleColor: AppColors.primary,
        ),
        child: TextField(
          controller: controller,
          cursorColor: AppColors.primary,
          textCapitalization: TextCapitalization.sentences,
          enabled: isEnabled,
          decoration: InputDecoration(
            floatingLabelStyle: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal, letterSpacing: 0.3),
            floatingLabelBehavior: isFloatingLabelAlways ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
            labelStyle: const TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w200),
            labelText: labelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.transparent)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.transparent)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.white)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.transparent)),
            fillColor: context.isDarkMode ? AppColors.darkGrey : AppColors.grey,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
