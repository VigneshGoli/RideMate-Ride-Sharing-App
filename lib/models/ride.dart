class Ride {
  final String id;
  final String riderId;
  final String origin;
  final String destination;
  final DateTime date;
  final String departureTime;
  final int availableSeats;
  final double pricePerSeat;
  final String vehicleModel;
  final String vehicleRegistration;
  final List<String> stops;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic>? profile;

  Ride({
    required this.id,
    required this.riderId,
    required this.origin,
    required this.destination,
    required this.date,
    required this.departureTime,
    required this.availableSeats,
    required this.pricePerSeat,
    required this.vehicleModel,
    required this.vehicleRegistration,
    required this.stops,
    required this.status,
    required this.createdAt,
    this.profile,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      riderId: json['rider_id'],
      origin: json['origin'],
      destination: json['destination'],
      date: DateTime.parse(json['date']),
      departureTime: json['departure_time'],
      availableSeats: json['available_seats'],
      pricePerSeat: json['price_per_seat'].toDouble(),
      vehicleModel: json['vehicle_model'],
      vehicleRegistration: json['vehicle_registration'],
      stops: List<String>.from(json['stops'] ?? []),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      profile: json['profiles'],
    );
  }
}