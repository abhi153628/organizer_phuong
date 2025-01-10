// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_snackbar.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_text.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/data/dataresources/event_hosting_firebase_service.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/adding_image_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/extra_fields.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/genre_type_selecting_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/glowing_button_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/select_event_type_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/terms_and_condition_widget.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_page.dart';


class TotalFields extends StatefulWidget {
  final Size size;

  const TotalFields({Key? key, required this.size}) : super(key: key);

  @override
  _TotalFieldsState createState() => _TotalFieldsState();
}

class _TotalFieldsState extends State<TotalFields> {
  final FirebaseEventService _eventService = FirebaseEventService();
  final OrganizerProfileAddingFirebaseService _firebaseService =
      OrganizerProfileAddingFirebaseService();
  // final String userId = FirebaseAuth.instance.currentUser!.uid;

  // check if any checkbox is selected
  int? _selectedEventTypeIndex;

  List<String> _eventRules = [];
  //!image
  XFile? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _organizerNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _instagramLinkController =
      TextEditingController();
  final TextEditingController _facebookLinkController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _seatAvailabilityCountController =
      TextEditingController();
  final TextEditingController _eventDurationTimeController =
      TextEditingController();
  final TextEditingController _specialInstructionController =
      TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedGenre;
  final TextEditingController _locationController = TextEditingController();

  bool _isLocationFieldActive = false;

// Add this method to handle location field focus
  void _handleLocationFieldFocus(bool isFocused) {
    setState(() {
      _isLocationFieldActive = isFocused;
    });
  }

//! GENRE SELECTION
  void handleGenreSelection(String? genre) {
    setState(() {
      selectedGenre = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            CstmText(
              text: 'Add Event Image',
              fontSize: 15,
              color: white,
            ),
            const SizedBox(
              height: 10,
            ),
            EventImage(
              size: widget.size,
              pickImage: (XFile image) {
                _selectedImage = image;
              },
            ),
            LocationField(
              controller: _locationController,
              onFocusChange: _handleLocationFieldFocus,
              onItemClick: (Prediction prediction) {
                _locationController.text = prediction.description ?? '';
                setState(() {
                  _isLocationFieldActive = false;
                });
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 28),
            EventNameField(
              controller: _eventNameController,
              isLocationFieldActive: _isLocationFieldActive,
            ),
            const SizedBox(height: 28),
          DateTimeFields(
  dateController: _dateController,
  timeController: _timeController,
  isLocationFieldActive: _isLocationFieldActive,
  onDateSelected: (DateTime date) {
    setState(() {
      selectedDate = date;
    });
  },
  onTimeSelected: (TimeOfDay time) {
    setState(() {
      selectedTime = time;
    });
  },
),
            const SizedBox(height: 28),
            DescriptionField(
              controller: _descriptionController,
              isLocationFieldActive: _isLocationFieldActive,
            ),
            const SizedBox(height: 28),
            EventDurationField(
              controller: _eventDurationTimeController,
              isLocationFieldActive: _isLocationFieldActive,
            ),
            const SizedBox(height: 28),
            TicketPriceAndSeatsField(
              priceController: _ticketPriceController,
              seatsController: _seatAvailabilityCountController,
              isLocationFieldActive: _isLocationFieldActive,
            ),
            const SizedBox(height: 28),
            _buildPerformanceType(),
            const SizedBox(height: 28),
            genreTypeSelecting(),
            const SizedBox(height: 28),
            ContactFields(
              emailController: _emailController,
              facebookController: _facebookLinkController,
              instagramController: _instagramLinkController,
              isLocationFieldActive: _isLocationFieldActive,
            ),
            const SizedBox(height: 28),
            _specialInstructionField(),
            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.only(right: 180),
              child: Text(
                'Event Rules & Requirements',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            EventRulesInput(
              onRulesChanged: (List<String> updatedRules) {
                setState(() {
                  _eventRules = updatedRules;
                });
              },
            ),
            const SizedBox(height: 28),
            Center(child: _submitButton()),
            const SizedBox(height: 28),
          ],
        ));
  }

  //! TYPE OF EVENT FIELD(SOLO/ENSEMBLE)
  Widget _buildPerformanceType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Type of Performance',
            style: TextStyle(color: Colors.white)),
        SizedBox(
          height: widget.size.height * 0.18,
          child: SelectinngEventType(
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

//! GENRE TYPE OF EVENT
//////////////////////////////////////////////////////
  Widget genreTypeSelecting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose a Music Genre',
            style: TextStyle(color: Colors.white)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.12,
          child: GenreSelectionWidget(onGenreSelected: handleGenreSelection),
        ),
        if (selectedGenre != null && selectedGenre!.isNotEmpty)
          Text(
            "Selected Genre: $selectedGenre",
            style: const TextStyle(color: Colors.white),
          ),
      ],
    );
  }

