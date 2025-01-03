import 'dart:developer';

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
import 'package:phuong_for_organizer/presentation/profile_sucess_page/profile_sucess_screen.dart';

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
    return BlocListener<ProfileBloc, ProfileState>(
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
              _buildNameField(),
              const SizedBox(height: 30),
              _buildDescriptionField(),
              const SizedBox(height: 10),
              _buildEventTypeSection(),
              _buildPhoneNoField(),
              const SizedBox(height: 30),
           
              const SizedBox(height: 30),
              _buildLocationField(),
              const SizedBox(height: 30),
              Center(child: _submitButton()),
            ],
          )),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Your Name",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
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

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tell what your show is about",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
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
          child: CstmText(text: '40', fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEventTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Type of Event', style: TextStyle(color: Colors.white)),
        SizedBox(
          height: widget.size.height * 0.18,
          child: SelectingTypeWidget(
            onSelectionChanged: (index) {
              setState(() {
                _selectedEventTypeIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Phone Number', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: "Your Phone Number",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
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


  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _locationController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Add Location',
            hintStyle: GoogleFonts.aBeeZee(
              color: white,
              fontWeight: FontWeight.w300,
            ),
            filled: true,
            fillColor: grey.withOpacity(0.1),
            prefixIcon: Lottie.asset(
              'asset/animation/Animation - 1728643625531.json',
              width: 70,
              height: 70,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: grey.withOpacity(0.9)),
            ),
          ),
          style: GoogleFonts.aBeeZee(color: white, fontWeight: FontWeight.w500),
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

  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _selectedEventTypeIndex != null;
  }

  Widget _submitButton() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            GentlePageTransition(
                page: ShowingStatus(
              organizerId: state.organizerId,
            )),
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
              : () {
                  log(_formKey.currentState!.validate().toString());
                  if (_formKey.currentState?.validate() ?? false) {
                    if (_selectedEventTypeIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an event type'),
                        ),
                      );
                      return;
                    }

                    // All validations passed, submit the form
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please fill all required fields correctly'),
                      ),
                    );
                  }
                },
          child: state is ProfileLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 20, color: white, fontWeight: FontWeight.bold),
                ),
        );
      },
    );
  }
}
