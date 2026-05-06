import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:okados/config/config.dart';
import 'package:okados/model/user.dart';
import 'package:okados/order/payment.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderAddress extends StatefulWidget {
  const OrderAddress({super.key});

  @override
  State<OrderAddress> createState() => _OrderAddressState();
}

class _OrderAddressState extends State<OrderAddress> {
  LatLng _markerPosition = LatLng(28.565210, 77.28650); // Default coordinates
  double _latitude = 28.565210; // Default latitude
  double _longitude = 77.28650; // Default longitude
  double _zoomLevel = 16.0;
  final MapController _mapController = MapController(); // Add MapController
  UserModel? _user;
  bool isLoadingUpdate = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLatLong();
    _requestPermission();
    getAddress();
  }

  // Function to update marker and store lat/lng
  void _updateMarker(LatLng newPosition) {
    setState(() {
      _latitude = newPosition.latitude;
      _longitude = newPosition.longitude;
      _markerPosition = newPosition;
    });
    storeLatLong(newPosition.latitude, newPosition.longitude);
    _mapController.move(newPosition, _zoomLevel);
  }

  Future<void> _requestPermission() async {
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      _getCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _markerPosition = LatLng(_latitude, _longitude);
    });
    storeLatLong(position.latitude, position.longitude);
    _mapController.move(_markerPosition, _zoomLevel);
  }

  void storeLatLong(latitude, longitude) async {
    final pref = await SharedPreferences.getInstance();
    Map<String, double> latLong = {
      "latitude": latitude,
      "longitude": longitude
    };
    String latLongJson = json.encode(latLong);
    await pref.setString("LatLong", latLongJson);
  }

  void getLatLong() async {
    final pref = await SharedPreferences.getInstance();
    String? latLongJson = pref.getString("LatLong");
    if (latLongJson != null) {
      Map<String, double> latLong =
          Map<String, double>.from(jsonDecode(latLongJson));
      _latitude = latLong['latitude']!.toDouble();
      _longitude = latLong['longitude']!.toDouble();
    } else {
      print("No LatLong data found");
    }
  }

  // Listen to zoom level change
  void _onMapPositionChanged(MapPosition position, bool hasGesture) {
    setState(() {
      _zoomLevel = position.zoom ?? 15.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Address",
          style: TextStyle(color: whiteColor),
        ),
        iconTheme: const IconThemeData(
          color: whiteColor,
        ),
        centerTitle: true,
        elevation: 4.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBackgroundColor, whiteColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Display map
                  map(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  useMyLocation(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  address(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TrackPath(),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    saveAddress();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (contex) => Payment()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    "Payment Next ",
                    style: TextStyle(fontSize: 16, color: whiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget TrackPath() {
    return Container(
      decoration: const BoxDecoration(
          color: primaryBackgroundColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: greenColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "1",
                  style: TextStyle(fontSize: 10, color: whiteColor),
                )),
              ),
              const Text("Cart",
                  style: TextStyle(fontSize: 15, color: whiteColor)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width * 0.25,
              color: greenColor,
            ),
          ),
          Column(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: blackColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "2",
                  style: TextStyle(fontSize: 10, color: whiteColor),
                )),
              ),
              const Text("Address",
                  style: TextStyle(fontSize: 15, color: whiteColor)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width * 0.25,
              color: whiteColor,
            ),
          ),
          Column(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "3",
                  style: TextStyle(fontSize: 10),
                )),
              ),
              const Text("Payment",
                  style: TextStyle(fontSize: 15, color: whiteColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget map() {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.only(bottom: 8.0),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _markerPosition,
          onPositionChanged: _onMapPositionChanged, // Track zoom changes
          zoom: _zoomLevel,
          onTap: (tapPosition, latlng) {
            _updateMarker(latlng); // Update marker on tap
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _markerPosition,
                width: 80.0,
                height: 80.0,
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget useMyLocation() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Use My Current Location : ",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: blackColor),
          ),
          InkWell(
            onTap: () {
              _requestPermission();
            },
            child: const Icon(
              Icons.my_location, // Specify the correct icon
              color: primaryColor, // Optional: Set icon color
              size: 24.0, // Optional: Set icon size
            ),
          ),
        ],
      ),
    );
  }

  Widget address() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "Details / Address :",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: "Enter your name",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person, color: secondaryColor),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _phoneNumberController,
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: const InputDecoration(
              hintText: "Enter your Phone Number",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone, color: secondaryColor),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              hintText: "Enter your address",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home, color: secondaryColor),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _landmarkController,
            decoration: const InputDecoration(
              hintText: "Enter your Landmark",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on, color: secondaryColor),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _pincodeController,
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: const InputDecoration(
              hintText: "Enter your Pincode",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers, color: secondaryColor),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              hintText: "Enter your City",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_city, color: secondaryColor),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _stateController,
            decoration: const InputDecoration(
              hintText: "Enter your State",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.public, color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('User');
    if (userString != null) {
      final userJson = jsonDecode(userString);
      _user = UserModel.fromJson(userJson);
      setState(() {
        _usernameController.text = _user?.username.toString() ?? '';
        _phoneNumberController.text = _user?.phoneNumber.toString() ?? '';
        _emailController.text = _user?.email.toString() ?? '';
        _addressController.text = _user?.address.toString() ?? '';
        _landmarkController.text = _user?.landmark.toString() ?? '';
        _pincodeController.text = _user?.pincode.toString() ?? '';
        _stateController.text = _user?.state.toString() ?? '';
        _cityController.text = _user?.city.toString() ?? '';
      });
    }
  }

  Future<void> saveAddress() async {
    setState(() {
      isLoadingUpdate = true;
    });
    if (_phoneNumberController.text.isEmpty) {
      showSnackBar(context, "Enter Name");
      return;
    }
    if (_phoneNumberController.text.length != 10) {
      showSnackBar(context, "Wrong Number");
      return;
    }
    if (_addressController.text.isEmpty) {
      showSnackBar(context, "Enter Address");
      return;
    }
    if (_landmarkController.text.isEmpty) {
      showSnackBar(context, "Enter Landmark");
      return;
    }
    if (_pincodeController.text.length > 6 ||
        _pincodeController.text.length < 6) {
      showSnackBar(context, "Wrong Pincode");
      return;
    }
    if (_cityController.text.isEmpty) {
      showSnackBar(context, "Enter City");
      return;
    }
    if (_stateController.text.isEmpty) {
      showSnackBar(context, "Enter State");
      return;
    }

    final reqBody = {
      "email": _emailController.text,
      "username": _usernameController.text,
      "phoneNumber": _phoneNumberController.text,
      "address": _addressController.text,
      "landmark": _landmarkController.text,
      "pincode": _pincodeController.text,
      "city": _cityController.text,
      "state": _stateController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(userUpdateAddressApi), // Ensure 'login' is defined correctly
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 400) {
        showSnackBar(context, "Please enter All required fields");
        setState(() {
          isLoadingUpdate = false;
        });
      }

      if (response.statusCode == 404) {
        showSnackBar(context, "User Not Found");
        setState(() {
          isLoadingUpdate = false;
        });
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        final userJson = data['User'];
        UserModel user = UserModel.fromJson(userJson);
        await prefs.setString('User', jsonEncode(user.toJson()));
        setState(() {
          isLoadingUpdate = false;
        });
      }
    } catch (e) {
      showSnackBar(context, "An error occurred: $e");
      setState(() {
        isLoadingUpdate = false;
      });
    } finally {
      setState(() {
        isLoadingUpdate = false;
      });
    }
  }
}
