import 'package:flutter_test/flutter_test.dart';
import 'package:ut_lloyd_web_app/model/ordermanagement/deliveryorders/milestoneplan_model.dart';
import 'package:ut_lloyd_web_app/model/ordermanagement/deliveryorders/vehical_milstone_response_model.dart';

void main() {
  test('VehicleMilestoneResponse tolerates string/num/bool type mismatches',
      () {
    final r = VehicleMilestoneResponse.fromJson({
      'vehicleTransactionId': '42',
      'cdoMasterId': 7.0,
      'vrn': 12345,
      'transactionCode': 'TX1',
      'milestonePlan': [
        {'sequence': '2', 'milestoneCode': 'M1', 'status': 1},
      ],
      'productAllocation': null,
    });
    expect(r.vehicleTransactionId, 42);
    expect(r.cdoMasterId, 7);
    expect(r.vrn, '12345');
    expect(r.milestonePlan!.first.sequence, 2);
  });

  test('MilestonePlanResponseModel tolerates string numbers', () {
    final m = MilestonePlanResponseModel.fromJson({
      'jobMilestoneId': '5',
      'milestoneSequence': '3',
      'milestoneActionsTracking': null,
    });
    expect(m.jobMilestoneId, 5);
    expect(m.milestoneSequence, 3);
  });
}
