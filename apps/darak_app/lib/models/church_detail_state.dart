import 'package:freezed_annotation/freezed_annotation.dart';

import 'church.dart';
import 'church_member.dart';

part 'church_detail_state.freezed.dart';

/// ChurchDetailViewModel 상태 모델
@freezed
class ChurchDetailState with _$ChurchDetailState {
  const factory ChurchDetailState({
    required Church church,
    ChurchMember? currentMember, // null이면 비멤버
    required bool isAdmin,
  }) = _ChurchDetailState;
}
