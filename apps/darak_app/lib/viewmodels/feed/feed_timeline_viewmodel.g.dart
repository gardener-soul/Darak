// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_timeline_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedTimelineViewModelHash() =>
    r'a8acfad98244bc0cfedb9963f0c23bf49a4de1f4';

/// See also [FeedTimelineViewModel].
@ProviderFor(FeedTimelineViewModel)
final feedTimelineViewModelProvider =
    AutoDisposeNotifierProvider<
      FeedTimelineViewModel,
      FeedTimelineState
    >.internal(
      FeedTimelineViewModel.new,
      name: r'feedTimelineViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$feedTimelineViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FeedTimelineViewModel = AutoDisposeNotifier<FeedTimelineState>;
String _$selectedFeedFilterHash() =>
    r'034d6fa6399709a4214b6fc08e48c6a9d8cbe59c';

/// See also [SelectedFeedFilter].
@ProviderFor(SelectedFeedFilter)
final selectedFeedFilterProvider =
    AutoDisposeNotifierProvider<SelectedFeedFilter, FeedFilter>.internal(
      SelectedFeedFilter.new,
      name: r'selectedFeedFilterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedFeedFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedFeedFilter = AutoDisposeNotifier<FeedFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
