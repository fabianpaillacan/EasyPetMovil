class Appointment {
  final String appointmentId;
  final String petId;
  final String veterinarianId;
  final String medicalCenterId;
  final String appointmentType;
  final String scheduledDate;
  final int durationMinutes;
  final String? notes;
  final String status;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  Appointment({
    required this.appointmentId,
    required this.petId,
    required this.veterinarianId,
    required this.medicalCenterId,
    required this.appointmentType,
    required this.scheduledDate,
    required this.durationMinutes,
    this.notes,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'] ?? json['_id'] ?? '',
      petId: json['pet_id'] ?? '',
      veterinarianId: json['veterinarian_id'] ?? '',
      medicalCenterId: json['medical_center_id'] ?? '',
      appointmentType: json['appointment_type'] ?? '',
      scheduledDate: json['scheduled_date'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      notes: json['notes'],
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'pet_id': petId,
      'veterinarian_id': veterinarianId,
      'medical_center_id': medicalCenterId,
      'appointment_type': appointmentType,
      'scheduled_date': scheduledDate,
      'duration_minutes': durationMinutes,
      'notes': notes,
      'status': status,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Appointment copyWith({
    String? appointmentId,
    String? petId,
    String? veterinarianId,
    String? medicalCenterId,
    String? appointmentType,
    String? scheduledDate,
    int? durationMinutes,
    String? notes,
    String? status,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
  }) {
    return Appointment(
      appointmentId: appointmentId ?? this.appointmentId,
      petId: petId ?? this.petId,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      medicalCenterId: medicalCenterId ?? this.medicalCenterId,
      appointmentType: appointmentType ?? this.appointmentType,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Appointment(appointmentId: $appointmentId, petId: $petId, veterinarianId: $veterinarianId, medicalCenterId: $medicalCenterId, appointmentType: $appointmentType, scheduledDate: $scheduledDate, durationMinutes: $durationMinutes, notes: $notes, status: $status, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Appointment &&
        other.appointmentId == appointmentId &&
        other.petId == petId &&
        other.veterinarianId == veterinarianId &&
        other.medicalCenterId == medicalCenterId &&
        other.appointmentType == appointmentType &&
        other.scheduledDate == scheduledDate &&
        other.durationMinutes == durationMinutes &&
        other.notes == notes &&
        other.status == status &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return appointmentId.hashCode ^
        petId.hashCode ^
        veterinarianId.hashCode ^
        medicalCenterId.hashCode ^
        appointmentType.hashCode ^
        scheduledDate.hashCode ^
        durationMinutes.hashCode ^
        notes.hashCode ^
        status.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
