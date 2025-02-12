import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:rideshare/models/ride.dart';

class RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback? onDelete;
  final VoidCallback? onBook;

  const RideCard({
    super.key,
    required this.ride,
    this.onDelete,
    this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLocationRow(LucideIcons.mapPin, ride.origin),
                      const SizedBox(height: 8),
                      _buildLocationRow(LucideIcons.mapPin, ride.destination),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildInfoRow(
                      LucideIcons.calendar,
                      DateFormat('MMM d, y').format(ride.date),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(LucideIcons.clock, ride.departureTime),
                  ],
                ),
              ],
            ),

            if (ride.stops.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Stops:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ride.stops.map((stop) => Chip(
                  label: Text(stop),
                  backgroundColor: Colors.indigo.shade50,
                  labelStyle: const TextStyle(color: Colors.indigo),
                )).toList(),
              ),
            ],

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(
                  LucideIcons.users,
                  '${ride.availableSeats} seats',
                ),
                _buildInfoRow(
                  LucideIcons.dollarSign,
                  '\$${ride.pricePerSeat}/seat',
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text('Vehicle: ${ride.vehicleModel}'),
            Text('Registration: ${ride.vehicleRegistration}'),

            if (ride.profile != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Icon(LucideIcons.user),
                ),
                title: Text(ride.profile!['full_name'] ?? 'Unknown'),
                subtitle: Text(ride.profile!['phone'] ?? ''),
              ),
            ],

            if (onDelete != null || onBook != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(LucideIcons.trash2),
                      color: Colors.red,
                      onPressed: onDelete,
                    ),
                  if (onBook != null)
                    ElevatedButton(
                      onPressed: onBook,
                      child: const Text('Book Seat'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.indigo),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.indigo),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}