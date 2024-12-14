import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_text.dart';
import 'package:phuong_for_organizer/data/dataresources/event_hosting_firebase_service.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:phuong_for_organizer/presentation/edit_page_event_hosting/event_type_selection_edit.dart';
import 'package:phuong_for_organizer/presentation/edit_page_event_hosting/genre_selection_widget.dart';
import 'package:phuong_for_organizer/presentation/edit_page_event_hosting/image_edit_page.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/adding_image_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/genre_type_selecting_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/glowing_button_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/select_event_type_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/terms_and_condition_widget.dart';

class EditEventPage extends StatefulWidget {
  final EventHostingModal event;

  const EditEventPage({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final FirebaseEventService _eventService = FirebaseEventService();
  final OrganizerProfileAddingFirebaseService _firebaseService = OrganizerProfileAddingFirebaseService();
  int? _selectedEventTypeIndex;

  late TextEditingController _eventNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _ticketPriceController;
  late TextEditingController _instagramLinkController;
  late TextEditingController _facebookLinkController;
  late TextEditingController _emailController;
  late TextEditingController _seatAvailabilityCountController;
  late TextEditingController _eventDurationTimeController;
  late TextEditingController _specialInstructionController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  String? selectedGenre;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  XFile? _selectedImage;
  List<String> _eventRules = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // Set initial genre
    selectedGenre = widget.event.genreType;

    // Set initial performance type
    _selectedEventTypeIndex = widget.event.performanceType;
   selectedDate = widget.event.date;
  selectedTime = widget.event.time;
  
  // Use WidgetsBinding to update time text after build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      // Update date controller
      if (selectedDate != null) {
        _dateController.text = "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      }
      
      // Update time controller
      if (selectedTime != null) {
        _timeController.text = selectedTime!.format(context);
      }
    });});
  }

  void _initializeControllers() {
    _eventNameController = TextEditingController(text: widget.event.eventName);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _ticketPriceController =
        TextEditingController(text: widget.event.ticketPrice?.toString());
    _instagramLinkController =
        TextEditingController(text: widget.event.instagramLink);
    _facebookLinkController =
        TextEditingController(text: widget.event.facebookLink);
    _emailController = TextEditingController(text: widget.event.email);
    _seatAvailabilityCountController = TextEditingController(
        text: widget.event.seatAvailabilityCount?.toString());
    _eventDurationTimeController =
        TextEditingController(text: widget.event.eventDurationTime?.toString());
    _specialInstructionController =
        TextEditingController(text: widget.event.specialInstruction);
    _locationController = TextEditingController(text: widget.event.location);
    // Date and Time
      _dateController = TextEditingController();
    if (widget.event.date != null) {
    _dateController.text = "${widget.event.date!.day}/${widget.event.date!.month}/${widget.event.date!.year}";
  }
  
  // Initialize time controller empty - will be set in initState's post-frame callback
  _timeController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose all controllers
    _eventNameController.dispose();
    _descriptionController.dispose();
    _ticketPriceController.dispose();
    _instagramLinkController.dispose();
    _facebookLinkController.dispose();
    _emailController.dispose();
    _seatAvailabilityCountController.dispose();
    _eventDurationTimeController.dispose();
    _specialInstructionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              CstmText(
                text: 'Add Event Image',
                fontSize: 15,
                color: white,
              ),
              SizedBox(height: 10),

              EditEventImage(
                size: MediaQuery.of(context).size,
                pickImage: (XFile image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
                initialImageUrl: widget.event.uploadedImageUrl, // Existing image URL
                initialXFile: _selectedImage, // Add this line
              ),

              // Rest of the form fields remain the same
              const SizedBox(height: 10),
              _eventNameField(),
              const SizedBox(height: 28),
              _buildDateTimeFields(),
              const SizedBox(height: 28),
              _buildDescriptionField(),
              const SizedBox(height: 28),
              _buildLocationField(),
              const SizedBox(height: 28),
              _eventDurationTime(),
              const SizedBox(height: 28),
              _ticketAndSeatAvailabilityFields(),
              const SizedBox(height: 28),
              _buildPerformanceType(MediaQuery.of(context).size),
              const SizedBox(height: 28),
              _buildGenreTypeSelecting(),
              const SizedBox(height: 28),
              _emailField(),
              const SizedBox(height: 28),
              _facebookLinkField(),
              const SizedBox(height: 28),
              _instagramLinkField(),
              const SizedBox(height: 28),
              _specialInstructionField(),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: const Text(
                  'Event Rules & Requirements',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
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
          ),
        ),
      ),
    );
  }

  //! EVENT NAME FIELD
  Widget _eventNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _eventNameController,
          decoration: InputDecoration(
            hintText: "Event Name",
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
              return 'Please enter your Event name';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(color: Colors.white),
          enableInteractiveSelection: true,
          readOnly: false,
        ),
      ],
    );
  }

  //! DATE AND TIME FIELD
  Widget _buildDateTimeFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Date', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select Date",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(0.2),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: purple),
                    onPressed: () => _selectDate(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select date';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Time', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select Time",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(0.2),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time, color: purple),
                    onPressed: () => _selectTime(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select time';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        ),
      ],
    );
  }

  //! EVENT DESCRIPTION  FIELD
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
          enableInteractiveSelection: true,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CstmText(text: '40', fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  //! LOCATION FIELD
  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _locationController,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: 'Add Location',
            hintStyle: GoogleFonts.aBeeZee(
              color: white,
              fontWeight: FontWeight.w300,
            ),
            filled: true,
            fillColor: grey.withOpacity(0.1),
            prefixIcon: Icon(
              Icons.location_on,
              color: purple,
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

  //! EVENT DURATION TIME
  Widget _eventDurationTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Event Duration', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller:
              _eventDurationTimeController, // Assuming you have a controller for this field
          decoration: InputDecoration(
            hintText: "Duration in hours (e.g., 2 hours)",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            // Allow the field to be empty (null or empty value)
            if (value == null || value.isEmpty) {
              return null; // No validation error, it's optional
            }

            // Check if the input is a valid numeric duration (e.g., 2 hours, 90 minutes)
            if (!RegExp(r'^\d+(\s+hours|\s+minutes)?$').hasMatch(value)) {
              return 'Please enter a valid duration (e.g., 2 hours or 30 minutes)';
            }

            return null; // Valid value
          },
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

//! TICKET PRICE
  Widget ticketPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _ticketPriceController,
          decoration: InputDecoration(
            hintText: "Ticket Price",
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
              return 'Please enter the ticket price';
            }
            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
              return 'Please enter a valid price (e.g., 10 or 10.50)';
            }
            if (double.tryParse(value)! <= 0) {
              return 'Price must be greater than zero';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

//! SEAT AVAILABILITY FIELD AND AVAILABLE SEAT FOR THE EVENT
  Widget _ticketAndSeatAvailabilityFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Price', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ticketPriceController,
                decoration: InputDecoration(
                  hintText: "Ticket Price",
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
                    return 'Please enter your Ticket Price';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter a valid Price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16), // Space between the two fields
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Seat Availability',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _seatAvailabilityCountController,
                decoration: InputDecoration(
                  hintText: "Enter seat availability",
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
                    return 'Please enter the seat availability';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter a valid number of seats';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Seat availability must be greater than zero';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        ),
      ],
    );
  }

  //! TYPE OF EVENT FIELD(SOLO/ENSEMBLE)
