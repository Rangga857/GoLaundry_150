import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Marker? _pickedMarker;
  String? _pickedAddress;
  String? _currentAddress;
  CameraPosition? _initialCamera;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _setupLocation();
  }
  Future<void> _setupLocation() async {
    try {
      final pos = await _getPermissions();
      _currentPosition = pos;
      _initialCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 15.0, 
      );

      final placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      final p = placemarks.first;
      _currentAddress = '${p.street}, ${p.locality}, ${p.subAdministrativeArea}, ${p.administrativeArea}, ${p.country}';

      setState(() {});
    } catch (e) {
      setState(() {});
      _showSnackBar('Error: ${e.toString()}'); 
    }
  }

  Future<Position> _getPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Layanan lokasi dinonaktifkan. Harap aktifkan layanan lokasi Anda.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Izin lokasi ditolak. Aplikasi memerlukan izin lokasi.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak secara permanen. Silakan buka pengaturan aplikasi untuk mengaktifkannya.';
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _onMapTap(LatLng latLng) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _pickedMarker = Marker(
            markerId: const MarkerId('pickedLocation'),
            position: latLng,
            infoWindow: InfoWindow(
              title: p.name?.isNotEmpty == true ? p.name : 'Lokasi Dipilih',
              snippet: '${p.street}, ${p.locality}',
            ),
          );
          _pickedAddress = '${p.street}, ${p.locality}, ${p.subAdministrativeArea}, ${p.administrativeArea}, ${p.country}, ${p.postalCode}';
        });
        final controller = await _controller.future;
        await controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
      } else {
        setState(() {
          _pickedMarker = Marker(
            markerId: const MarkerId('pickedLocation'),
            position: latLng,
            infoWindow: InfoWindow(
              title: 'Lokasi Dipilih',
              snippet: 'Lat: ${latLng.latitude.toStringAsFixed(6)}, Lng: ${latLng.longitude.toStringAsFixed(6)}',
            ),
          );
          _pickedAddress = 'Lat: ${latLng.latitude.toStringAsFixed(6)}, Lng: ${latLng.longitude.toStringAsFixed(6)} (Alamat tidak ditemukan)';
        });
        final controller = await _controller.future;
        await controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
        _showSnackBar('Tidak dapat menemukan alamat untuk lokasi ini.');
      }
    } catch (e) {
      _showSnackBar('Gagal mendapatkan alamat: ${e.toString()}');
    }
  }

  void _confirmSelection() {
    if (_pickedMarker == null || _pickedAddress == null) {
      _showSnackBar('Silakan pilih lokasi di peta terlebih dahulu.');
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColors.white,
        title: const Text(
          'Konfirmasi Alamat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
            fontSize: 20,
          ),
        ),
        content: Text(
          _pickedAddress!,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.black87,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
            ),
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pop(
                context,
                {
                  'address': _pickedAddress,
                  'latitude': _pickedMarker!.position.latitude,
                  'longitude': _pickedMarker!.position.longitude,
                },
              );
            },
            child: const Text(
              'Pilih',
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCamera == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Lokasi Laundry', 
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            fontSize: 20, 
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: AppColors.primaryBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), 
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white), 
          onPressed: () => context.pop(), 
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: AppColors.white),
            tooltip: 'Lokasi Saya Saat Ini',
            onPressed: () async {
              if (_currentPosition != null) {
                final controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    16,
                  ),
                );
              } else {
                _showSnackBar('Lokasi saat ini tidak tersedia.');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GoogleMap(
                initialCameraPosition: _initialCamera!,
                myLocationEnabled: true,
                myLocationButtonEnabled: false, 
                mapType: MapType.normal,
                onMapCreated: (controller) => _controller.complete(controller),
                markers: _pickedMarker != null ? {_pickedMarker!} : {},
                onTap: _onMapTap,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _currentAddress ?? 'Mencari lokasi Anda...',
                        style: const TextStyle(fontSize: 14, color: AppColors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_pickedAddress != null)
              Positioned(
                bottom: 100, 
                left: 16,
                right: 16,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  elevation: 6, 
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.location_pin, color: Colors.green), 
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _pickedAddress!,
                            style: const TextStyle(fontSize: 15, color: AppColors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_pickedAddress != null) ...[
            FloatingActionButton.extended(
              onPressed: _confirmSelection,
              heroTag: 'confirm_selection', 
              backgroundColor: AppColors.primaryBlue,
              icon: const Icon(Icons.check, color: AppColors.white),
              label: const Text('Pilih Alamat Ini', style: TextStyle(color: AppColors.white)),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _pickedMarker = null;
                  _pickedAddress = null;
                });
                _showSnackBar('Pilihan lokasi dihapus.');
              },
              heroTag: 'clear_selection', 
              backgroundColor: AppColors.red,
              icon: const Icon(Icons.clear, color: AppColors.white), 
              label: const Text('Hapus Pilihan', style: TextStyle(color: AppColors.white)),
            ),
          ]
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
    );
  }
}
