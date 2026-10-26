import '../../../utilities/json_parsers.dart';

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
      jobMilestoneId: asInt(json['jobMilestoneId']),
      elvId: asInt(json['elvId']),
      vehicleTransactionId: asInt(json['vehicleTransactionId']),
      milestoneTransactionCode: asString(json['milestoneTransactionCode']),
      milestone: asString(json['milestone']),
      milestoneCode: asString(json['milestoneCode']),
      milestoneDescription: asString(json['milestoneDescription']),
      milestioneEvent: asString(json['milestioneEvent']),
      milestoneSequence: asInt(json['milestoneSequence']),
      locationCode: asString(json['locationCode']),
      locationName: asString(json['locationName']),
      actualLane: asString(json['actualLane']),
      expectedLane: asString(json['expectedLane']),
      isRequiredMilestone: asBool(json['isRequiredMilestone']),
      isActive: asBool(json['isActive']),
      status: asString(json['status']),
      remarks: asString(json['remarks']),
      milestoneBeginTime: asString(json['milestoneBeginTime']),
      milestoneCompletionTime: asString(json['milestoneCompletionTime']),
      isMilestoneSouceUpdated: asBool(json['isMilestoneSouceUpdated']),
      currentAllocationStrategy: asString(json['currentAllocationStrategy']),
      isOptional: asBool(json['isOptional']),
      timeTakenToCompleteMilestone:
          asString(json['timeTakenToCompleteMilestone']),
      timeTakenToCompleteMilestoneTransaction:
          asString(json['timeTakenToCompleteMilestoneTransaction']),
      totalTimeTakenToCompleteTransaction:
          asString(json['totalTimeTakenToCompleteTransaction']),
      elvCode: asString(json['elvCode']),
      imagePath: asString(json['imagePath']),
      milestoneActionsTracking: json['milestoneActionsTracking'] is List
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
      milestoneActionsTrackingId: asInt(json['milestoneActionsTrackingId']),
      jobMilestoneId: asInt(json['jobMilestoneId']),
      milestoneAction: asString(json['milestoneAction']),
      actionCode: asString(json['actionCode']),
      sequence: asInt(json['sequence']),
      isRequired: asBool(json['isRequired']),
      isActive: asBool(json['isActive']),
      status: asString(json['status']),
      isDependentOnAllPrevious: asBool(json['isDependentOnAllPrevious']),
      completionTime: asString(json['completionTime']),
      remarks: asString(json['remarks']),
      canByPassFromUI: asBool(json['canByPassFromUI']),
      deviceType: asString(json['deviceType']),
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
