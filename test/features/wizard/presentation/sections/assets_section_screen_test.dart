import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/assets/data/asset_repository.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/sections/assets_section_screen.dart';

/// Fake Firestore for testing
class FakeFirestore extends Fake implements FirebaseFirestore {}

/// Fake project repository for testing
class FakeProjectRepository extends ProjectRepository {
  FakeProjectRepository()
    : super(userId: 'test-user', firestore: FakeFirestore());
}

/// Fake assets repository for testing
class FakeAssetRepository extends AssetRepository {
  final List<Asset> _assets = [];
  final StreamController<List<Asset>> _controller =
      StreamController<List<Asset>>.broadcast();

  FakeAssetRepository()
    : super(projectId: 'test-project-id', firestore: FakeFirestore());

  @override
  Stream<List<Asset>> getAssetsStream() {
    // Emit current assets immediately, then listen for changes
    Future.microtask(() => _controller.add(_assets));
    return _controller.stream;
  }

  @override
  Future<void> createAsset(Asset asset) async {
    _assets.add(asset);
    _controller.add(_assets);
  }

  @override
  Future<void> updateAsset(Asset asset) async {
    final id = asset.map(
      realEstate: (a) => a.id,
      rrsp: (a) => a.id,
      celi: (a) => a.id,
      cri: (a) => a.id,
      cash: (a) => a.id,
    );
    final index = _assets.indexWhere(
      (a) =>
          a.map(
            realEstate: (a) => a.id,
            rrsp: (a) => a.id,
            celi: (a) => a.id,
            cri: (a) => a.id,
            cash: (a) => a.id,
          ) ==
          id,
    );
    if (index != -1) {
      _assets[index] = asset;
      _controller.add(_assets);
    }
  }

  @override
  Future<void> deleteAsset(String assetId) async {
    _assets.removeWhere(
      (a) =>
          a.map(
            realEstate: (a) => a.id,
            rrsp: (a) => a.id,
            celi: (a) => a.id,
            cri: (a) => a.id,
            cash: (a) => a.id,
          ) ==
          assetId,
    );
    _controller.add(_assets);
  }

  List<Asset> get assets => _assets;

  void dispose() {
    _controller.close();
  }
}

/// Mock notifier for CurrentProjectProvider
class MockCurrentProjectNotifier extends CurrentProjectNotifier {
  final CurrentProjectState mockState;

  MockCurrentProjectNotifier(
    this.mockState,
    Ref ref,
    FakeProjectRepository repo,
  ) : super(ref, null, repo) {
    state = mockState;
  }
}

/// Mock notifier for WizardProgressProvider
class MockWizardProgressNotifier extends WizardProgressNotifier {
  final WizardProgress? mockProgress;
  final List<MapEntry<String, WizardSectionStatus>> statusUpdates = [];

  MockWizardProgressNotifier(this.mockProgress);

  @override
  Future<WizardProgress?> build() async {
    return mockProgress;
  }

  @override
  Future<void> updateSectionStatus(
    String sectionId,
    WizardSectionStatus status,
  ) async {
    statusUpdates.add(MapEntry(sectionId, status));
  }
}

