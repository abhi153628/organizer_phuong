

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_text.dart';

import 'package:phuong_for_organizer/presentation/profile_page/widgets/selecting_type_profile.dart';
import 'package:phuong_for_organizer/presentation/profile_page/widgets/profile_bloc/profile_submission_bloc.dart';
import 'package:phuong_for_organizer/presentation/profile_page/widgets/profile_bloc/profile_submission_event.dart';
import 'package:phuong_for_organizer/presentation/profile_page/widgets/profile_bloc/profile_submission_state.dart';
import 'package:phuong_for_organizer/presentation/profile_page/widgets/profile_image_section.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/presentation/status_page/status_screen/status_screen.dart';

class ProfileFields extends StatefulWidget {
  final Size size;
  final organizerId;

  const ProfileFields({required this.organizerId,Key? key, required this.size}) : super(key: key);

  @override
  _ProfileFieldsState createState() => _ProfileFieldsState();
}

class _ProfileFieldsState extends State<ProfileFields> {
  // check if any checkbox is selected
  int? _selectedEventTypeIndex;
  // ignore: unused_element
  bool _isAnyCheckboxSelected() {
    return _selectedEventTypeIndex != null;
  }

  //!image
  String? _uploadedImageUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
@override
Widget build(BuildContext context) {
  return BlocConsumer<ProfileBloc, ProfileState>(
    listener: (context, state) {
      if (state is ProfileSuccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      } else if (state is ProfileError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error)));
      } else if (state is ImageUploadSuccess) {
        setState(() {
          _uploadedImageUrl = state.imageUrl;
        });
      }
    },
    builder: (context, state) {
      final bool isLoading = state is ProfileLoading;
      
      return AbsorbPointer(
        absorbing: isLoading,
        child: Opacity(
          opacity: isLoading ? 0.6 : 1.0,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ProfileImageSection(
                  size: widget.size,
                  pickImage: (XFile image) {
                    context.read<ProfileBloc>().add(UpdateProfileImage(image));
                  },
                ),
                const SizedBox(height: 30),
                _buildNameField(isLoading),
                const SizedBox(height: 30),
                _buildDescriptionField(isLoading),
                const SizedBox(height: 10),
                _buildEventTypeSection(isLoading),
                _buildPhoneNoField(isLoading),
                const SizedBox(height: 30),
                _buildLocationField(isLoading),
                const SizedBox(height: 30),
                Center(child: _submitButton()),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildNameField(bool isLoading) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Name', style: TextStyle(color: Colors.white)),
      const SizedBox(height: 8),
      TextFormField(
        controller: _nameController,
        enabled: !isLoading,
        decoration: InputDecoration(
          hintText: "Your Name",
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: grey.withOpacity(isLoading ? 0.1 : 0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(color: Colors.white),
      ),
    ],
  );
}

Widget _buildDescriptionField(bool isLoading) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Description', style: TextStyle(color: Colors.white)),
      const SizedBox(height: 8),
      TextFormField(
        controller: _descriptionController,
        enabled: !isLoading,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "Tell what your show is about",
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: grey.withOpacity(isLoading ? 0.1 : 0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please provide a description';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CstmText(
          text: '40',
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

Widget _buildEventTypeSection(bool isLoading) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Type of Event', style: TextStyle(color: Colors.white)),
      SizedBox(
        height: widget.size.height * 0.18,
        child: Opacity(
          opacity: isLoading ? 0.5 : 1.0,
          child: IgnorePointer(
            ignoring: isLoading,
            child: SelectingTypeWidget(
              onSelectionChanged: (index) {
                setState(() {
                  _selectedEventTypeIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildPhoneNoField(bool isLoading) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Phone Number', style: TextStyle(color: Colors.white)),
      const SizedBox(height: 8),
      TextFormField(
        controller: _phoneController,
        enabled: !isLoading,
        decoration: InputDecoration(
          hintText: "Your Phone Number",
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: grey.withOpacity(isLoading ? 0.1 : 0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }
          if (!RegExp(r'^\d+$').hasMatch(value)) {
            return 'Please enter a valid phone number';
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        style: const TextStyle(color: Colors.white),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    ],
  );
}

Widget _buildLocationField(bool isLoading) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Location', style: TextStyle(color: Colors.white)),
      const SizedBox(height: 8),
      TextFormField(
        controller: _locationController,
        enabled: !isLoading,
        maxLines: 2,
        decoration: InputDecoration(
          hintText: 'Add Location',
          hintStyle: GoogleFonts.aBeeZee(
            color: white,
            fontWeight: FontWeight.w300,
          ),
          filled: true,
          fillColor: grey.withOpacity(isLoading ? 0.1 : 0.2),
          prefixIcon: Opacity(
            opacity: isLoading ? 0.5 : 1.0,
            child: Lottie.asset(
              'asset/animation/Animation - 1728643625531.json',
              width: 70,
              height: 70,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: grey.withOpacity(0.9)),
          ),
        ),
        style: GoogleFonts.aBeeZee(
          color: white,
          fontWeight: FontWeight.w500,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please add a location';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    ],
  );
}

  // ignore: unused_element
  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _selectedEventTypeIndex != null;
  }

 Widget _submitButton() {
  bool isConfirmed = false;

  return BlocConsumer<ProfileBloc, ProfileState>(
    listener: (context, state) {
      if (state is ProfileSuccess) {
        Navigator.of(context).pushAndRemoveUntil(
          GentlePageTransition(
            page: ShowingStatus(
              organizerId: state.organizerId,
            ),
          ),
          (route) => false,
        );
      }
    },
    builder: (context, state) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: purple,
          minimumSize: const Size(140, 40),
        ),
        onPressed: state is ProfileLoading
            ? null
            : () async {
                if (_formKey.currentState?.validate() ?? false) {
                  if (_selectedEventTypeIndex == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an event type'),
                      ),
                    );
                    return;
                  }

                  // Show the confirmation bottom sheet
                  final bool? shouldProceed = await showModalBottomSheet<bool>(
                    context: context,
                    isDismissible: false,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext bottomSheetContext) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.only(
                              left: 24,
                              right: 24,
                              top: MediaQuery.of(context).padding.top + 20,
                              bottom: MediaQuery.of(context).viewInsets.bottom + 28,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.95),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.red,
                                      size: 48,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Important Notice',
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Please read carefully:',
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      '• Your entered data cannot be modified after submission\n'
                                      '• Do not turn off your phone during submission\n'
                                      '• Do not switch to other apps\n'
                                      '• Do not close the app\n'
                                      '• These actions may cause data errors',
                                      style: GoogleFonts.aBeeZee(
                                        color: Colors.red.shade300,
                                        fontSize: 15,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isConfirmed,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isConfirmed = value ?? false;
                                            });
                                          },
                                          fillColor: MaterialStateProperty.resolveWith(
                                            (states) => purple,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'I understand and agree to proceed with submission',
                                            style: GoogleFonts.aBeeZee(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.withOpacity(0.2),
                                          minimumSize: const Size(140, 45),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.aBeeZee(
                                            color: Colors.red.shade300,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: purple,
                                          minimumSize: const Size(140, 45),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: isConfirmed
                                            ? () => Navigator.pop(context, true)
                                            : null,
                                        child: Text(
                                          'Proceed',
                                          style: GoogleFonts.aBeeZee(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );

                  // If user confirmed, proceed with form submission
                  if (shouldProceed == true) {
                    context.read<ProfileBloc>().add(
                          SubmitProfileForm(
                            name: _nameController.text,
                            description: _descriptionController.text,
                            phoneNumber: _phoneController.text,
                            email: widget.organizerId,
                            location: _locationController.text,
                            eventType: _selectedEventTypeIndex!,
                            imageUrl: _uploadedImageUrl,
                          ),
                        );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields correctly'),
                    ),
                  );
                }
              },
        child: state is ProfileLoading
            ?  Lottie.asset('asset/animation/Loading_animation.json',height: 170, width: 170)
            : Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20,
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      );
    },
  );
}}