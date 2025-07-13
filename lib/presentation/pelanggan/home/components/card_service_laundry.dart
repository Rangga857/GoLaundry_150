import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/data/model/response/servicelaundry/get_all_service_laundry_response_model.dart';
import 'package:laundry_app/core/constants/constants.dart';

class CardServiceLaundry extends StatelessWidget {
  final DatumService serviceLaundry;

  const CardServiceLaundry({
    super.key,
    required this.serviceLaundry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: AppColors.primaryBlueDark,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceLaundry.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white, 
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4), 

                const SizedBox(height: 8), 
                Text(
                  serviceLaundry.subTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColors.lightGrey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Rp${serviceLaundry.pricePerKg}/Kg',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(221, 255, 255, 255), 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}