Widget _buildPerformanceType(dynamic size) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Type of Performance',
        style: TextStyle(color: Colors.white)
      ),
      SizedBox(
        height: size.height * 0.18,
        child: EditSelectedEventType(
          onSelectionChanged: (index) {
            setState(() {
              _selectedEventTypeIndex = index;
            });
          },
          // Pass the initial selected index when the page loads
          initialSelectedIndex: widget.event.performanceType,
          // Modify the constructor to accept and use the initial selection
          initialSelection: widget.event.performanceType,
        ),
      ),
    ],
  );
}

//! GENRE TYPE OF EVENT
  Widget _buildGenreTypeSelecting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose a Music Genre',
            style: TextStyle(color: Colors.white)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.12,
          child: EditGenreSelected(
            onGenreSelected: (value) {
              setState(() {
                selectedGenre = value;
              });
            },
            // Pass the initial genre from the event
            initialGenre: widget.event.genreType,
          ),
        ),
        if (selectedGenre != null && selectedGenre!.isNotEmpty)
          Text(
            "Selected Genre: $selectedGenre",
            style: TextStyle(color: Colors.white),
          ),
      ],
    );
  }

  //! EMAIL FIELD FOR CONTACT SUPPORT
  Widget _emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Your Email",
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
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: true,
          readOnly: false,
        ),
      ],
    );
  }

  //! FACEBOOK LINK FIELD
  Widget _facebookLinkField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Facebook Profile Link',
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _facebookLinkController,
          decoration: InputDecoration(
            hintText: "Enter Facebook profile URL",
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
              return null;
            }
            // Check if the URL matches Facebook profile link pattern
            if (!RegExp(
                    r'^(https?:\/\/)?(www\.)?facebook\.com\/[a-zA-Z0-9.]+\/?$')
                .hasMatch(value)) {
              return 'Please enter a valid Facebook profile link';
            }
            return null;
          },
          keyboardType: TextInputType.url,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: true,
          readOnly: false,
        ),
      ],
    );
  }

//! INSTAGRAM LINK FIELD
  Widget _instagramLinkField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Instagram Profile Link',
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _instagramLinkController,
          decoration: InputDecoration(
            hintText: "Enter Instagram profile URL",
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
              return null;
            }
            // Check if the URL matches Instagram profile link pattern
            if (!RegExp(
                    r'^(https?:\/\/)?(www\.)?instagram\.com\/[a-zA-Z0-9._]+\/?$')
                .hasMatch(value)) {
              return 'Please enter a valid Instagram profile link';
            }
            return null;
          },
          keyboardType: TextInputType.url,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: true,
          readOnly: false,
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
      text: 'Update Event',
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {

               File? imageFile;
            if (_selectedImage != null) {
              imageFile = File(_selectedImage!.path);
            }
            // Validate required fields (similar to original submit method)
            if (_selectedEventTypeIndex == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please select a performance type')),
              );
              return;
            }

            if (selectedGenre == null || selectedGenre!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a genre')),
              );
              return;
            }

            if (selectedDate == null || selectedTime == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select date and time')),
              );
              return;
            }

            // Create updated event modal
            final updatedEvent = EventHostingModal(
              organizerId: widget.event.organizerId,
              eventId: widget.event.eventId, // Keep the original event ID
              eventName: _eventNameController.text,
              organizerName: widget
                  .event.organizerName, // Maintain original organizer name
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
              uploadedImageUrl:
                  widget.event.uploadedImageUrl, // Maintain original image URL
            );

            // Convert XFile to File if new image is selected
          

            // Update event data and image
            await _eventService.updateEvent(updatedEvent, image: imageFile);

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event updated successfully!')),
            );

            // Navigate back to the previous screen
            Navigator.pop(context, true); // Indicates successful update
          } catch (e) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating event: ${e.toString()}')),
            );
          }
        }
      },
    );
  }

  void _clearForm() {
    _eventNameController.clear();

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

  // Add these functions in your _EditEventPageState class:
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
