

class MilestonePlanResponseModel {
  final int? jobMilestoneId;
  final int? elvId;
  final int? vehicleTransactionId;
  final String? milestoneTransactionCode;
  final String? milestone;
  final String? milestoneCode;
  final String? milestoneDescription;
  final String? milestioneEvent; // Keeping original spelling from JSON payload
  final int? milestoneSequence;
  final String? locationCode;
  final String? locationName;
  final String? actualLane;
  final String? expectedLane;
  final bool? isRequiredMilestone;
  final bool? isActive;
  final String? status;
  final String? remarks;
  final String? milestoneBeginTime;
  final String? milestoneCompletionTime;
  final bool? isMilestoneSouceUpdated;
  final String? currentAllocationStrategy;
  final bool? isOptional;
  final String? timeTakenToCompleteMilestone;
  final String? timeTakenToCompleteMilestoneTransaction;
  final String? totalTimeTakenToCompleteTransaction;
  final String? elvCode;
  final String? imagePath;
  final List<MilestoneActionsTracking>? milestoneActionsTracking;

  MilestonePlanResponseModel({
    this.jobMilestoneId,
    this.elvId,
    this.vehicleTransactionId,
    this.milestoneTransactionCode,
    this.milestone,
    this.milestoneCode,
    this.milestoneDescription,
    this.milestioneEvent,
    this.milestoneSequence,
    this.locationCode,
    this.locationName,
    this.actualLane,
    this.expectedLane,
    this.isRequiredMilestone,
    this.isActive,
    this.status,
    this.remarks,
    this.milestoneBeginTime,
    this.milestoneCompletionTime,
    this.isMilestoneSouceUpdated,
    this.currentAllocationStrategy,
    this.isOptional,
    this.timeTakenToCompleteMilestone,
    this.timeTakenToCompleteMilestoneTransaction,
    this.totalTimeTakenToCompleteTransaction,
    this.elvCode,
    this.imagePath,
    this.milestoneActionsTracking,
  });

  factory MilestonePlanResponseModel.fromJson(Map<String, dynamic> json) {
    return MilestonePlanResponseModel(
      jobMilestoneId: json['jobMilestoneId'],
      elvId: json['elvId'],
      vehicleTransactionId: json['vehicleTransactionId'],
      milestoneTransactionCode: json['milestoneTransactionCode']?.toString(),
      milestone: json['milestone']?.toString(),
      milestoneCode: json['milestoneCode']?.toString(),
      milestoneDescription: json['milestoneDescription']?.toString(),
      milestioneEvent: json['milestioneEvent']?.toString(),
      milestoneSequence: json['milestoneSequence'],
      locationCode: json['locationCode']?.toString(),
      locationName: json['locationName']?.toString(),
      actualLane: json['actualLane']?.toString(),
      expectedLane: json['expectedLane']?.toString(),
      isRequiredMilestone: json['isRequiredMilestone'],
      isActive: json['isActive'],
      status: json['status']?.toString(),
      remarks: json['remarks']?.toString(),
      milestoneBeginTime: json['milestoneBeginTime']?.toString(),
      milestoneCompletionTime: json['milestoneCompletionTime']?.toString(),
      isMilestoneSouceUpdated: json['isMilestoneSouceUpdated'],
      currentAllocationStrategy: json['currentAllocationStrategy']?.toString(),
      isOptional: json['isOptional'],
      timeTakenToCompleteMilestone:
          json['timeTakenToCompleteMilestone']?.toString(),
      timeTakenToCompleteMilestoneTransaction:
          json['timeTakenToCompleteMilestoneTransaction']?.toString(),
      totalTimeTakenToCompleteTransaction:
          json['totalTimeTakenToCompleteTransaction']?.toString(),
      elvCode: json['elvCode']?.toString(),
      imagePath: json['imagePath']?.toString(),
      milestoneActionsTracking: json['milestoneActionsTracking'] != null
          ? (json['milestoneActionsTracking'] as List)
              .map(
                  (actionJson) => MilestoneActionsTracking.fromJson(actionJson))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobMilestoneId': jobMilestoneId,
      'elvId': elvId,
      'vehicleTransactionId': vehicleTransactionId,
      'milestoneTransactionCode': milestoneTransactionCode,
      'milestone': milestone,
      'milestoneCode': milestoneCode,
      'milestoneDescription': milestoneDescription,
      'milestioneEvent': milestioneEvent,
      'milestoneSequence': milestoneSequence,
      'locationCode': locationCode,
      'locationName': locationName,
      'actualLane': actualLane,
      'expectedLane': expectedLane,
      'isRequiredMilestone': isRequiredMilestone,
      'isActive': isActive,
      'status': status,
      'remarks': remarks,
      'milestoneBeginTime': milestoneBeginTime,
      'milestoneCompletionTime': milestoneCompletionTime,
      'isMilestoneSouceUpdated': isMilestoneSouceUpdated,
      'currentAllocationStrategy': currentAllocationStrategy,
      'isOptional': isOptional,
      'timeTakenToCompleteMilestone': timeTakenToCompleteMilestone,
      'timeTakenToCompleteMilestoneTransaction':
          timeTakenToCompleteMilestoneTransaction,
      'totalTimeTakenToCompleteTransaction':
          totalTimeTakenToCompleteTransaction,
      'elvCode': elvCode,
      'imagePath': imagePath,
      'milestoneActionsTracking':
          milestoneActionsTracking?.map((v) => v.toJson()).toList(),
    };
  }
}

class MilestoneActionsTracking {
  final int? milestoneActionsTrackingId;
  final int? jobMilestoneId;
  final String? milestoneAction;
  final String? actionCode;
  final int? sequence;
  final bool? isRequired;
  final bool? isActive;
  final String? status;
  final bool? isDependentOnAllPrevious;
  final String? completionTime;
  final String? remarks;
  final bool? canByPassFromUI;
  final String? deviceType;

  MilestoneActionsTracking({
    this.milestoneActionsTrackingId,
    this.jobMilestoneId,
    this.milestoneAction,
    this.actionCode,
    this.sequence,
    this.isRequired,
    this.isActive,
    this.status,
    this.isDependentOnAllPrevious,
    this.completionTime,
    this.remarks,
    this.canByPassFromUI,
    this.deviceType,
  });

  factory MilestoneActionsTracking.fromJson(Map<String, dynamic> json) {
    return MilestoneActionsTracking(
      milestoneActionsTrackingId: json['milestoneActionsTrackingId'],
      jobMilestoneId: json['jobMilestoneId'],
      milestoneAction: json['milestoneAction']?.toString(),
      actionCode: json['actionCode']?.toString(),
      sequence: json['sequence'],
      isRequired: json['isRequired'],
      isActive: json['isActive'],
      status: json['status']?.toString(),
      isDependentOnAllPrevious: json['isDependentOnAllPrevious'],
      completionTime: json['completionTime']?.toString(),
      remarks: json['remarks']?.toString(),
      canByPassFromUI: json['canByPassFromUI'],
      deviceType: json['deviceType']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'milestoneActionsTrackingId': milestoneActionsTrackingId,
      'jobMilestoneId': jobMilestoneId,
      'milestoneAction': milestoneAction,
      'actionCode': actionCode,
      'sequence': sequence,
      'isRequired': isRequired,
      'isActive': isActive,
      'status': status,
      'isDependentOnAllPrevious': isDependentOnAllPrevious,
      'completionTime': completionTime,
      'remarks': remarks,
      'canByPassFromUI': canByPassFromUI,
      'deviceType': deviceType,
    };
  }
}