//! ADDITIONAL EVENT INSTRUCTION
  Widget _specialInstructionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Special Instructions',
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller:
              _specialInstructionController, // Assuming this controller is used for instructions
          maxLines: 3, // Allowing more lines for longer instructions
          decoration: InputDecoration(
            hintText: 'Enter any special instructions for the event',
            hintStyle: GoogleFonts.aBeeZee(
              color: white,
              fontWeight: FontWeight.w300,
            ),
            filled: true,
            fillColor: grey.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: grey.withOpacity(0.9)),
            ),
          ),
          style: GoogleFonts.aBeeZee(color: white, fontWeight: FontWeight.w500),
          validator: (value) {
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: true,
          readOnly: false,
        ),
      ],
    );
  }

  Widget _submitButton() {
    return GlowingButton(
      text: 'Set Live',
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            OrganizerProfileAddingModal? currentUserProfile =
                await _firebaseService.getCurrentUserProfile();
            // ignore: unnecessary_null_comparison
            if (currentUserProfile == null || currentUserProfile.name == null) {
              // ignore: use_build_context_synchronously
              CustomSnackBar.show(
                  context, 'Unable to retrieve organizer profile', red);
              return;
            }
            if (_locationController.text.isEmpty) {
              CustomSnackBar.show(context, 'Please select your location', red);
              return;
            }
            if (_selectedImage == null) {
              CustomSnackBar.show(context, 'Please select Event Image', red);
              return;
            }

            // Show loading indicator
            showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return  Center(
                  child:Lottie.asset('asset/animation/Loading_animation.json',height: 170, width: 170)
                );
              },
            );

            // Validate required fields
            if (_selectedEventTypeIndex == null) {
              Navigator.pop(context); // Dismiss loading
              CustomSnackBar.show(
                  context, 'Please select a performance type', red);
              return;
            }

            if (selectedGenre == null || selectedGenre!.isEmpty) {
              Navigator.pop(context); // Dismiss loading
              CustomSnackBar.show(context, 'Please select a genre', red);
              return;
            }

            if (selectedDate == null || selectedTime == null) {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              CustomSnackBar.show(context, 'Please select date and time', red);
              return;
            }

            // Create event modal
            final event = EventHostingModal(
              eventName: _eventNameController.text,
              organizerName: currentUserProfile.name,
              organizerId: currentUserProfile.id,
              description: _descriptionController.text,
              ticketPrice: double.tryParse(_ticketPriceController.text) ?? 0.0,
              instagramLink: _instagramLinkController.text,
              facebookLink: _facebookLinkController.text,
              email: _emailController.text,
              seatAvailabilityCount:
                  double.tryParse(_seatAvailabilityCountController.text) ?? 0.0,
              eventDurationTime:
                  double.tryParse(_eventDurationTimeController.text) ?? 0.0,
              specialInstruction: _specialInstructionController.text,
              location: _locationController.text,
              date: selectedDate,
              time: selectedTime,
              performanceType: _selectedEventTypeIndex,
              genreType: selectedGenre,
              eventRules: _eventRules,
            );

            // Convert XFile to File if image is selected
            File? imageFile;
            if (_selectedImage != null) {
              imageFile = File(_selectedImage!.path);
            }

            // Save event data and image
            await _eventService.saveEvent(event, image: imageFile);

            // Show success message

            Navigator.pushAndRemoveUntil(
              context,
              GentlePageTransition(page: EventListPage()),
              (Route<dynamic> route) =>
                  false, // This removes all previous routes
            );

            CustomSnackBar.show(
                context, 'Success! Your event is now live 🚀', purple);

            // Optionally navigate back or clear form
            // Navigator.pop(context); // Uncomment to go back
            _clearForm();
          } catch (e) {
            // Dismiss loading indicator
            Navigator.pop(context);

            // Show error message
            CustomSnackBar.show(
                context, 'Error saving event: ${e.toString()}', red);
          }
        }
      },
    );
  }

  void _clearForm() {
    _eventNameController.clear();
    _organizerNameController.clear();
    _descriptionController.clear();
    _ticketPriceController.clear();
    _instagramLinkController.clear();
    _facebookLinkController.clear();
    _emailController.clear();
    _seatAvailabilityCountController.clear();
    _eventDurationTimeController.clear();
    _specialInstructionController.clear();
    _locationController.clear();
    _dateController.clear();
    _timeController.clear();
    setState(() {
      selectedDate = null;
      selectedTime = null;
      selectedGenre = null;
      _selectedEventTypeIndex = null;
      _selectedImage = null;
    });
  }

  // Add these functions in your _TotalFieldsState class:
  // ignore: unused_element
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: purple, // Your app's primary color
              onPrimary: Colors.white,
              surface: grey.withOpacity(0.2),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // ignore: unused_element
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: purple,
              onPrimary: Colors.white,
              surface: grey.withOpacity(0.2),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }
}