void main() {
  group('AssetsSectionScreen', () {
    late Project testProject;
    late WizardProgress testProgress;
    late FakeProjectRepository fakeProjectRepository;
    late FakeAssetRepository fakeAssetRepository;
    late MockWizardProgressNotifier mockNotifier;

    setUp(() {
      final now = DateTime.now();
      testProject = Project(
        id: 'test-project-id',
        name: 'Test Project',
        ownerId: 'test-user',
        createdAt: now,
        updatedAt: now,
        individuals: [],
      );

      testProgress = WizardProgress.create(
        projectId: testProject.id,
        userId: 'test-user',
      );

      fakeProjectRepository = FakeProjectRepository();
      fakeAssetRepository = FakeAssetRepository();
      mockNotifier = MockWizardProgressNotifier(testProgress);
    });

    tearDown(() {
      fakeAssetRepository.dispose();
    });

    Widget buildAssetsScreen({
      void Function(Future<bool> Function()?)? onRegisterCallback,
    }) {
      return ProviderScope(
        overrides: [
          currentProjectProvider.overrideWith(
            (ref) => MockCurrentProjectNotifier(
              ProjectSelected(testProject),
              ref,
              fakeProjectRepository,
            ),
          ),
          projectRepositoryProvider.overrideWithValue(fakeProjectRepository),
          assetRepositoryProvider.overrideWithValue(fakeAssetRepository),
          wizardProgressProvider.overrideWith(() => mockNotifier),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AssetsSectionScreen(onRegisterCallback: onRegisterCallback),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('loads with empty assets list', (tester) async {
        await tester.pumpWidget(buildAssetsScreen());
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('No assets yet'), findsOneWidget);
        expect(find.text('Add Asset'), findsOneWidget);
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildAssetsScreen(
            onRegisterCallback: (callback) {
              registeredCallback = callback;
            },
          ),
        );
        await tester.pump();
        await tester.pumpAndSettle();

        expect(registeredCallback, isNotNull);
      });

      testWidgets('marks section as in progress after loading', (tester) async {
        await tester.pumpWidget(buildAssetsScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.first.key, 'assets');
        expect(
          mockNotifier.statusUpdates.first.value.state,
          WizardSectionState.inProgress,
        );
      });
    });

    group('Optional Section Behavior', () {
      testWidgets('allows skipping when no assets added', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildAssetsScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Clear previous status updates
        mockNotifier.statusUpdates.clear();

        final result = await validationCallback!();
        await tester.pumpAndSettle();

        expect(result, isTrue); // Should allow navigation
        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.last.key, 'assets');
        expect(
          mockNotifier.statusUpdates.last.value.state,
          WizardSectionState.skipped,
        );
      });

      testWidgets('marks as complete when assets exist', (tester) async {
        Future<bool> Function()? validationCallback;

        // Add an asset to the repository
        final asset = Asset.realEstate(
          id: 'asset-1',
          type: RealEstateType.house,
          value: 500000,
        );
        await fakeAssetRepository.createAsset(asset);

        await tester.pumpWidget(
          buildAssetsScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Clear previous status updates
        mockNotifier.statusUpdates.clear();

        final result = await validationCallback!();
        await tester.pumpAndSettle();

        expect(result, isTrue); // Should allow navigation
        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.last.key, 'assets');
        expect(
          mockNotifier.statusUpdates.last.value.state,
          WizardSectionState.complete,
        );
      });
    });

    group('Widget Structure', () {
      testWidgets('contains Add Asset button', (tester) async {
        await tester.pumpWidget(buildAssetsScreen());
        await tester.pumpAndSettle();

        expect(find.text('Add Asset'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('shows empty state when no assets', (tester) async {
        await tester.pumpWidget(buildAssetsScreen());
        await tester.pumpAndSettle();

        expect(find.text('No assets yet'), findsOneWidget);
        expect(
          find.text(
            'Add your first asset to get started, or skip this section',
          ),
          findsOneWidget,
        );
        expect(
          find.byIcon(Icons.account_balance_wallet_outlined),
          findsOneWidget,
        );
      });

      testWidgets('displays help text', (tester) async {
        await tester.pumpWidget(buildAssetsScreen());
        await tester.pumpAndSettle();

        expect(
          find.text('Click "Next" to continue, or "Skip" to skip asset entry'),
          findsOneWidget,
        );
      });
    });

    group('Assets Display', () {
      testWidgets('displays assets when they exist', (tester) async {
        // Add an asset to the repository
        final asset = Asset.realEstate(
          id: 'asset-1',
          type: RealEstateType.house,
          value: 500000,
        );
        await fakeAssetRepository.createAsset(asset);

        await tester.pumpWidget(buildAssetsScreen());
        await tester.pumpAndSettle();

        // Should not show empty state
        expect(find.text('No assets yet'), findsNothing);
        // Should show asset list
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('displays multiple assets', (tester) async {
        // Add multiple assets
        await fakeAssetRepository.createAsset(
          Asset.realEstate(
            id: 'asset-1',
            type: RealEstateType.house,
            value: 500000,
          ),
        );
        await fakeAssetRepository.createAsset(
          Asset.rrsp(
            id: 'asset-2',
            individualId: 'individual-1',
            value: 100000,
          ),
        );

        await tester.pumpWidget(buildAssetsScreen());
        await tester.pumpAndSettle();

        // Should show asset list
        expect(find.byType(ListView), findsOneWidget);
        // Should not show empty state
        expect(find.text('No assets yet'), findsNothing);
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(buildAssetsScreen(onRegisterCallback: null));
        await tester.pumpAndSettle();

        expect(find.byType(AssetsSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(
          buildAssetsScreen(
            onRegisterCallback: (callback) {
              callbackCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(callbackCalled, isTrue);
      });
    });

    group('Validation Callback', () {
      testWidgets('validation callback always returns true', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildAssetsScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isTrue);
      });
    });
  });
}
